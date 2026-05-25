import {
  Badge,
  Button,
  Card,
  CardContent,
  CardHeader,
  Separator
} from "@ruh-ai/ruh-design-system";
import {
  BellRing,
  CalendarClock,
  CheckCircle2,
  Clock3,
  Filter,
  Link2,
  MessageSquareMore,
  ShieldCheck,
  Slack,
  Ticket,
  UserRound
} from "lucide-react";

// Stub data — preview fallback + cold-start initial render.
const reminderRuns = [
  {
    id: "rem-001",
    workflow: "Reminder check",
    schedule: "Every 30 minutes",
    cron: "*/30 * * * *",
    timezone: "UTC",
    status: "Configured",
    purpose: "Check assigned tickets with exact status Todo and DM when matches exist."
  },
  {
    id: "rep-001",
    workflow: "Daily report",
    schedule: "10:00 AM daily",
    cron: "0 10 * * *",
    timezone: "Asia/Kolkata",
    status: "Configured",
    purpose: "Summarize yesterday-created assigned Todo tickets with count and list."
  }
];

// Stub data — preview fallback + cold-start initial render.
const stubTodoTickets = [
  {
    id: "ENG-241",
    title: "Finalize onboarding checklist copy for the new billing flow",
    team: "Growth",
    project: "Q2 Conversion Cleanup",
    status: "Todo",
    createdAt: "2026-05-24T07:45:00Z",
    link: "https://linear.app/example/issue/ENG-241"
  },
  {
    id: "ENG-238",
    title: "Review customer migration edge cases before rollout",
    team: "Platform",
    project: "Workspace Migration",
    status: "Todo",
    createdAt: "2026-05-24T05:10:00Z",
    link: "https://linear.app/example/issue/ENG-238"
  },
  {
    id: "ENG-233",
    title: "Prepare handoff notes for analytics dashboard refactor",
    team: "Data",
    project: "Metrics Reliability",
    status: "Todo",
    createdAt: "2026-05-23T12:20:00Z",
    link: "https://linear.app/example/issue/ENG-233"
  },
  {
    id: "ENG-229",
    title: "Confirm design QA fixes for Slack alert formatting",
    team: "Ops",
    project: "Notifier Hardening",
    status: "Todo",
    createdAt: "2026-05-22T16:05:00Z",
    link: "https://linear.app/example/issue/ENG-229"
  }
];

// Stub data — preview fallback + cold-start initial render.
const reportPreview = {
  sendTime: "10:00 AM IST",
  scope: "Assigned tickets created yesterday and still in exact status Todo",
  count: 2,
  items: ["ENG-241 · Finalize onboarding checklist copy", "ENG-238 · Review customer migration edge cases"]
};

const configFacts = [
  {
    icon: Slack,
    label: "Delivery channel",
    value: "Slack DM only",
    note: "No channels, groups, or shared inboxes in scope."
  },
  {
    icon: UserRound,
    label: "Audience",
    value: "Requester only",
    note: "The notifier never targets anyone else."
  },
  {
    icon: Filter,
    label: "Todo definition",
    value: "Status exactly Todo",
    note: "No broader backlog or in-progress statuses included."
  },
  {
    icon: ShieldCheck,
    label: "Linear access",
    value: "Read-only",
    note: "The agent inspects ticket metadata but does not modify issues."
  }
];

function SectionHeading({ icon: Icon, title, subtitle }: { icon: typeof Ticket; title: string; subtitle: string }) {
  return (
    <div className="flex items-start gap-3">
      <div className="mt-0.5 flex h-9 w-9 items-center justify-center rounded-xl bg-muted">
        <Icon size={18} />
      </div>
      <div>
        <h2 className="m-0 text-lg font-semibold">{title}</h2>
        <p className="m-0 text-sm text-muted-foreground">{subtitle}</p>
      </div>
    </div>
  );
}

