import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {
    private var weather: Weather?
    override func setUp() {
        weather = Weather(city: "Bangalore")
    }
    
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let result: Result<WeatherData, Error> = try await weather!.getCurrentConditions()
        print(result)
    }

    override func tearDown(){
        weather = nil
    }
}
