//
//  ISNetworkBase.swift
//  iOSAssignement
//
//  Created by Иван on 10/6/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import Foundation

class ISNetworkBase: NSObject {
    class func get(scheme: String = "https", host: String, path: String, bodyParams: [URLQueryItem]!, headerParams: Dictionary<String, String>!, success: @escaping (Data) -> Void, failure: @escaping (String) -> Void) {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = bodyParams
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let headerParameters = headerParams {
            for (key, value) in headerParameters {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let unwrappedData = data {
                success(unwrappedData)
            } else if let unwrappedError = error {
                failure(unwrappedError.localizedDescription)
            } else {
                failure("unknown_error".localized())
            }
        }
        
        if Reachability.isConnectedToNetwork() {
            task.resume()
        } else {
            failure("no_internet_connection".localized())
        }
    }
}
