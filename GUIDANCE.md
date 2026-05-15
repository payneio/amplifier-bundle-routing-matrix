# How We Work — Guidance for the Team

> A working document distilled from real conversations. The goal isn't to memorize this — it's to recognize the patterns when they show up in your own work, and to know what I'm likely to push back on (and why) before I do.

---

## Preface — What This Is and Why It Exists

I'm transferring more ownership to each of you. That's the easy part. The harder part is shifting your **approach, thinking, judgment, decision-making, taste, scrappiness, systems thinking, systems design, and engineering practices** to be in line with how I have been driving Amplifier related work — so that we can work together to first align, then accelerate how I can hand off, all towards the goal of more aligned autonomy, roughly making the calls and reasoning that I'm attempting to transfer as well.

This document is the closest thing to a snapshot of those calls and reasons. It was extracted from conversations we've already been having — not invented after the fact. So when you read something here that sounds like something I said to you last week, that's because it probably is.

A few things to keep in mind as you read:

- **The principles overlap.** They're not 20 independent rules. They're an interlocking system. The same redirect can usually be classified under three or four headings — which is a good sign. It means the underlying philosophy is more compact than the surface count suggests.
- **The conversation is the asset.** I said this to Ken explicitly: *"these conversations... are going to be the most dense collection of this kind of stuff that we have the opportunity to leverage."* If we capture only the outcomes, we'll re-derive the principles every time. So treat your conversations with me — and with each other, in the case where someone is passing some of this along — as the primary artifact and an investment and valuable use of time. The decision is the byproduct.
- **At times, I'm working this out in real time too.** From the David call: *"Sometimes the things that I say in these sessions are... you're hearing me thinking it out loud, literally, for the first time. Like, it may sound like, like, we've been doing this forever. It's like, no, no, no, starting now. New idea, we're going to do this."* If something here looks fresh, that's because it is. We'll keep updating. It's also not a judgment on any past approaches, it's about how we run faster together going forward, with confidence in transferring for autonomy.
- **Use your judgment.** This isn't a checklist to follow. If anything in here is wrong, push back. If anything is missing, surface it. Bring me a recommendation, not a question.

---

## Part I — The Core Stance

If you only remember twelve things, remember these.

### 1. Today's needs only. Tomorrow can add. Tomorrow rarely removes.

The single most repeated redirect across every conversation. If your justification uses the words *might, may, likely, eventually, could be useful, if we find* — those are tripwires. They mean **not now**.

> *"All the words of 'if we find, likely, might' — those are your immediate signals of not those yet... we can add it tomorrow, but not today. Because once you put it in there, it's hard to take back."* — to Ken

> *"It's easier to add more later than to remove, so start w/ just enough to get the data we need to calc the values we need in the status output. Embrace this wherever we can, driven by today's needs vs tomorrow or wants."* — chat to Ken

Even when my gut agrees the field will eventually matter — *especially* then — the answer is still no for today. Removability is asymmetric: once a field, schema, layer, or capability exists, it accrues consumers and becomes load-bearing.

### 2. Invert the question: "What can't we do without it?"

Don't ask *"should we build X?"* Ask *"what is currently impossible if we don't build X?"* If the answer is nothing concrete, defer.

> *"What I like is the thinking of: okay, if we don't have L2, what is it that we can't do? — so that we can decide: should we be making an investment at that level, or not right now."* — to Diego

A capability earns its existence by what it unblocks **today**. Speculative justification is unfalsifiable, and unfalsifiable arguments will always grow systems faster than they earn.

### 3. Mechanism vs. policy. The lower the layer, the purer the mechanism.

Core is mechanism. Foundation is mechanism with _some_ more _limited, general, and common_ policy. Bundles, scenarios, and resolvers express more specific policy. Don't pollute mechanism with policy by promoting domain knowledge into a lower layer because it's convenient.

> *"We don't want to bring in specific knowledge except for core. So not even foundation... We don't use foundation for everything. So we don't want that to be in there by default. It needs to be: if we are using foundation, we can load that in also."* — to Diego

> *"It's a pure mechanism, recognizing that the policy is going to be defined based off of that combination, more at the bundle level."* — Diego, articulating it back to me

When you find yourself wanting to teach core about a higher concept (recipes, foundation, a specific resolver), the answer is almost always: load that knowledge **in** from the higher layer, not bake it in.

### 4. Right repo, right layer. The first question for any change is "where does this belong?"