export function OverviewTab() {
  return (
    <section aria-label="Linear Todo notifier overview" className="space-y-6 p-6">
      <Card className="overflow-hidden border-l-4 border-l-primary">
        <CardContent className="space-y-5 py-6">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
            <div className="max-w-3xl space-y-3">
              <Badge variant="secondary" className="gap-1">
                <BellRing size={14} /> Requester-focused Slack notifier
              </Badge>
              <div>
                <h2 className="m-0 text-2xl font-semibold tracking-tight">Keeps the requester’s Linear Todo queue impossible to miss.</h2>
                <p className="mt-2 mb-0 max-w-2xl text-sm leading-6 text-muted-foreground">
                  This agent watches Linear tickets assigned to the requester, filters for items whose status is exactly <strong>Todo</strong>, and sends concise Slack DMs on a recurring cadence. It handles both the ongoing reminder loop and the morning catch-up report without writing back to Linear.
                </p>
              </div>
            </div>
            <div className="grid min-w-0 gap-3 sm:grid-cols-2 lg:w-[340px]">
              <Card size="sm">
                <CardContent className="py-4">
                  <p className="m-0 text-xs uppercase tracking-[0.18em] text-muted-foreground">Reminder cadence</p>
                  <p className="mt-2 mb-0 text-lg font-semibold">Every 30 minutes</p>
                  <p className="mt-1 mb-0 text-xs text-muted-foreground">Runs when assigned Todo tickets exist.</p>
                </CardContent>
              </Card>
              <Card size="sm">
                <CardContent className="py-4">
                  <p className="m-0 text-xs uppercase tracking-[0.18em] text-muted-foreground">Daily report</p>
                  <p className="mt-2 mb-0 text-lg font-semibold">10:00 AM IST</p>
                  <p className="mt-1 mb-0 text-xs text-muted-foreground">Covers yesterday-created Todo tickets.</p>
                </CardContent>
              </Card>
            </div>
          </div>

          <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-4">
            {configFacts.map((fact) => {
              const Icon = fact.icon;
              return (
                <Card key={fact.label} size="sm">
                  <CardContent className="space-y-2 py-4">
                    <div className="flex items-center gap-2 text-sm font-medium">
                      <Icon size={16} />
                      <span>{fact.label}</span>
                    </div>
                    <p className="m-0 text-base font-semibold">{fact.value}</p>
                    <p className="m-0 text-xs leading-5 text-muted-foreground">{fact.note}</p>
                  </CardContent>
                </Card>
              );
            })}
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-6 xl:grid-cols-[1.15fr_0.85fr]">
        <Card>
          <CardHeader>
            <SectionHeading
              icon={CalendarClock}
              title="Schedule and trigger map"
              subtitle="The two scheduled jobs this notifier depends on, with cadence and delivery intent."
            />
          </CardHeader>
          <CardContent className="space-y-4">
            {reminderRuns.map((item, index) => (
              <div key={item.id} className="space-y-3">
                <div className="flex flex-col gap-3 rounded-2xl border p-4 md:flex-row md:items-start md:justify-between">
                  <div className="space-y-2">
                    <div className="flex items-center gap-2">
                      <p className="m-0 text-sm font-semibold">{item.workflow}</p>
                      <Badge>{item.status}</Badge>
                    </div>
                    <p className="m-0 text-sm text-muted-foreground">{item.purpose}</p>
                    <div className="flex flex-wrap gap-2 text-xs text-muted-foreground">
                      <Badge variant="outline" className="gap-1"><Clock3 size={12} /> {item.schedule}</Badge>
                      <Badge variant="outline">{item.cron}</Badge>
                      <Badge variant="outline">TZ · {item.timezone}</Badge>
                    </div>
                  </div>
                  <Button variant="secondary" size="sm" disabled>
                    Triggered by schedule
                  </Button>
                </div>
                {index < reminderRuns.length - 1 ? <Separator /> : null}
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <SectionHeading
              icon={MessageSquareMore}
              title="Morning report preview"
              subtitle="What the 10:00 AM IST Slack DM is designed to summarize at a glance."
            />
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="rounded-2xl border bg-muted/30 p-4">
              <div className="flex items-center justify-between gap-3">
                <div>
                  <p className="m-0 text-sm font-semibold">Daily DM summary</p>
                  <p className="m-0 text-xs text-muted-foreground">Sent at {reportPreview.sendTime}</p>
                </div>
                <Badge className="gap-1">
                  <CheckCircle2 size={12} /> {reportPreview.count} tickets
                </Badge>
              </div>
              <p className="mt-3 mb-0 text-sm text-muted-foreground">{reportPreview.scope}</p>
              <div className="mt-4 space-y-2">
                {reportPreview.items.map((item) => (
                  <div key={item} className="rounded-xl bg-background px-3 py-2 text-sm">
                    {item}
                  </div>
                ))}
              </div>
            </div>
            <div className="rounded-2xl border p-4">
              <p className="m-0 text-sm font-semibold">Why this exists</p>
              <p className="mt-2 mb-0 text-sm leading-6 text-muted-foreground">
                The morning report narrows attention to newly created work from yesterday that has not moved out of Todo, giving the requester a clean scan of unattended tickets before the workday starts.
              </p>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 xl:grid-cols-[1.1fr_0.9fr]">
        <Card>
          <CardHeader>
            <SectionHeading
              icon={Ticket}
              title="Likely reminder ticket list"
              subtitle="Representative Linear items the notifier would include when assigned Todo work is present."
            />
          </CardHeader>
          <CardContent className="space-y-3">
            {stubTodoTickets.map((ticket) => (
              <div key={ticket.id} className="rounded-2xl border p-4">
                <div className="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                  <div className="space-y-2">
                    <div className="flex flex-wrap items-center gap-2">
                      <Badge>{ticket.id}</Badge>
                      <Badge variant="outline">{ticket.team}</Badge>
                      <Badge variant="secondary">{ticket.project}</Badge>
                    </div>
                    <p className="m-0 text-sm font-semibold">{ticket.title}</p>
                    <p className="m-0 text-xs text-muted-foreground">Created {new Date(ticket.createdAt).toLocaleString("en-US", { month: "short", day: "numeric", hour: "numeric", minute: "2-digit", timeZone: "UTC", hour12: true })} UTC · Status {ticket.status}</p>
                  </div>
                  <div className="flex items-center gap-2 text-xs text-muted-foreground">
                    <Link2 size={14} />
                    <span className="max-w-[220px] truncate">{ticket.link}</span>
                  </div>
                </div>
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <SectionHeading
              icon={ShieldCheck}
              title="Operator guardrails"
              subtitle="The non-negotiable scope boundaries for this notifier’s Slack reminders."
            />
          </CardHeader>
          <CardContent className="space-y-3">
            {[
              "Only tickets assigned to the requester are evaluated.",
              "Only the exact status Todo qualifies for reminders and reports.",
              "Slack DM is the only delivery surface in the confirmed scope.",
              "Linear is read-only: no ticket edits, transitions, or comments.",
              "The MVP avoids extra persistence and focuses on schedule visibility and delivery outcomes."
            ].map((rule) => (
              <div key={rule} className="flex items-start gap-3 rounded-2xl border p-4">
                <CheckCircle2 className="mt-0.5" size={16} />
                <p className="m-0 text-sm leading-6">{rule}</p>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>
    </section>
  );
}

export default OverviewTab;
