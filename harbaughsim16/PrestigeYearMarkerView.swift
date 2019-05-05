//  PrestigeYearMarkerView.swift
//  Modified from XYMarkerView.swift in ChartsDemo
// from https://github.com/danielgindi/Charts
// (Copyright © 2016 dcg. All rights reserved.)

import Foundation
import Charts

open class PrestigeYearMarkerView: BalloonMarker
{
    @objc open var xAxisValueFormatter: IAxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                      xAxisValueFormatter: IAxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 0
        yFormatter.maximumFractionDigits = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel("Year: " + xAxisValueFormatter!.stringForValue(entry.x, axis: nil) + "\nPrestige: " + yFormatter.string(from: NSNumber(floatLiteral: entry.y))!)
    }
    
}
