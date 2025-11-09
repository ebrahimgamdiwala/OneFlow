"use client"

import * as React from "react"
import { Pie, PieChart, Sector } from "recharts"

import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from "@/components/ui/chart"

const BillableHoursChart = ({ billable, nonBillable }) => {
  const chartData = [
    { type: "billable", hours: billable, fill: "var(--color-billable)" },
    { type: "nonBillable", hours: nonBillable, fill: "var(--color-nonBillable)" },
  ]

  const chartConfig = {
    hours: {
      label: "Hours",
    },
    billable: {
      label: "Billable",
      color: "hsl(var(--chart-1))",
    },
    nonBillable: {
      label: "Non-billable",
      color: "hsl(var(--chart-2))",
    },
  }

  const totalHours = React.useMemo(() => {
    return chartData.reduce((acc, curr) => acc + curr.hours, 0)
  }, [chartData])

  return (
    <ChartContainer
      config={chartConfig}
      className="mx-auto aspect-square h-[250px]"
    >
      <PieChart>
        <ChartTooltip
          cursor={false}
          content={<ChartTooltipContent hideLabel />}
        />
        <Pie
          data={chartData}
          dataKey="hours"
          nameKey="type"
          innerRadius={60}
          strokeWidth={5}
          activeIndex={0}
          activeShape={({
            outerRadius = 0,
            ...props
          }) => (
            <g>
              <Sector {...props} outerRadius={outerRadius + 10} />
              <Sector
                {...props}
                outerRadius={outerRadius}
                innerRadius={outerRadius - 8}
              />
            </g>
          )}
        >
        </Pie>
      </PieChart>
    </ChartContainer>
  )
}

export default BillableHoursChart;
