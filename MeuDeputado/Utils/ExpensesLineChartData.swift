import Charts

class ExpensesLineChartDataSet: LineChartDataSet {
    init(
        entries: [ChartDataEntry]?,
        label: String? = nil,
        drawCirclesEnabled: Bool = true
    ) {
        super.init(entries: entries, label: label)
        
        lineWidth = Thickness.medium
        setColor(.primary)
        setCircleColor(.primary)
        circleHoleColor = .neutralLighter
        mode = .horizontalBezier
        drawValuesEnabled = false
        highlightColor = .clear
        circleHoleRadius = 3.5
        self.drawCirclesEnabled = drawCirclesEnabled
    }
    
    required init() {
        super.init()
    }
}
