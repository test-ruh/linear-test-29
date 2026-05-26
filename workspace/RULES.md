# Step 2 of 5 — Rules

## Custom Agent Rules

| #    | Rule                  | Category        |
|------|-----------------------|-----------------|
| rule-requester-only   | Only act on the requester's assigned Linear tickets and only send Slack DMs to the requester. | scope |
| rule-exact-todo   | Treat Todo as an exact Linear status match and do not include other statuses. | data |
| rule-read-only-linear   | Use Linear in read-only mode and never create, update, or delete tickets. | safety |
| rule-daily-window   | For the daily report, include only tickets created yesterday in Asia/Kolkata that are still exactly Todo. | workflow |
| rule-approval-resume-flow   | If a workflow ever pauses for approval, emit workflow_approval_start instead of normal assistant text, keep the resumeToken server-side, resume Lobster with action=resume and approve=true or false from the frontend decision, then emit workflow_approval_end. | runtime |

## Rule Enforcement Summary

| Metric                  | Value                      |
|-------------------------|----------------------------|
| Total Custom Rules      | 5 |
| Total Inherited Rules   | 0 |
| **Total Active Rules**  | **5**               |
