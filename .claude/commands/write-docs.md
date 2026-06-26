You are generating documentation for source code.

The user will provide a file path, function name, module name, class name, or API endpoint to document. Parse it from:

$ARGUMENTS

If no input is provided, ask the user what they want documented before proceeding.

## Input Handling

Determine what the user wants documented:
- **File path:** Read the file and document all public functions, classes, and exports.
- **Function or class name:** Search the current project for the definition, read it, and document it.
- **Module or package name:** Find the module entry point, read it, and document its public API.
- **API endpoint:** Find the route handler, read it, and document the endpoint.

If the target cannot be found, tell the user what you searched for and where you looked. Do not generate documentation for code you have not read.

## Steps

1. Read the source code for the target.
2. Identify the programming language and documentation conventions for that language (e.g., JSDoc for JavaScript, docstrings for Python, GoDoc for Go, Javadoc for Java).
3. Analyze the code to extract:
   - Purpose and behavior
   - Parameters, their types, and whether they are required or optional
   - Return values and their types
   - Exceptions or errors that can be raised
   - Side effects (file I/O, network calls, state mutations)
   - Dependencies and imports
4. Generate documentation in the appropriate format for the language.

## Output Format

Produce two outputs:

### 1. Inline Documentation
Documentation formatted for insertion directly into the source code (docstring, JSDoc comment, etc.), following the conventions of the detected language.

### 2. Reference Documentation
A markdown document with this structure:

```
# <name>

## Description
What this code does and when to use it.

## Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| param1 | string | Yes | What it does |

## Returns
What the function returns, including type and structure.

## Errors
What errors can be raised and under what conditions.

## Examples
```<language>
// Usage example derived from the actual code
```

## Notes
Any caveats, performance considerations, or related functions.
```

## Rules

- Only document what the code actually does. Do not describe intended behavior that is not implemented.
- If the code is unclear or has no comments, document what you can determine from reading it. Flag anything uncertain with "Behavior unclear from source."
- Use the documentation style conventions of the language (e.g., Google style for Python, JSDoc for JS/TS).
- Include realistic usage examples based on the actual function signature and types.
- Do not generate placeholder examples with fake data that would not work.
- If the function is private or internal (prefixed with underscore, not exported, etc.), note that in the documentation.
- Keep descriptions concise. Engineers read docs to get answers, not to read prose.
