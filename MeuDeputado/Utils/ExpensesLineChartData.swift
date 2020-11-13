import Charts

final class ExpensesLineChartData: LineChartData {
    
    // Some tokens declared in this project has diffent effect when applied to the chart.
    convenience init(entries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: entries, label: nil)
        set.lineWidth = Thickness.medium
        set.setColor(.primary)
        set.setCircleColor(.primary)
        set.circleHoleColor = .neutralLighter
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        set.highlightColor = .clear
        set.circleHoleRadius = 3.5
        
        self.init(dataSet: set)
    }
}
