# Step 5 of 5 — Access

## User Access

### Authorized Teams

| Team               | Access Level | Members (approx) |
|--------------------|-------------|-------------------|
| Requester | recipient | The single requester who receives the Slack DMs. |
| Automation Operators | maintainer | Authorized maintainers who manage secrets and runtime deployment. |

### Restricted From

| Team / Role          | Reason                          |
|----------------------|---------------------------------|
| General workspace members | This agent is requester-only and does not post to channels or support other recipients. |
| Linear writers | The agent is read-only toward Linear and cannot modify ticket state. |

## HiTL Approvers

| Skill                | Action                         | Approver             | Fallback Approver    |
|----------------------|--------------------------------|----------------------|----------------------|
| send-slack-dm | Send approved scheduled Slack DM to the requester | No human approval required for the confirmed unattended MVP | Pause the schedule if outbound delivery should stop |

## Model Configuration

| Field                | Value                          |
|----------------------|--------------------------------|
| **Primary Model**    | gpt-4.1   |
| **Fallback Model**   | gpt-4.1-mini  |

## Token Budget

| Field                  | Value                  |
|------------------------|------------------------|
| **Monthly Budget**     | 150000 tokens |
| **Alert Threshold**    | 120000 tokens |
| **Auto-Pause on Limit**| No |

## Security & Permissions

| Permission                         | Allowed    |
|------------------------------------|------------|
| Read Linear tickets | ✅ |
| Write Linear tickets | ❌ |
| Send Slack direct messages | ✅ |
| Send Slack channel messages | ❌ |
| Write application database tables | ❌ |
