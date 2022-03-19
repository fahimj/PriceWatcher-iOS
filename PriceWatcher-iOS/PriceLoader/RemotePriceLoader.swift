//
//  RemotePriceLoader.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation
import Combine

class HttpClient {
    enum HttpClientError : Error {
        case invalidUrl
        case responseError
    }
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    func load(urlString:String) async throws -> Data {
        guard let url = URL.init(string: urlString) else {throw HttpClientError.invalidUrl}
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw HttpClientError.responseError
            }
        return data
    }
}

class RemotePriceLoader {
    let httpClient:HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func load() async throws -> [Price] {
        let urlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
        let data = try await httpClient.load(urlString: urlString)
        let items = try CoinbaseJsonDtoMapper.mapToPrice(jsonData: data)
        return items
    }
}
