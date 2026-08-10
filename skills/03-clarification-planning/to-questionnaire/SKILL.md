---
name: to-questionnaire
description: Draft a Markdown questionnaire for an external knowledge holder to answer asynchronously. Use when another person has private context, facts, or decisions the current user cannot supply; use $research for verifiable source facts and $grilling for live decisions with the current user.
---

# To Questionnaire

Interview the user about the send, not the subject they cannot answer.

1. Establish who will receive it: role, expertise, relationship to the user, and what context they already have.
2. Establish what must come back: the concrete facts or decisions the user needs after the response.
3. Draft the document from [assets/questionnaire-template.md](assets/questionnaire-template.md).
4. Verify that every required outcome has a corresponding question, then write `to-questionnaire-<topic>.md` in the current directory and report the path.

Order questions by decision value because the recipient may answer only once. Keep each question to one idea, include an answer stub, and add “why this matters” only when it prevents a likely misunderstanding. Group longer questionnaires by theme and explicitly welcome partial or uncertain answers.
