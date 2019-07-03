The Sigkill.dk generator
===

This is the Hakyll program for generating sigkill.dk (see my [Hakyll
tutorial](/writings/guides/hakyll.html)).  Look at [this Git
repository](https://github.com/Athas/sigkill.dk) for the data files as
well.  The most defining trait of the site is the tree menu at the
top, which contains every content page on the site.  Apart from that,
I also do a lot of small hacks to generate various bits of the site.
There is also a simple blog system, with one file per post.

> {-# LANGUAGE OverloadedStrings #-}
> module Main(main) where

> import Control.Arrow (first, (&&&))
> import Control.Monad
> import Data.Char
> import Data.List hiding (group)
> import Data.Ord
> import Data.Maybe
> import Data.Monoid
> import System.FilePath

> import Text.Blaze.Internal (preEscapedString)
> import Text.Blaze.Html5 ((!))
> import qualified Text.Blaze.Html5 as H
> import qualified Text.Blaze.Html5.Attributes as A
> import Text.Blaze.Html.Renderer.String (renderHtml)
> import           Text.Pandoc
> import           Text.Pandoc.Walk

> import Hakyll

Hierarchical menu.
---

We are going to define a data type and associated helper functions for
generating a menu.  Conceptually, the site is a directory tree, with a
page being a leaf of the tree.  The menu for a given page will
illustrate the path taken from the root to the page, namely which
intermediary directories were entered.

A level (or "line", if you look at its actual visual appearance) of
the menu consists of two lists: the elements preceding and succeeding
the *focused element*.  The focused element itself is the first
element of the `aftItems` list.  This definition ensures that we have
at most a single focused element per menu level.  Each element is a
pair consisting of an URL and a name.

> data MenuLevel = MenuLevel { prevItems :: [(FilePath,String)]
>                            , aftItems  :: [(FilePath,String)]
>                            }
>
> allItems :: MenuLevel -> [(FilePath, String)]
> allItems l = prevItems l ++ aftItems l

> emptyMenuLevel :: MenuLevel
> emptyMenuLevel = MenuLevel [] []

First, let us define a function for inserting an element into a sorted
list, returning the original list if the element is already there.

> insertUniq :: Ord a => a -> [a] -> [a]
> insertUniq x xs | x `elem` xs = xs
>                 | otherwise = insert x xs

We can use this function to insert a non-focused element into a
`MenuLevel`.  We take care to put the new element in its proper sorted
position relative to the focused element, if any.

> insertItem :: MenuLevel -> (FilePath, String) -> MenuLevel
> insertItem l v = case aftItems l of
>                    []     -> atPrev
>                    (x:xs) | v < x     -> atPrev
>                           | otherwise -> l { aftItems = x:insertUniq v xs }
>   where atPrev = l { prevItems = insertUniq v (prevItems l) }

When inserting a focused element, we have to split the elements into
those that go before and those that come after the focused element.

> insertFocused :: MenuLevel -> (FilePath, String) -> MenuLevel
> insertFocused l v = MenuLevel bef (v:aft)
>   where (bef, aft) = partition (<v) (delete v $ allItems l)

Finally, a menu is just a list of menu levels.

> newtype Menu = Menu { menuLevels :: [MenuLevel] }
>
> emptyMenu :: Menu
> emptyMenu = Menu []

I am using the [BlazeHTML](http://jaspervdj.be/blaze/) library for
HTML generation, so the result of rendering a menu is an `H.Html`
value.  The rendering will consist of one HTML `<ul>` block per menu
level, each with the CSS class `menuN`, where `N` is the number of the
level.

> showMenu :: Menu -> H.Html
> showMenu = zipWithM_ showMenuLevel [0..] . menuLevels

The focus element is tagged with the CSS class `thisPage`.

> showMenuLevel :: Int -> MenuLevel -> H.Html
> showMenuLevel d m =
>   H.ul (mapM_ H.li elems) ! A.class_ (H.toValue $ "menu" ++ show d)
>   where showElem (p,k) = H.a (H.toHtml k) ! A.href (H.toValue p)
>         showFocusElem (p,k) = showElem (p,k) ! A.class_ "thisPage"
>         elems = map showElem (prevItems m) ++
>                 case aftItems m of []     -> []
>                                    (l:ls) -> showFocusElem l :
>                                              map showElem ls

Building the menu
---

Recall that the directory structure of the site is a tree.  To
construct a menu, we are given the current node (page) and a list of
all possible nodes of the tree (all pages on the site), and we then
construct the minimum tree that contains all nodes on the path from
the root to the current node, as well as all siblings of those nodes.
In file system terms, we show the files contained in each directory
traversed from the root to the current page (as well as any children
of the current page, if it is a directory).

To begin, we define a function that given the current path, decomposes
some other path into the part that should be visible.  For example:

    relevant "foo/bar/baz" "foo/bar/quux" = ["foo/","bar/","quux"]
    relevant "foo/bar/baz" "foo/bar/quux/" = ["foo/","bar/","quux/"]
    relevant "foo/bar/baz" "foo/bar/quux/zog" = ["foo/","bar/","quux/"]
    relevant "foo/bar/baz" "quux/zog" = ["quux/"]

> relevant :: FilePath -> FilePath -> [FilePath]
> relevant this other = relevant' (splitPath this) (splitPath other)
>   where relevant' (x:xs) (y:ys) = y : if x == y then relevant' xs ys else []
>         relevant' [] (y:_) = [y]
>         relevant' _ _ = []

To construct a full menu given the current path and a list of all
paths, we repeatedly extend it by a single path.  Recall that menu
elements are pairs of names and paths - we generate those names by
taking the file name and dropping the extension of the path, also
dropping any trailing "index.html" from paths.

> buildMenu :: FilePath -> [FilePath] -> Menu
> buildMenu this = foldl (extendMenu this) emptyMenu
>                  . map (first dropIndex . (id &&& dropExtension . takeFileName))
>
> dropIndex :: FilePath -> FilePath
> dropIndex p | takeBaseName p == "index" = dropFileName p
>             | otherwise                 = p

> extendMenu :: FilePath -> Menu -> (FilePath, String) -> Menu
> extendMenu this m (path, name) =
>   if path' `elem` ["./", "/", ""] then m else
>     Menu $ add (menuLevels m) (relevant this' path') "/"
>   where add ls [] _ = ls
>         add ls (x:xs) p
>           | x `elem` focused = insertFocused l (p++x,name') : add ls' xs (p++x)
>           | otherwise        = insertItem l (p++x,name') : add ls' xs (p++x)
>           where (l,ls') = case ls of []  -> (emptyMenuLevel, [])
>                                      k:ks -> (k,ks)
>                 name' = if hasTrailingPathSeparator x then x else name
>         focused = splitPath this'
>         path' = normalise path
>         this' = normalise this

For convenience, we define a Hakyll rule that adds anything currently
matched to the menu.  To do this, we first need two convenience
functions.  The first checks whether the identifier of the current
compilation is defined with some other version (recall that a version
is identified by a `Maybe String`, not just a `String`), and if so,
returns the route of that identifier.

> routeWithVersion :: Maybe String -> Compiler (Maybe FilePath)
> routeWithVersion v = getRoute =<< setVersion v <$> getUnderlying

The second extracts the route for the current identifier with no
version.  As a matter of convenience, we return an empty path if the
identifier has no associated route.  This should never occur in
practice.

> normalRoute :: Compiler FilePath
> normalRoute = fromMaybe "" <$> routeWithVersion Nothing

The `"menu"` version will contain an identifier for every page that
should show up in the site menu, with the compiler for each identifier
generating a pathname.

> addToMenu :: Rules ()
> addToMenu = version "menu" $ compile $ makeItem =<< normalRoute

To generate the menu for a given page, we use `loadAll` to obtain a
list of everything with the version "menu" (the pathnames) and use it
to build the menu, which is immediately rendered to HTML.  If a
compiler has been defined for these identifiers that creates anything
but a `FilePath`, Hakyll will signal a run-time type error.

> getMenu :: Compiler String
> getMenu = do
>   menu <- map itemBody <$> loadAll (fromVersion $ Just "menu")
>   myRoute <- getRoute =<< getUnderlying
>   return $ renderHtml $ showMenu $ case myRoute of
>     Nothing -> buildMenu "" menu
>     Just me -> buildMenu me menu

Extracting descriptive texts from small programs.
---

I have a number of small programs and scripts of my site, and I want
to automatically generate a list and description for each of them.
Each program starts with a descriptive comment containing Markdown
markup, so the challenge becomes extracting that comment.  I define
functions for extracting the leading comment from shell, C and
Haskell, respectively.

For shell scripts, we take all leading lines that have a comment
character in the first column, excepting the hashbang (`#!`).  This
also works for many other languages.

> shDocstring :: String -> String
> shDocstring = unlines
>               . map (drop 2)
>               . takeWhile ("#" `isPrefixOf`)
>               . dropWhile (all (`elem` ['#', ' ']))
>               . dropWhile ("#!" `isPrefixOf`)
>               . lines

For C, we extract the first multi-line comment.  At this point we
should probably have used a regular expression library.

> cDocstring :: String -> String
> cDocstring = unlines
>              . map (dropWhile (==' ')
>                     . dropWhile (=='*')
>                     . dropWhile (==' '))
>              . maybe [] lines
>              . (return . reverse . cut . reverse
>                 <=< find ("*/" `isSuffixOf`) . inits
>                 <=< return . cut
>                 <=< find ("/*" `isPrefixOf`) . tails)
>   where cut s | "/*" `isPrefixOf` s = cut $ drop 2 s
>               | otherwise = dropWhile isSpace s

Haskell is processed much like shell script: We extract the leading line comments.

> hsDocstring :: String -> String
> hsDocstring = unlines
>               . map (drop 3)
>               . takeWhile ("--" `isPrefixOf`)
>               . dropWhile ("#!" `isPrefixOf`)
>               . lines

A *hack compiler* produces, from a script file, a `String` containing
its name and docstring in HTML format, based on an HTML template.  The
docstring is assumed to be in Markdown format, so we pass the entire
thing through a Markdown-to-HTML compiler.  Unfortunately, it seems
that `renderPandoc` inspects the pathname given `Item` to figure out
the input format, so we force Markdown interpretation by pretending
the docstring is in a file of name `".md"`.

> hackCompiler :: Compiler (Item String)
> hackCompiler = do
>   ext <- getUnderlyingExtension
>   src <- itemBody <$> getResourceString
>   desc <- return $ case ext of
>                     ".c"  -> cDocstring src
>                     ".hs" -> hsDocstring src
>                     _     -> shDocstring src
>   dest <- normalRoute
>   desc' <- renderPandoc $ Item ".md" desc
>   let name = takeFileName dest
>       ctx = constField "name" name <>
>             constField "script" dest <>
>             constField "description" (itemBody desc')
>   loadAndApplyTemplate "templates/hack.html" ctx =<< getResourceString

Adding the hacks to a page is now just loading everything with version
`"hacks"`, and wrapping it in an HTML list.

> addHacks :: Item String -> Compiler (Item String)
> addHacks item = do
>   hacks <- loadAll (fromVersion $ Just "hacks")
>   return item { itemBody = itemBody item <> renderHtml (H.ul $ mapM_ asLi hacks) }
>   where asLi = H.li . preEscapedString . itemBody

Putting it all together
---

First, we define three convenience compilers.  The first selects
between different options based on the underlying identifier.

> byPattern :: a -> [(Pattern, a)] -> Compiler a
> byPattern def options = do
>   ident <- getUnderlying
>   return $ fromMaybe def (snd <$> find ((`matches` ident) . fst) options)

This can be used to create a compiler that performs initial creation.

> createByPattern :: Compiler a -> [(Pattern, Compiler a)] -> Compiler a
> createByPattern def options = join $ byPattern def options

It can also be used to create a compiler that modifies the result of
another compiler.

> modifyByPattern :: (b -> Compiler a) -> [(Pattern, b -> Compiler a)] -> b -> Compiler a
> modifyByPattern def options x = join $ byPattern def options <*> pure x

When we instantiate the final page template, we will need to provide a
suitable context.  Apart from the default fields, my website makes use
of two others: a `"menu"` field containing the menu, and a `"source"`
field that contains a link to the raw ("source") file for the current
page.

> contentContext :: Compiler (Context String)
> contentContext = do
>   menu <- getMenu
>   source <- getResourceFilePath
>   return $
>     defaultContext <>
>     constField "menu" menu <>
>     constField "source" source

Furthermore, blog entries need a `"date"` field, which is extracted
from the file name of the post.

> postContext :: Compiler (Context String)
> postContext = do
>   ctx <- contentContext
>   return $ dateField "date" "%B %e, %Y" `mappend` ctx
>
> postCtx :: Context String
> postCtx = mconcat
>   [ modificationTimeField "mtime" "%U"
>   , dateField "date" "%B %e, %Y"
>   , defaultContext
>   ]

I extend the default Hakyll configuration with information on how to
use `rsync` to copy the site contents to the server.

> config :: Configuration
> config = defaultConfiguration
>   { deployCommand = "rsync --chmod=Do+rx,Fo+r --checksum -ave 'ssh -p 22' \
>                      \_site/* --exclude pub athas@sigkill.dk:/var/www/htdocs/sigkill.dk"
>   }

Now we're ready to describe the entire site.

> main :: IO ()
> main = hakyllWith config $ do

CSS files are compressed, data files, my public key, and the
`robots.txt` are copied verbatim.

>   match "css/*" $ do
>     route   idRoute
>     compile compressCssCompiler
>   match "files/**" static
>   match "pubkey.asc" static
>   match "robots.txt" static

One of our primary objectives is the ability to write content for the
site without having to modify this generator program.  Therefore, we
define *content* as a non-hidden file contained in any of the directories
`me`, `writings`, `hacks`, `programs` or `projects`, as well as
any `.md` file in the root directory.  This property is checked by the
`content` pattern.

We divide the content into two sets: content *pages*, which is all
content of types `.md`, `.lhs` and `.man`, and content *data*, which
is the rest.

>   let inContentDir = "me/**" .||. "writings/**" .||. "hacks/**" .||.
>                      "programs/**" .||. "projects/**" .||. "*.md"
>       nothidden = complement "**/.**" .&&. complement ".*/**"
>       content = inContentDir .&&. nothidden
>       contentPages = content .&&. fromRegex "\\.(md|lhs|man)$"
>       contentData = content .&&. complement contentPages

Content data is copied verbatim, as it is expected to be images and
similar non-processable data.

>   match contentData static

Content pages will end up as HTML files.  This is conceptually a
simple process: they are added to list of pages contained in the
menu, processed by a *content compiler*, which is `manCompiler` for
manpages, and `contentCompiler` (which we will see later) for all
other files, although everything gets instantiated with the same
template in the end.  Some pages also need special generated
content: the hacks-page needs a list of hacks.  These are special-cased in an
intermediate step.

>   match contentPages $ do
>     addToMenu
>     route $ setExtension "html"
>     compile $ do
>       context <- contentContext
>       createByPattern contentCompiler [("**.man", manCompiler)]
>         >>= modifyByPattern return [("hacks/index.md", addHacks)]
>         >>= loadAndApplyTemplate "templates/default.html" context
>         >>= relativizeUrls

The group `"source"` contains the source files of all literate
programs.  This is practical, as the processed literate program will
be an HTML file, and thus probably no longer compilable by the
literate system.  While the user could in some cases copy the text
from the browser into a source file (this is possible for literate
Haskell), it is more convenient to have the original source file
available.  Source files are, of course, copied verbatim.

>   match contentPages $ version "source" static

The group `"hacks"` contains small program descriptions generated by
`hackCompiler`.  It is included by `addHacks`.

>   match "hacks/scripts/*" $ version "hacks" $ compile hackCompiler

For the blog, there are two main tasks: first, we must create a page
for every post; second, we must create an overview page.  A blog post
is simply a Markdown file in the `"blog/"` subdirectory.  Note that
this is not matched by `contentPages`.

>   let blogArticles = "blog/*-*-*-*.md" .&&. hasNoVersion

Each post post gives rise to a corresponding HTML file, which uses the
post template.  The template expects a date field, whose value we
extract from the file name.  Importantly, individual blog articles are
*not* added to the menu - there would quickly be far too many.

>   match blogArticles $ version "source" static
>
>   match blogArticles $ do
>     route $ setExtension "html"
>     compile $ do
>       postCtx <- postContext
>       contentCompiler
>         >>= loadAndApplyTemplate "templates/post.html"    postCtx
>         >>= saveSnapshot "content"
>         >>= loadAndApplyTemplate "templates/default.html" postCtx
>         >>= relativizeUrls

The posts list is created by a template.  The blog posts are sorted by
date, with the date encoded into the filename of the blog entry.  The
created page is `"blog/index.html"` rather than `"blog.html"` in order
for blog entries to be considered children of the blog entry in the
menu.

>   create ["blog/index.html"] $ do
>     addToMenu
>     route idRoute
>     compile $ do
>       ctx <- contentContext
>       posts <- recentFirst =<< loadAll blogArticles
>       let ctx' = constField "title" "Blog" <>
>                  listField "posts" postCtx (return posts) <>
>                  ctx
>       makeItem ""
>           >>= loadAndApplyTemplate "templates/posts.html" ctx'
>           >>= loadAndApplyTemplate "templates/default.html" ctx'
>           >>= relativizeUrls

As the final touch on the blog, we produce an Atom feed.  I have no
particular reason for choosing Atom over the alternatives, except that
it seems slightly more modern.  Hakyll seems to support most formats,
so I can add more if I feel like it.

>   create ["atom.xml"] $ do
>     route idRoute
>     compile $ do
>       let feedCtx = postCtx `mappend` bodyField "description"
>       posts <- fmap (take 10) . recentFirst =<<
>                loadAllSnapshots blogArticles "content"
>       let feedConfiguration = FeedConfiguration
>             { feedTitle       = "Troels Henriksen's blog"
>             , feedDescription = "What some hacker has written"
>             , feedAuthorName  = "Troels Henriksen"
>             , feedAuthorEmail = "athas@sigkill.dk"
>             , feedRoot        = "http://sigkill.dk"
>             }
>       renderAtom feedConfiguration feedCtx posts

Finally, HTML templates are, of course, handled by the default
template compiler.

>   match "templates/*" $ compile templateCompiler

We're done with the main function.  All we need to do now is some
fleshing out.  To start with, static files are merely copied into
position.

> static :: Rules ()
> static = route idRoute >> compile copyFileCompiler >> return ()

Compiling content pages is done with the default
`pandocCompiler`, but we extend it slightly with a transformation
that makes every headline link to itself.  First, we define the
function that transforms a `Header` block into a `Header` block with
a self-link.

> selfLinkHeader :: Block -> Block
> selfLinkHeader (Header n (ident, classes, kvs) b) =
>   Header n (ident, classes, kvs) [b']
>   where b' = Link (ident <> "-link", ["titlelink"], []) b ('#' : ident, ident)
> selfLinkHeader x = x

Then we can define our `contentCompiler` as a `pandocCompiler` with an
additional transformation step.

> contentCompiler :: Compiler (Item String)
> contentCompiler = pandocCompilerWithTransform
>                   defaultHakyllReaderOptions
>                   defaultHakyllWriterOptions $
>                   walk selfLinkHeader

Compiling man pages is done using the system `groff` program.  The
output from `groff` will contain control characters (notably
backspaces), which we process with `col -b` to generate plain text.
Finally, we insert the text into an HTML `pre` element to preserve the
whitespace formatting.

> manCompiler :: Compiler (Item String)
> manCompiler = getResourceString
>               >>= withItemBody (unixFilter "groff" (words "-m mandoc -T utf8")
>                                 >=> unixFilter "col" ["-b"]
>                                 >=> return . renderHtml . H.pre . H.toHtml)

And that's it.
