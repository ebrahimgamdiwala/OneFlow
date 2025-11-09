"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Clock, PieChart } from "lucide-react";
import BillableHoursChart from "@/components/charts/BillableHoursChart";

export default function AnalyticsPage() {
  const [stats, setStats] = useState({
    hoursLogged: 0,
    billableHours: 0,
    nonBillableHours: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAnalyticsData();
  }, []);

  const fetchAnalyticsData = async () => {
    try {
      const timesheetStatsRes = await fetch("/api/timesheets/stats");

      if (timesheetStatsRes.ok) {
        const timesheetStats = await timesheetStatsRes.json();
        setStats({
          hoursLogged: parseFloat(timesheetStats.totalHours),
          billableHours: parseFloat(timesheetStats.billableHours),
          nonBillableHours: parseFloat(timesheetStats.nonBillableHours),
        });
      }
    } catch (error) {
      console.error("Error fetching analytics data:", error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="container mx-auto p-6 max-w-7xl space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Analytics Dashboard</h1>
        <p className="text-muted-foreground mt-1">
          Insights into your team's performance and project metrics.
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        <Card className="border-border/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Hours Logged</CardTitle>
            <Clock className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.hoursLogged.toFixed(2)}</div>
            <p className="text-xs text-muted-foreground">Total hours on projects</p>
          </CardContent>
        </Card>
      </div>

      <Card className="border-border/40">
        <CardHeader>
          <CardTitle>Billable Hours Breakdown</CardTitle>
          <CardDescription>
            A visual representation of billable vs. non-billable hours logged across all projects.
          </CardDescription>
        </CardHeader>
        <CardContent className="pl-2">
          <BillableHoursChart
            billable={stats.billableHours}
            nonBillable={stats.nonBillableHours}
          />
        </CardContent>
      </Card>
    </div>
  );
}
