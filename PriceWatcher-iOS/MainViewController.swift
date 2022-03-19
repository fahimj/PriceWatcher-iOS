//
//  MainViewController.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 18/03/22.
//

import UIKit
import Charts

class MainViewController: UITableViewController {
    init() {
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lineChartView:LineChartView = {
        LineChartView()
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        setupChart()
        
        var lineChartEntry = [ChartDataEntry]()
        lineChartEntry.append(ChartDataEntry(x: 0.0, y: 0.0))
        lineChartEntry.append(ChartDataEntry(x: 1.0, y: 1.0))
        lineChartEntry.append(ChartDataEntry(x: 3.0, y: 2.0))
        lineChartEntry.append(ChartDataEntry(x: 4.0, y: 1.0))
        lineChartEntry.append(ChartDataEntry(x: 5.0, y: 1.0))
        lineChartEntry.append(ChartDataEntry(x: 6.0, y: 1.0))
        lineChartEntry.append(ChartDataEntry(x: 7.0, y: 1.0))
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number")
        line1.lineWidth = 1.75
        line1.circleRadius = 5.0
        line1.circleHoleRadius = 2.5
        line1.setColor(.black)
        line1.setCircleColor(.black)
        line1.highlightColor = .black
        line1.drawValuesEnabled = false
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        line1.fillAlpha = 1
        line1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        line1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: line1)
        lineChartView.data = data
        
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true

    }
    
    private func setupChart() {
//        lineChartView.backgroundColor = UIColor.red
        lineChartView.chartDescription.enabled = false
//        lineChartView.dragEnabled = true
//        lineChartView.setScaleEnabled(true)
//        lineChartView.pinchZoomEnabled = false
//        lineChartView.setViewPortOffsets(left: 10, top: 0, right: 10, bottom: 0)
        
        lineChartView.legend.enabled = false
        
        lineChartView.leftAxis.enabled = false
//        lineChartView.leftAxis.spaceTop = 0.4
//        lineChartView.leftAxis.spaceBottom = 0.4
        lineChartView.rightAxis.enabled = false
//        lineChartView.axis
//        lineChartView.xAxis.enabled = false
        lineChartView.animate(xAxisDuration: 0.5)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        return lineChartView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        return UIButton()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "TEST")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TEST")
        }
        
        cell.textLabel?.text = "TEST"
        return cell
    }
}
