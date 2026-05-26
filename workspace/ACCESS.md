# Step 5 of 5 — Access

## User Access

### Authorized Teams

| Team               | Access Level | Members (approx) |
|--------------------|-------------|-------------------|
| Requester | operator | Single approved requester only |
| Platform Admins | maintainer | OpenClaw workspace maintainers |

### Restricted From

| Team / Role          | Reason                          |
|----------------------|---------------------------------|
| Other workspace members | The approved scope supports only the requester and only Slack DM delivery to that requester. |

## HiTL Approvers

| Skill                | Action                         | Approver             | Fallback Approver    |
|----------------------|--------------------------------|----------------------|----------------------|
| None | No HiTL steps — fully automated | N/A | N/A |

## Model Configuration

| Field                | Value                          |
|----------------------|--------------------------------|
| **Primary Model**    | gpt-5   |
| **Fallback Model**   | gpt-4.1  |

## Token Budget

| Field                  | Value                  |
|------------------------|------------------------|
| **Monthly Budget**     | 250000 tokens |
| **Alert Threshold**    | 200000 tokens |
| **Auto-Pause on Limit**| No |

## Security & Permissions

| Permission                         | Allowed    |
|------------------------------------|------------|
| Read Linear tickets assigned to requester | ✅ |
| Send Slack direct messages to requester | ✅ |
| Modify Linear tickets | ❌ |
| Send to Slack channels or other recipients | ❌ |
