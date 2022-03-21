//
//  MainViewController.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 18/03/22.
//

import UIKit
import Charts

class MainViewController: UITableViewController, MainViewProtocol {
    init(presenter: MainViewPresenter) {
        self.presenter = presenter
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        presenter.mainView = nil
    }
    
    let presenter: MainViewPresenter
    
    lazy var lineChartView:LineChartView = {
        LineChartView()
    }()
    
    lazy var refreshButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(someButtonAction), for: .touchUpInside)
        button.backgroundColor = .blue
        button.setTitle("Refresh", for: .normal)
        return button
    }()
    
    @objc private func someButtonAction() {
        presenter.refreshChart()
        presenter.refreshTableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        
        tableView.register(UINib.init(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
        
        presenter.refreshChart()
        presenter.refreshTableData()
    }
    
    func refreshTableView() {
            self.tableView.reloadData()
    }
    
    func refreshChart(prices:[Price]) {
        let chartEntry = mapToChartDataEntry(prices: prices)
        refreshChart(chartEntry: chartEntry)
    }
    
    private func mapToChartDataEntry(prices:[Price]) -> [ChartDataEntry] {
        prices.map{price in
            let secondsPerDay = 24.0 * 3600.0
            let x = price.date.timeIntervalSince1970 / secondsPerDay
            return ChartDataEntry(x: x, y: price.value)
        }
    }
    
    private func refreshChart(chartEntry:[ChartDataEntry]) {
        let line1 = LineChartDataSet(entries: chartEntry, label: "Number")
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
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true
        lineChartView.xAxis.valueFormatter = DateAxisValueFormatter()
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
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        return lineChartView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        return refreshButton
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(presenter.displayedRequestActivities.count,5)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell") as! ActivityTableViewCell
        
        cell.configureData(data: presenter.displayedRequestActivities[indexPath.row])
        
        return cell
    }
}

class DateAxisValueFormatter : NSObject, AxisValueFormatter
{
    let dateFormatter = DateFormatter()
    
    override init()
    {
        super.init()
        dateFormatter.dateFormat = "HH:mm"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        let secondsPerDay = 24.0 * 3600.0
        let date = Date(timeIntervalSince1970: value * secondsPerDay)
        return dateFormatter.string(from: date)
    }
}
