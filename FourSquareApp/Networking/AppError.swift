//
//  AppError.swift
//  Weather App
//
//  Created by Michelle Cueva on 10/13/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

enum AppError: Error {
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case noInternetConnection
    case badURL
    case badStatusCode
    case noDataReceived
    case notAnImage
    case other(rawError: Error)
}
