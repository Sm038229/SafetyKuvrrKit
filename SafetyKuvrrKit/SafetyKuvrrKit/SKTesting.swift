//
//  SKTesting.swift
//  SafetyKuvrrKit
//
//  Created by Sachchida Nand Mishra on 26/06/24.
//

import Foundation
import INTULocationManager

public struct SKTesting {
    private static var csrfToken: String?
    public static func logMessage() {
        print("Hello this is testing message...")
        sessionAPI()
    }
    
    private static func sessionAPI() {
        SKService.apiCall(with: "https://safety-red5.kuvrr.com/api/v1/session_init/", responseModel: SKCSRFToken.self) { response in
            guard let response = response else { return }
            SKTesting.csrfToken = response.token
            print("Success: \(response)")
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
        }
    }
    
    public static func call911() {
        let locationManager = INTULocationManager.sharedInstance()
        locationManager.requestLocation(withDesiredAccuracy: .city,
                                        timeout: 10.0,
                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            if (status == INTULocationStatus.success) {
                let myLocation = SKLocation(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, altitude: currentLocation?.altitude ?? 0.0, verticalAccuracy: currentLocation?.verticalAccuracy ?? 0.0, horizontalAccuracy: currentLocation?.horizontalAccuracy ?? 0.0)
                print("Current Location: \(myLocation)")
                
                if let params = myLocation.dictionary() {
                    print("Current Location: \(params)")
                    SKService.apiCall(with: "https://safety-red5.kuvrr.com/api/v1/incident/", method: .post, parameters: params, responseModel: SKCSRFToken.self) { response in
                        guard let response = response else { return }
                        print("Success: \(response)")
                    } failure: { error in
                        guard let error = error else { return }
                        print("Failure: \(error)")
                    }
                }
            }
            else if (status == INTULocationStatus.timedOut) {
                
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
            }
        }
    }
    
    public static func callEMS() {
        SKService.apiCall(with: "https://jsonplaceholder.typicode.com/todos/1", responseModel: SKDataResponse.self) { response in
            guard let response = response else { return }
            print("Success: \(response)")
        } failure: { error in
            guard let error = error else { return }
            print("Failure: \(error)")
        }
    }
}

struct SKDataResponse: Decodable {
    let completed: Bool
    let id: Int
    let userId: Int
    let title: String
}

struct SKCSRFToken: Decodable {
    let token: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "csrf_token"
        case message = "message"
    }
}

struct SKLocation: Codable, DictionaryEncodable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let verticalAccuracy: Double
    let horizontalAccuracy: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case verticalAccuracy
        case horizontalAccuracy
    }

//    init(latitude: Double, longitude: Double, altitude: Double, verticalAccuracy: Double, horizontalAccuracy: Double) {
//        self.latitude = latitude
//        self.longitude = longitude
//        self.altitude = altitude
//        self.verticalAccuracy = verticalAccuracy
//        self.horizontalAccuracy = horizontalAccuracy
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//        try container.encode(altitude, forKey: .altitude)
//        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
//        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        latitude = try container.decode(Double.self, forKey: .latitude)
//        longitude = try container.decode(Double.self, forKey: .longitude)
//        altitude = try container.decode(Double.self, forKey: .altitude)
//        verticalAccuracy = try container.decode(Double.self, forKey: .verticalAccuracy)
//        horizontalAccuracy = try container.decode(Double.self, forKey: .horizontalAccuracy)
//    }
}

protocol DictionaryEncodable: Encodable {}

extension DictionaryEncodable {
    func dictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                return nil
        }
        return dict
    }
}
