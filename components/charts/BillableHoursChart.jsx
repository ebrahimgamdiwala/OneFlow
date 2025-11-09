"use client"

import * as React from "react"
import { Pie, PieChart, Cell, Legend, ResponsiveContainer } from "recharts"

const COLORS = {
  billable: '#10b981',    // Emerald green
  nonBillable: '#f59e0b'  // Amber orange
};

const BillableHoursChart = ({ billable, nonBillable }) => {
  const chartData = [
    { name: "Billable Hours", value: parseFloat(billable) || 0, color: COLORS.billable },
    { name: "Non-Billable Hours", value: parseFloat(nonBillable) || 0, color: COLORS.nonBillable },
  ];

  const totalHours = chartData.reduce((acc, curr) => acc + curr.value, 0);

  // Custom label to show percentage
  const renderCustomLabel = ({ cx, cy, midAngle, innerRadius, outerRadius, percent }) => {
    const RADIAN = Math.PI / 180;
    const radius = innerRadius + (outerRadius - innerRadius) * 0.5;
    const x = cx + radius * Math.cos(-midAngle * RADIAN);
    const y = cy + radius * Math.sin(-midAngle * RADIAN);

    return (
      <text
        x={x}
        y={y}
        fill="white"
        textAnchor={x > cx ? 'start' : 'end'}
        dominantBaseline="central"
        className="font-bold text-sm"
      >
        {`${(percent * 100).toFixed(0)}%`}
      </text>
    );
  };

  // Custom legend
  const renderLegend = (props) => {
    const { payload } = props;
    return (
      <div className="flex justify-center gap-6 mt-4">
        {payload.map((entry, index) => (
          <div key={`legend-${index}`} className="flex items-center gap-2">
            <div 
              className="w-4 h-4 rounded-full" 
              style={{ backgroundColor: entry.color }}
            />
            <span className="text-sm font-medium">
              {entry.value}: {chartData[index].value.toFixed(2)}h
            </span>
          </div>
        ))}
      </div>
    );
  };

  return (
    <div className="w-full h-[400px]">
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Pie
            data={chartData}
            cx="50%"
            cy="50%"
            labelLine={false}
            label={renderCustomLabel}
            outerRadius={120}
            innerRadius={60}
            fill="#8884d8"
            dataKey="value"
            animationBegin={0}
            animationDuration={800}
          >
            {chartData.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.color} />
            ))}
          </Pie>
          <Legend content={renderLegend} />
        </PieChart>
      </ResponsiveContainer>
      
      {totalHours === 0 && (
        <div className="text-center mt-4 text-muted-foreground">
          <p>No hours logged yet. Start tracking your time!</p>
        </div>
      )}
      
      {totalHours > 0 && (
        <div className="text-center mt-4">
          <p className="text-2xl font-bold">{totalHours.toFixed(2)}</p>
          <p className="text-sm text-muted-foreground">Total Hours</p>
        </div>
      )}
    </div>
  )
}

export default BillableHoursChart;
