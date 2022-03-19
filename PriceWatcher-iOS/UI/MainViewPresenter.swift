//
//  MainViewPresenter.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct DisplayedPriceRequest {
    let time: Date
    let value: Double
    let latitude: Double
    let longitude: Double
}

protocol MainViewProtocol : AnyObject {
    func refreshChart(prices:[Price])
    func refreshTableView()
}

class MainViewPresenter {
    var displayedChartPrices:[Price] = []
    var displayedRequestActivities:[DisplayedPriceRequest] = []
    weak var mainView:MainViewProtocol?
    let priceSeriesLoader: PriceSeriesLoader
    let cache: PriceDataRequestActivityCache
    
    init(priceSeriesLoader: PriceSeriesLoader, cache: PriceDataRequestActivityCache) {
        self.priceSeriesLoader = priceSeriesLoader
        self.cache = cache
    }
    
    func refreshChart() {
        Task.init {
            do {
                displayedChartPrices = try await priceSeriesLoader.load(pair: "BTCUSD")
                mainView?.refreshChart(prices: displayedChartPrices)
            } catch {
                
            }
        }
    }
    
    func refreshTableData() {
        Task.init {
            do {
                let activities = try await cache.loadCache()
                displayedRequestActivities = activities.map{activity in
                    DisplayedPriceRequest(time: activity.date, value: activity.prices.first?.value ?? 0, latitude: activity.location.latitude, longitude: activity.location.longitude)
                }
                mainView?.refreshTableView()
            } catch {
                
            }
        }
    }
}
