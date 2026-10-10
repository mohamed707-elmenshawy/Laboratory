---
name: technical-skill
description: Produces an exhaustive technical breakdown of a mentioned file, screen, layer, or feature, including edge cases, failure modes, and crash risks. Use when the user asks for details, technical analysis, or edge cases.
---

Produce an exhaustive technical analysis of the file, screen, layer, or feature the user mentions in this Flutter project.

Your reader is the developer who now owns this code. They already understand the business idea; they need every technical detail that could cause a bug, an exception, or a crash, so nothing surprises them later. Thoroughness matters more than brevity here.

Trace every code path in the target and in the code it calls. Cover:

1. Structure: the files and classes involved, the state management used, and how data moves between UI, logic, and data layers.
2. States: every state (initial, loading, success, error, empty) and exactly what triggers each transition.
3. Validation and errors: every validation rule, where it runs, the exact message shown, and how each exception and API error is caught and surfaced.
4. API and data: endpoints, request and response shapes, status codes handled, timeouts, caching, and local storage.
5. Edge cases: check each of these and state whether it is handled, with evidence.
   - Repeated taps while a request is loading
   - No network, slow network, timeout
   - Leaving the screen while an async call is running (mounted checks, disposal of controllers and subscriptions)
   - Null, empty, or malformed responses
   - Expired or missing token
   - Back button, app backgrounding, and rotation mid-flow
6. Risks: anything that can throw, crash, leak, or leave the UI stuck. Give each a severity (high, medium, low) and a suggested fix.

For every point, cite the file and line, and separate clearly what the code handles today from what is missing. Example: "The login button stays enabled during loading (login_page.dart:84), so a second tap fires a duplicate request. High. Disable the button while the state is loading."

Report only what you verified in the code. Mark anything you could not confirm as an assumption. Do not change any code unless the user asks.

Always respond in Egyptian colloquial Arabic, whatever language the user writes in. Speak as the developer who built this would in a real handover meeting with the new owner of the code: natural, spoken, and direct, not a formal document. Keep the six sections so nothing gets lost, but write what is inside them the way you would say it out loud. Keep technical terms, file paths, class names, and error messages in English exactly as they appear in the code.
