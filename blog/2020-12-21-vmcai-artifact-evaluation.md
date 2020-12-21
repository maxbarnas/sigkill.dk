---
title: Reflections on the VMCAI 2021 artifact evaluation
description: I was co-chair and these are my thoughts on how it went.
---

This fall I worked as one of the two co-chairs of artifact evaluation
for [the 22nd International Conference on Verification, Model
Checking, and Abstract Interpretation (VMCAI
2021)](https://popl21.sigplan.org/home/VMCAI-2021).  While I had prior
experience with artifact evaluation, this was my first stint as chair
of *anything* in an academic context.  This post contains some notes
and observations I made of the process.  I should note that we merely
continued the process devised for VMCAI 2020.

First, VMCAI is unusual in that artifact evaluation is done
concurrently with paper evaluation.  In principle, the quality of the
artifact could then influence acceptance of the paper.  Although since
artifact submission is still optional, such influence could supposedly
only be positive.  In practice, the main advantage of concurrent
artifact evaluation is that it shortens the entire submission review
process.  For most conferences, artifact evaluation happens during the
several months between paper acceptance and publication.  VMCAI has a
tighter, more workshop-like timetable, where this would not fly.  The
main downside of concurrent evaluation is that we must evaluate far
more artifacts than otherwise, as we have to look at potentially all
submissions, not just the accepted ones.  To cope with this, VMCAI
places more rigid restrictions on artifacts than is commonly done.

During my previous experiences with artifact evaluation (as both
reviewer and author), authors could and did submit almost anything -
from ad hoc shell scripts, over [Nix](https://nixos.org/) derivations,
to full virtual machine images.  It is then up to the reviewers to
make sense of everything.  VMCAI instead specifies a [fixed virtual
machine image](https://zenodo.org/record/4017293), and requires that
artifacts run inside it.  Artifacts may require additional
dependencies, but these must *all be bundled* in the artifact
package - connecting to the Internet during the setup procedure, such
as `apt-get`ing additional packages, is not allowed.

While these restrictions impose extra work on submitters, it tends to
produce artifacts that are much more robust, and avoids "works on my
machine"-situations.  Further, the ban on downloading extra material
from the Internet during artifact setup makes the artifacts
self-contained, which will hopefully keep them working in the future.
While there are some artifacts that will never fit into such a
restricted framework (e.g. anything that needs more specialised
hardware, such as GPUs), I think many will.  The exceptions can be
handled on ad hoc basis.  If anything, I believe we should go
*further* in this direction, and also require standardised interfaces
for running the artifacts and obtaining the experimental results.
Maybe I should take another look at
[CK](https://github.com/ctuning/ck)...

As this was the first time I co-chaired such a committee, I was of
course anxious that things would go wrong.  Before every deadline, I
was worried that the reviewers would not submit anything; an anxiety
that was fueled by a near-absence of reviews just a few days before
the deadline.  Of course, I should have remembered the academic
preference for deadline-scheduled work, and every review was
ultimately submitted in time.

Some things did not go as well.  VMCAI follows custom by handing out
various artifact badges: "functional" for artifacts that are accepted,
"available" for those that are publicly available, and "reproducible"
for those that are exceptionally well documented and reusable.  The
two latter badges are problematic:

1. For the availability badge, do we expect submitters to register a
   DOI for their artifact (easy on [Zenodo](http://zenodo.org/)), or
   just promise (where?) that the artifact will be public?

2. For the reproducibility badge, we need firmer guidelines for what
   is expected.  The standards are not clear.  I would probably
   recommend discarding this badge entirely, and simply making the
   acceptance requirements higher.

The biggest problem we encountered was however the use of
[EasyChair](https://easychair.org/) for artifact submissions.  My
previous artifact evaluation experiences have all been through
[HotCRP](http://hotcrp.com/).  For resolving technical difficulties,
it's useful to have a low-latency communication channel between
submitters and reviewers, but EasyChair does *not* support this.  All
communication is either done through review/rebuttal phases, or in an
ad hoc manner by routing reviewer comments through the chairs, who
will then send emails and post them on the submission discussion page.
HotCRP does this *much* better, as it allows both authors and
reviewers to post any number of anonymous comments that are then
visible to both parties.

So in conclusion:

* Artifact evaluation is still fun and worthwhile.

* Continue to standardise the format of artifacts (but do provide lots
  of documentation and examples whenever you tighten them further).

* Provide clear rules and expectations for the evaluation badges.

* Use HotCRP as the submission platform.
