//
//  CoachScoreYearMarkerView.swift
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/1/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

import Foundation
import Charts

open class CoachScoreYearMarkerView: BalloonMarker {
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
        setLabel("Year: " + xAxisValueFormatter!.stringForValue(entry.x, axis: nil) + "\nCoach Score: " + yFormatter.string(from: NSNumber(floatLiteral: entry.y))!)
    }
}
