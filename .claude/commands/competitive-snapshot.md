You are producing a structured competitive analysis snapshot.

The user will provide a product, project, or company name to analyze. Parse it from:

$ARGUMENTS

If no product or project name is provided, ask the user what they want analyzed before proceeding.

Research and produce a competitive snapshot with the following sections:

## Overview
A brief summary of what the competitor offers. Stick to facts. Include the product category, target audience, deployment model (SaaS, self-hosted, hybrid, etc.), and current version or release status if known.

## What They Do Well
A bullet list of genuine strengths. Be honest. Ignoring a competitor's real advantages makes the analysis useless. Focus on:
- Technical capabilities
- Developer experience
- Community and ecosystem
- Pricing model
- Documentation and onboarding

## Where They Fall Short
A bullet list of weaknesses, gaps, or common complaints. Pull from public sources like GitHub issues, community forums, and published reviews. Do not make things up. If you are uncertain about a claim, prefix it with "Unverified:" and explain why.

## How Red Hat's Offering Differs
A comparison of how Red Hat's approach or products address the same space. Be specific about technical differences, not just marketing positioning. Cover:
- Architecture or design differences
- Integration points (OpenShift, RHEL, Ansible, etc.)
- Support and lifecycle commitments
- Open source strategy and upstream involvement

If there is no direct Red Hat competitor in this space, say so clearly rather than forcing a comparison.

## Key Takeaways
Three to five bullet points summarizing what the team should know. Focus on actionable insights, not opinions.

## Sources and Caveats
Note where your information came from and flag anything that may be outdated or unverifiable. Competitive landscapes change fast, so date-stamp your analysis.

## Output Format

Output clean markdown. Use tables for side-by-side comparisons if they help. Keep each section concise.

## Rules

- Keep the tone neutral and analytical. This is an engineering tool, not a sales deck.
- Only state facts you can attribute to a public source. If you are working from general knowledge rather than a specific source, say so.
- Do not invent market share numbers, benchmark results, or pricing details you are not confident about.
- If the product is obscure or you have limited information, say "Limited public information available" and work with what you have rather than padding with speculation.
- The goal is to help the team make informed technical decisions.
