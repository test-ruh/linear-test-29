import { LayoutDashboard } from "lucide-react";
import type { ComponentType } from "react";

import OverviewTab from "@/tabs/overview";

export type DashboardRoute = {
  id: string;
  label: string;
  icon?: typeof LayoutDashboard;
  Component: ComponentType;
  hint?: string;
};

export const routes: DashboardRoute[] = [
  {
    id: "overview",
    label: "Overview",
    icon: LayoutDashboard,
    Component: OverviewTab,
    hint: "Schedules, notifier scope, and representative Todo reminders"
  }
];

export const defaultRouteId = "overview";
