You are helping someone who knows they should document their code but keeps putting it off because writing docs feels like a chore that slows them down. Or maybe they are onboarding someone new and realized there are no docs for the function that person needs to call. Or a code review comment says "please add docs" and they are looking at an unexported function with six parameters thinking "where do I even start?" They need docs that are accurate, complete, and match the project's style, without spending an hour figuring out what to write.

## How to Think About Documentation

Before writing any documentation, ask: when someone searches for this function at 2 AM during an incident, what do they need to know? They need what it does, what can go wrong, and what the side effects are. They do not need a paragraph about the module's design philosophy.

A mediocre doc: "This function processes the request."

A great doc: "Validates the incoming InferenceRequest against the pool's model allowlist, enriches it with routing metadata, and forwards it to the scheduler. Returns ErrModelNotFound if the requested model is not registered in the pool. Writes an audit log entry on every call, including rejections."

That second version tells an on-call engineer everything they need: what happens, what breaks, and what else it touches. Aim for that.

Another failure mode is hiding side effects. Bad: "Processes the user record and returns the result." Good: "Fetches the user record from the database, increments the `login_count` column, writes a row to the `audit_log` table, and returns the updated User struct. Errors if the database connection is closed or if the user ID does not exist (returns ErrNotFound)." If a function touches the database, writes logs, or mutates state, say so up front. Surprises in production are not fun.

## Input

Parse the target (file path, function, class, module, or API endpoint) from:

$ARGUMENTS

- If $ARGUMENTS is empty, stop and ask: "What do you want documented? Give me a file path, function name, module, class, or API endpoint."
- If the target is ambiguous (e.g., "handler" or "utils"), search the project, present the matches, and ask the user to pick one.
- If the target cannot be found, report what you searched for and where you looked. Do not generate docs for code you have not read.

## Steps

Work through these in order. Do not start writing until Step 4 is complete.

**Step 1: Read the source.** Find and read the full code, including imports, type definitions, and any internal functions that affect behavior.

**Step 2: Identify documentation conventions.** Detect the language and map to the correct format: Google-style docstrings (Python), JSDoc (JS/TS), GoDoc (Go), Javadoc (Java/Kotlin), `///` doc comments (Rust), Doxygen (C/C++). If the project already has documented functions, match their style exactly. Your docs should look like they belong in this codebase.

**Step 3: Extract facts.** Build a complete model of the code:
- Purpose (one sentence, starting with a verb)
- Parameters: name, type, required/optional, defaults, valid ranges
- Return values: type, structure, field meanings
- Every error path and what triggers it
- Side effects: file I/O, network calls, DB writes, state mutations, env var reads, logging
- External dependencies, thread safety, and obvious performance characteristics

**Step 4: Handle edge cases.**
- For uncommented code, document from the implementation and flag with "Behavior inferred from implementation."
- For dynamic languages, infer types from usage and state your inferences.
- For WIP code (TODOs, stubs), document actual current behavior and mark incomplete parts "[WIP]."
- For hidden side effects (e.g., a `get_user` function that also writes to an audit log), flag them prominently at the top. These are exactly the surprises that cause incidents.

**Step 5: Generate inline documentation** in the language's native format, ready to paste above the declaration.

**Step 6: Generate the markdown reference** (see Output Format below).

**Step 7: Write at least one realistic usage example** using the actual function signature, real types, and plausible domain values. Show setup for external resources and how to use complex return values.

## Voice Guards

Write docs the way the best-documented codebases do it:
- No filler phrases like "This function is used to." Start with the verb: "Validates," "Sends," "Parses."
- No `foo`, `bar`, or `test123` in examples. Use values from the actual domain.
- No prose where a table would be clearer. Parameters, error codes, and enums belong in tables.
- No describing what the code "should" or "is intended to" do. Document what it does now.
- No skipping error cases. Every failure mode must be documented.
- No em dashes anywhere. Use commas, periods, semicolons, or "and" instead.
- Mark internal APIs clearly: "Internal. Not part of the public API. May change without notice."

## Self-Critique Gate

Before outputting, verify all of the following. If any check fails, revise before continuing.
- Every documented parameter exists in the actual signature. No extras, no missing ones.
- Every documented error corresponds to real error handling in the code.
- Your example compiles or runs against the real function with correct name, argument order, and types.
- Every side effect from Step 3 appears in the docs. None quietly omitted.
- You described only behavior that exists in the current code, not comments about future plans.

## Output Format

Produce two outputs, both production-ready. No TODOs or placeholders.

**Output 1: Inline Documentation.** The doc comment for the detected language, ready to paste into the source file. Note where to insert it.

**Output 2: Markdown Reference.**

```
# <name>
<One-sentence description starting with a verb.>
## When to Use
When you need to [use case]. Answer: "I need to do X, is this the right function?"
## Signature
Full signature in a fenced code block.
## Parameters / Returns / Errors
Tables.
## Side Effects
Bulleted list, or "None" if the function is pure.
## Examples
Realistic, runnable code with brief annotations.
## Notes
Caveats, performance, thread safety, related functions.
```

## Grounding Rules

- Base all documentation on source code you actually read. If you cannot find the code, say so and stop.
- Do not invent parameters, return types, or behaviors. Mark anything ambiguous with "[VERIFY]."
- If the project has an existing doc style, match it. The goal is docs that look native to the codebase, not docs that look like they were generated.
