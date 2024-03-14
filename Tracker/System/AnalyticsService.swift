//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Сергей Денисенко on 13.03.2024.
//

import Foundation

import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "24f99147-b85e-4e1d-af9f-781f9b8491ac") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }

    static func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