Not "where am I editing?" If a change is touching core *and* foundation *and* a provider *and* the app, that's a strong signal it *may* actually a single-layer fix in the wrong place.  Many times we do need to touch many repos, but treat this signal as a nudge to step back and ensure you are not pushing awareness from a higher level into another layer or something too specific into the more general codebases "to make it work".

> Salil, recounting it back to me: *"There was a time when I was making some of these PRs where it came up with this suggestion that we need to go change core here, foundation here, provider here. And Brian's simple question was, but the thing you're changing is actually an app CLI concern. And so why are you making these three changes?"*

The first cost of putting a change in the wrong place is multiplication — it touches more layers than necessary. The second cost is ossification — once it's there, it teaches future contributors that *this kind of thing* lives at *this layer*. That's how architectures decay. Read [REPOSITORY_RULES.md](https://github.com/microsoft/amplifier/blob/main/docs/REPOSITORY_RULES.md) and Alex's masterclass — *you* need that awareness, not Amplifier.

### 5. Library first. Thin wrappers everywhere.

Within bundles, when creating functionality that may be useful in different "packaging" (scripts, integrated into apps/code, tools/hooks modules, etc.), favor doing so as a library with thin wrappers around it as needed for different interfaces. One canonical implementation. CLI tool, agent tool, in-app code path, recipe step are all surfaces over the same library.

See the examples for the "sessions" concept in amplifier-foundation:
* https://github.com/microsoft/amplifier-foundation/tree/main/amplifier_foundation/session
* https://github.com/microsoft/amplifier-foundation/tree/main/scripts
* https://github.com/microsoft/amplifier-foundation/blob/main/agents/session-analyst.md
* https://github.com/microsoft/amplifier-app-cli/blob/041dd1d3e326d0ef7d51c5a872debb3679a23ada/amplifier_app_cli/main.py#L2087 (re-use in an app, same logic)

> *"Anytime we have something like this, instead of putting it into a CELA tool or an amplifier tool that has all of the logic, we're putting it now into a library first in that repo and then putting a thin wrapper around it. Because then it's the click interface calling that tool, and now it's a CLI tool, and it's just a modular module wrapper around that library, and it's an agent tool — so that way we've got one common code that we can touch to fix both of them."* — to Diego (with a "hint, hint" softening)

This is the pattern. When you anticipate the re-use need or see it multiple times, extract a library. Same code, many surfaces, one place to fix.

### 6. First-class Amplifier models. Providers transform inward.

We define the canonical shape. Providers translate themselves to fit it — not the other way around.

> *"Think of the Amplifier version of the model as the first class version and that all provider modules will have to transform their data to put it into that shape, vs the other way around."* — chat to Ken

The metadata property bag is the escape valve for provider-specific state or for experimental use before making a canonical decision — not a place for canonical fields to _live_. When you find yourself wanting to add a field "for one provider," ask whether it belongs in metadata or whether it's actually canonical.

### 7. The platform is a dev tool, not a hub.

This was the most dramatic redirect in any of our conversations. Don't build a centralized "smart platform" that knows about everything. Build something that helps developers create the bespoke, scenario-specific pieces they need — *for them*, not *for everyone*.

> *"What if for now, context intelligence at the agent level and the tool level is more about, it's our dev surface... we say when we have a need, wherever, we leverage context intelligence to design the right query or piece that we would need to do. Not that it would be the thing that does the thing on the fly as an agent call."* — to Diego

> *"It doesn't work so well when your system is completely modular and anybody can do whatever the heck they want. So inverting it and instead going, no, in any of your specific needs and scenarios, you leverage context intelligence as part of your development tools and process to be able to then build the specific tooling and context awareness and understanding that you need."* — to Ken

A fully modular, plurally-owned ecosystem can't have a single smart hub. The hub will either become a kitchen-sink that knows nothing well, or a centralizer that re-creates the very coupling modularity was meant to avoid. **No top-level/cross-ecosystem dashboards.**

### 8. Use AI as a designer of bespoke tools, not as a real-time oracle.

Use agents and/plus other "open" exploration mechanisms, like generalized tools, skills, etc. as the assist for _designing_ the specific, reusable versions for your particular scenario needs. This is the follow-up to #7 above, wield those to start baking in _scenario specific_ components to support the ongoing real-time needs — it's the **reusable artifact** that makes the future runs cheap, but specific to your needs. A skill. A query. A tool. A context file. A library.

> *"The idea is, fine, do that once to then make the map — this is how to use these things in this particular scenario... it may be as simple as: for the early pieces, it's just a context file — here's how to do these things, look for these things, here's the query, here's the fields... and then maybe that's the starting point and then we go from there as we need."* — to Diego

This is the same shape as TDD — the first run defines the contract, the contract pays you back forever. Optimize for the rate at which agent sessions produce reusable, named artifacts. Don't optimize for re-prompting.

### 9. Bias toward action. Twine and twigs is fine.

A scrappy artifact teaches you what the right thing actually is. Don't wait for the well-architected solution while the team is blocked.

> *"Give us the agent who can at least help us make something that's held together with some twine and some twigs while we get the better thing."* — to David

> *"Don't go run more than one until you can run the first one end to end. Because if you're first putting all the pieces together, don't run 10 every time while you're fixing it."* — to David

> *"If David [domain champ for evals] is not available, just get **something** working, circle back around. In fact, if you do that, then there might be something interesting in mind from there. And if not, and David is available and he just tells you, then use that."* — to Salil

A working crap-but-end-to-end thing is information-dense. Learn and circle back where needed. It tells you what the next problem actually is. Paralysis dressed as prudence is the failure mode I'm trying to break.

### 10. Evals before vibes. Establish a baseline before iterating.

Stop deciding things "feel better." Measure first, then iterate. Make eval-first the default rhythm, not a special activity. The first artifact in any evals-first workstream is the **harness** — built before the work begins. Baseline first; run it during the work to see impact; run it after to confirm.

> *"I want to start that as more of our default behavior going forward on things, instead of going, 'hey, we vibed the thing, it feels better. Someday maybe we'll measure it.' Getting better at making that our driver for it."* — to David

> *"Before we even start that, first things first, go build a harness to run a bunch of evals on real scenarios that we would do in Amplifier Dev that have significant wall time that we want to see if we can reduce. Measure that, that's our baseline. Now, how do you want to go and try to improve that?"* — to Salil

Coverage scales sub-linearly with runs — David's numbers: **one scenario gets you ~40% of the signal; two gets you ~70%; three gets you ~75%; ten gets you ~85%.** Cheap baselines are usually enough for inner-loop work. Reserve big runs for high-blast-radius changes (orchestrator, providers, prompts).

### 11. Reduce instruction. Trust the models.

When agents misbehave — running off, "creatively finding a way," fixing things they weren't asked to fix — the fix is usually **less prompt, not more**.

> *"Agent fails to run a recipe. Agent then goes off and reads the recipe and decides, 'I'll just fix that. I'll do it for you.' And then just does the thing. Has gotten worse... It makes sense because there is very, very strong literal instruction in our prompts that says, 'when you get stuck, go creatively find something'... these are all signals that we have too much, too strong instruction there."* — to Salil

Defensive instructions written for older models now backfire on newer ones. Watch for "oopses" — the canary that your prompts _may be_ over-engineered. The prompt is not a junk drawer of past failure modes, nor is it something we can set and forget as models improve.

### 12. Capture the *why*. Surface ideas before acting.

The decision is the byproduct. The reasoning trail is the asset.

> *"One of the things I find more valuable than the result of this one, or the work that you're actually getting done here, is the conversations we're having to talk about the why of some of these decisions. Instead of me just telling you, 'no, just do it this way' — we're engaging, and the response is, well, here's why I'm thinking about that."* — to Ken

> *"Here's then the other principle that has nothing to do with even an agent at all — which is, before we go off and do new work that we think is going to be valuable that we should go do, we surface that and say, hey, I've got this idea. Is this area the right place to even think about doing that? Or is there context that I don't have? — which might not even be represented in any existing code base. It may be a plan somewhere outside of our systems completely."* — to Ken

AI-assisted developers have very low friction to *just doing it*. That's the trap. Surface, check for context outside the codebase, **then** commit.

---

## Part II — The Principles in Depth

The headings above are the compressed version. This section gives you the texture — what the redirect sounds like in the wild, what's underneath it, and what I'm trying to catch.

### Cluster A: Scope & Investment

#### Two modes need different rules

Treat exploration and execution as different modes with different bars.

- **Explore mode:** "interesting" is enough. Toys, experiments, sketches. Wide net.
- **Execute mode:** only "needed" qualifies. Consolidate, integrate, harden.

> *"Because of the fact that it's so easy now that we can go do anything we want to go do, it's going to become more and more critical that we're expressing really good judgment, taste, and so on. And so part of that was: when you're in explore mode, that's fine. It's more about what would be interesting to show, to contribute, and so on... But now we're shifting — 'no, no, no, now we're getting more focused, and we're executing on bringing together' — let's stop making a whole bunch more just for the sake of making more."* — to Ken

A mode shift is hard to feel from the inside. It must be named. The team has been in explore mode for a while; the artifacts of explore mode will keep coming until somebody draws the line. We've drawn it. We're now assembling Legos, not making more Legos.

#### "The usual" is a smell

When you reach for "the usual auth services" or "the standard set of providers" or "all the typical fields" — pause. That phrase covers imagined cases.

> *"Well, I don't want to say 'the usual' and then we start trying to cover all the ones we can think of. I'd rather go: these are the ones we know we're going to need."* — to Mark

Name only what you know is needed. The rest is speculative.

### Cluster B: Architecture & Layering

#### Why is this the right mechanism?

When someone says "we'll do X using context intelligence" or "we'll handle Y in foundation," challenge the choice of mechanism — not the work.

> *"My question is, why are we choosing that context intelligence is the right mechanism to use for that? versus something else in our system."* — to Diego

The cost of putting work in the wrong mechanism compounds. Cost-tracking belongs where cost data is *generated* — at the provider — not where the data could be queried later.

#### Decision hygiene: the data type is the contract

Get the type right while the cost is one PR. Once the world depends on it, you pay forever.

- **Never use floats for money.** Be clear about currency.
- **`None` and `0` are not the same.** "Unknown" is not "zero."
- **Don't reach for sentinel strings** ("?" / "unknown") for future states you might want — use `Decimal | None` and let `None` be unknown.
- **Support user overrides** for things like cost (negotiated rates exist).

> *"I'm not a fan of trying to read too far ahead. Do we feel high confidence that we're going to have more than one of the non-decimal states that we would want — that we should consider a string to be able to do that? I would lean not towards that, and just leave it as none."* — to Ken

#### No top-level dashboards

In a modular, plurally-owned system, central dashboards are dead-ends. The right top-level artifacts are *patterns and tools*. Dashboards belong at domain edges.

> *"This is why I don't want to build an actual dashboard or anything for context intelligence itself."* — to Diego

> *"In each repo, put what is needed so that context intelligence will later be able to mine everything from... it may make more sense to go: no, no, more scenario driven in the places we're going to eventually use them."* — to Diego

### Cluster C: Build Style

#### See it three times before you abstract

The library extraction is *pulled* by the pattern repeating, not pushed by anticipation. Same with shared utilities, shared schemas, anything pretending to be infrastructure. If you've only built it once, it's a feature. Twice, it's a coincidence. Three times, it's a library.

#### End-to-end before going wide

> *"Don't go run more than one until you can run the first one end to end."* — to David

This applies broadly. Get one thing working all the way through before parallelizing, scaling, or generalizing. Otherwise the bug is in eight places at once and you can't tell which.

#### Determinism over LLM where you can

David replaced an LLM-generated HTML report step with a deterministic one. I praised it explicitly: *"Cuts out a huge LLM step... deterministic... faster and more reliable."* When the work is structurally regular, code beats LLM. Reach for the LLM where the work is genuinely judgment-shaped.

### Cluster D: AI as Lever

#### The platform-as-dev-tool flip (deeper)

This deserves more than the one bullet in Part I, because most of you defaulted to the wrong frame at first.

The wrong frame: *"Context Intelligence will know everything about your sessions, and you'll ask it questions, and it'll answer."*

The right frame: *"Context Intelligence helps you build the precise scenario-specific lens that answers your scenario-specific question — once. After that, you don't ask the agent again. You use the artifact."*

Same for evals. Same for cost reports. Same for any feature that *feels* like it should be a smart oracle. The oracle is a trap — it either knows nothing well, or knows everything badly.

#### What to crystallize first: the stumbles and the risks

Don't pre-build the bespoke tool. Start with Amplifier doing the work using its general capability plus a minimal context dump of current best thinking. Then, as you go: **shift to harder structure the things Amplifier stumbles through**, and **harden the parts that are too risky to leave to it**. Everything else, leave open and let it improvise.

> *"Start lightweight, scrappier — more of 'Amplifier has good strategies for setting things up and generally understands the concepts above'. We'll learn as we go, improve it around our generalized needs, shifting just the things that Amplifier has to stumble through to get done, or are riskier to leave to it to handle. But focusing more on keeping it first open and informed."*

This is a refinement of "AI as designer of bespoke tools" — you don't design the tool up front. The agent's actual stumbles tell you what needs to crystallize. The risk profile tells you what needs to be deterministic. Everything else stays open.

#### Bring it in without paying when not used

Every always-loaded piece of context has a cost — and it compounds across every turn, every session, every member of the team. When you introduce new capability, ask: *how do I bring this in without contributing to first-turn context usage creep?*

The hierarchy, roughly:

- **Mode** — effectively zero advertisement cost when not invoked, *if* you make it slash-invokable only (not agent-invokable). Best when the capability needs to reshape the current state — different tools, different agents, different posture, interactive flow.
- **Skill** — small advertisement cost, loads on demand. Best for focused knowledge that doesn't need to reshape state.
- **Agent** — full delegation cost, but isolates context in its own session. Best for token-heavy specialized work where you want a clean room.
- **Always-on context** — pay every turn. Reserve for what genuinely needs to be top-of-mind every time. The bar here should be very high.

When a capability *can* be a mode, prefer mode. Modes can reconfigure tools, agents, providers, and interactivity in ways skills can't, and slash-only activation makes their cost effectively zero.

> *"... the answer to the advertisement cost is: if you don't make it invokable by agent, then it should not show up, and users invoke via slash commands — this all feels right for this one."* — to David, on the evals-first workstream

> *"I think that this is the pattern that I want to lean into more this week with others as well, so let's try that first and we can adjust as we go."* — same conversation

That second quote is the "hint, hint." For new capability of this shape, default to **mode-with-slash-only-activation** unless there's a specific reason it shouldn't be.

#### The flywheel: workstreams feed each other

Wall time, evals, reality check, context intelligence, amplifier-as-agent — these are not independent investments.

> *"This is why we have a big circular thing going on here with our team... they feed each other."* — to David

Don't optimize one node. Recognize the loop. Make sure each node gets *just enough* investment to keep the loop spinning.

#### The transition model: hand-hold less

> *"I used to, with my agents, very, very handheld — here's what you need to go do. I got to be less handheld with my agents. Now shift more to people, which at first will be a bit more — we need to be communicating and building up that shared understanding, confidence, and so on — and then ideally less, and I can ask bigger asks."* — to Ken

The endgame isn't more delegation of the same kind of work — it's the floor of the work rising. We free ourselves up so we can think about *the bigger things*. Velocity gains are spent on harder questions, not on doing more of the same.

### Cluster E: Verification & Iteration

#### Spec as README of the finished thing

The right design artifact is the README of the finished system — concise, with diagrams, written from the consumer's mental model, not the builder's.

> *"David and I had an experience where he gave me one asset. It was a README file for a repo that was the finished-state representation of the README. And so it was the right level of detail... had a diagram as well, so it showed the architecture in addition to... it wasn't super wordy at that point because the diagram covered a lot of the need there."*

> *"That's what I did with the whole recipe tool project... I wrote the docs. And the docs were the developer docs that you would use after the code was written. And then the other accompanying spec was more the things you wouldn't put in the docs, but would also be important to know because it wasn't obvious enough through the docs."*

The press-release-of-when-it's-done is also a good shape. If you can write that, the rest follows. If you can't, you don't understand the thing yet.

#### `brian-review.md` is the wrong shape

When Salil started routing decisions through a `brian-review.md` file, I pushed back:

> *"The brian-review.md is not really the level of thing I want to engage with at this stage of this. If there are decisions that need to be made in there please do what you can to dig into how things currently work and what you can find around why they are that way, see if you have enough to assert a recommendation and then let's chat about any specific items that you think would be good for us to sort out together."*

**Bring me a recommendation, not a question.** Do the homework. Find out why the system is the way it is. Form an opinion. Then come find me with the items you genuinely think need joint thought.

### Cluster F: How We Communicate & Decide

#### Direct pushback. Generous reframes. Ownership preserved.

I'm going to push back hard on the *content* of an idea while staying generous about the *person*. When the redirect lands, I'll follow it with explicit ownership: *"use your judgment, you've done well with this before"* / *"you take more of the lead on thinking about... what's the better way."*

Anti-shame is a deliberate move. From the Ken call:

> *"Maybe you should have known this already... I've had to say that because there have been times when people have been like, 'ohh, yeah, this should have been...' No, it's not. It's easy to look at these things in hindsight, but most of it's not... these kinds of conversations are awesome because they're the place where we get to figure some of these things out."*

Don't beat yourself up when you get redirected. The redirect is the work.

#### Calibrated language

When I say *"my guess is it didn't, but I would not put money on that either"* — that's not hedging. That's calibration. Distinguish *plausible* from *certain*. Don't sound more confident than you are. Don't sound less confident either.

#### Bias toward action — across people

> *"I don't want this to turn into two separate crews... Paul has actually built stuff that I think you guys need to leverage."* — to Salil

> *"I want to be careful that we're not going... everybody doesn't get too siloed, where what we end up with is one area that's way ahead of where it needs to be at the expense of others."*

Cross-pollinate. The work in one corner usually unlocks work in another. If you find yourself working in isolation for more than a few days, surface what you've learned.

---

## Part III — Signature Phrases & Tells

These are the phrases I reach for repeatedly. If you hear them, you're getting one of the principles above.

### Phrases I use

- *"Today's needs vs tomorrow or wants."*
- *"It's easier to add than to remove."*
- *"If, likely, might, may — those are your immediate signals of not those, then now."*
- *"We can add it tomorrow, but not today."*
- *"Held together with twine and twigs while we get the better thing."*
- *"What can't we do without it?"*
- *"Pure mechanism — policy is defined more at the bundle level."*
- *"First class Amplifier model — providers transform their data to fit."*
- *"Library first, thin wrapper around it — one common code we can touch."*
- *"Hint, hint."* (the soft-but-clear directive)
- *"Use your judgment, you've done well with this before."*
- *"In explore mode... vs... we're executing on..."*
- *"Why are you choosing that X is the right mechanism?"*
- *"What's even the right repo for it?"*
- *"You're hearing me thinking it out loud, literally, for the first time."*
- *"Don't go run more than one until you can run the first one end to end."*
- *"Get a baseline established."*
- *"They feed each other."*
- *"Stop doing the things that we spend our time on that we shouldn't have spent our time on."*
- *"Bias toward action."*
- *"Without contributing to first-turn context usage creep."*
- *"Start lightweight, scrappier — learn as we go."*
- *"Shift just the things Amplifier has to stumble through, or are riskier to leave to it."*

### Metaphors I reach for

- **Twine and twigs** — for scrappy intermediate solutions that get the team unblocked.
- **Boil the ocean** — to call out scope explosion before it metastasizes.
- **Now you gotta assemble some** — the Lego shift from explore to execute.
- **The dashboards nobody used** — the centralization anti-pattern.
- **The "approved" regex looping 40 turns** — the canonical cautionary tale of why observability + small fixes beat heroic re-engineering.

### Anti-patterns I redirect (in roughly the order I see them)

1. **Speculative scope.** *"We'll want this later."* → defer.
2. **Wrong layer / wrong repo.** Multi-layer changes that should be single-layer. → where does this belong?
3. **Hub-and-spoke smart platforms.** → dev tool, not oracle.
4. **Vibes-driven iteration.** *"Feels better."* → baseline, measure, iterate.
5. **Over-instruction.** Adding more prompt rules every time something fails. → reduce, trust the model.
6. **Coupling unknowable to zero.** `0` for "we don't know yet." → `None` ≠ `0`.
7. **Float for money / sloppy primitives.** → get the type right while it's cheap.
8. **Long design docs nobody can review.** → README of the finished thing.
9. **"The usual."** Covering imagined cases. → only what we know we need.
10. **Routing all hard calls back to me.** (`brian-review.md`) → do the homework, bring a recommendation.
11. **Letting the agent "creatively find a way"** when stuck. → strong recovery instructions backfire on better models.
12. **Optimistically adding fields** because "we're already touching this." → add tomorrow, remove never.
13. **Gold-plating eval setups.** Evals nobody can actually run. → smallest eval that catches your normal gotchas.
14. **Building dashboards before tools.** → tools first; dashboards crystallize at the edge later, if at all.
15. **Solving an architecture problem without surfacing it first.** → check for context outside the codebase before committing.
16. **First-turn context creep.** New capability that's always loaded when it could be on-demand. → mode-with-slash-only when the capability fits; skill if not; agent for clean rooms; always-on only when genuinely needed every turn.
17. **Pre-building the bespoke tool.** Designing the agent's eventual structure before the agent has stumbled. → start open and informed; let the actual stumbles tell you what to crystallize.

### What I praise

When I explicitly approve, these are the patterns:

- **Library + thin wrapper.** The pattern itself. Naming and extracting.
- **Determinism replacing LLM steps.** Where the work is structurally regular.
- **Bringing recommendations, not questions.** With reasoning attached.
- **Pause-and-check before charging in.** Surface, then commit.
- **Pulling judgment forward.** Owning the call rather than escalating it.
- **Catching your own framing mid-sentence.** Self-correction is the strongest signal of taste developing.
- **Letting the system catch what the agent missed.** Branch protection saving us, etc. Structural safeguards over heroics.
- **Slimming docs.** Going from a giant design doc to a tight README is real work, not laziness.
- **Asking "what level should I engage with you at?"** Meta-questions about process get my full attention.
- **Real concurrency, real measurement.** Actually running the experiment, not just describing it.

### My communication style — what to expect

- **I'll be direct.** Sometimes terse. *"There is no central lib for this."* That's not anger — it's correction. Don't read tone into it.
- **I'll separate plausibility from certainty.** *"My guess is X, but I wouldn't put money on it."* Take this as exactly what it says.
- **I'll soft-lead into hard counters.** *"I don't think that's quite the way to look at it though."* — followed by a complete reframe. The soft entry is courtesy, the counter is real.
- **I'll signal pattern shifts with "hint, hint."** That's me telling you a pattern is becoming canonical without commanding it. Treat it as canonical.
- **I'll admit when I'm working it out live.** *"Starting now. New idea, we're going to do this."* That doesn't make the new idea less binding — it makes it more important to capture.
- **I'll protect you from impostor traps.** When something is hard to know, I'll say so. Don't carry shame for not having known it.

---

## Part IV — A Practical Reference

A short list to scan before sending me a PR, a design, or a "what should I do?" question.

### Before you build

- [ ] **Is there a present, concrete blocker that this work removes?** If you can only justify it with *might / may / likely / eventually*, defer.
- [ ] **What can't we do without this?** If the honest answer is "nothing today," it's a tomorrow item.
- [ ] **Have I surfaced this idea?** Is there context outside the codebase — a plan, a conversation, someone else's work — I should check first?
- [ ] **What repo / layer does this belong in?** If the change touches three layers, is one of them actually the home?
- [ ] **Is this mechanism or policy?** If policy, is it at a high enough layer?
- [ ] **Should this be a library with thin wrappers?** Have I seen this pattern before — twice? three times?
- [ ] **Am I in explore mode or execute mode?** Is the artifact appropriate for the mode?

### Before you ship

- [ ] **Did one scenario work end-to-end before I scaled?**
- [ ] **Do I have a baseline I can iterate against?**
- [ ] **Have I avoided floats for money / `0` for unknown / sentinel strings for future states?**
- [ ] **Are provider-specific concepts staying out of canonical models (or in `metadata`)?**
- [ ] **Is the spec the README of the finished thing — short, clear, with a diagram?**

### Before you ask me

- [ ] **Have I done the homework?** Read the code. Read the docs. Read the masterclass.
- [ ] **Do I have a recommendation, not just a question?**
- [ ] **Have I narrowed the question to the part that genuinely needs joint thought?**
- [ ] **Have I captured the *why* of where I am, not just the *what*?**

### When I push back

- [ ] **Note what was being redirected** — the prior approach or assumption.
- [ ] **Note the principle that landed.** It probably maps to one of the twelve in Part I.
- [ ] **Update your scratch notes / skill / context file.** The conversation is the asset. Don't lose it.
- [ ] **Keep going.** The redirect is the work. Don't carry shame.

---

## Closing — On Taste

Most of this is taste. Taste is what's left over when you can't reduce judgment to a rule. The whole point of this document is to make some of my taste legible — but the real transmission happens in conversation, which is why I want us doing more of it, not less, during this transition.

If the team comes out the other side of this with the same instincts I have when I'm operating well, we win. The team will be doing things I wouldn't have thought of, in ways I wouldn't have proposed, and I'll trust the calls. That's the goal. Not compliance. **Calibrated independence.**

Let's keep capturing. This document will be wrong in a month. Update it.

— Brian
