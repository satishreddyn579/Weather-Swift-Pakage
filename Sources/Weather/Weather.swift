import Foundation
import SwiftyJSON
import XCTest

public class Weather {
    public var weatherData: WeatherData?
    private var city: String
    private let baseURL = URL(string: "https://www.metaweather.com/api/location/")
    private let dispatchGroup = DispatchGroup()
    
    public init(city: String) {
        self.city = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city.lowercased()
    }
    
    internal func fetchJSON(path: String) async throws -> Result<Data, Error> {
        enum fetchJSONError: Error {
            case invalidURL
            case missingData
        }
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return .failure(fetchJSONError.invalidURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let data = data as? Data else {
            return .failure(fetchJSONError.missingData)
        }
        return .success(data)
    }
    
    internal func getLocationId() async throws -> Int? {
        do {
            let result: Result<Data, Error> = try await fetchJSON(path: "search/?query=\(self.city)")
            switch result {
            case .success(let data):
                let cityDetails = try? JSONDecoder().decode(CityDetails.self, from: data)
                return cityDetails?.first?.woeid
            case .failure(_):
                return nil
            }
        }
    }
    
    public func getCurrentConditions() async throws -> Result<WeatherData, Error> {
        let locationId = try await getLocationId()
        let result: Result<Data, Error> = try await fetchJSON(path: "\(locationId ?? 0)")
        switch result {
        case .success(let data):
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                return .success((self.weatherData)!)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    internal func convertCelToFar(celsiusTemp: Double) -> Int {
        return Int((celsiusTemp * 9/5)) + 32
    }
}
