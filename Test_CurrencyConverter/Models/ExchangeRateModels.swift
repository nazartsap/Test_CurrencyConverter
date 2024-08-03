import Foundation

struct ExchangeRateResponse: Codable {
    let data: ExchangeRateData
    let status: String
    let statusCode: String
    let message: String
}

struct ExchangeRateData: Codable {
    let baseExchangeRate: BaseExchangeRate
    let exchangeRates: [ExchangeRate]
    let lastUpdate: String
    let country: Country
}
struct BaseExchangeRate: Codable {
    let currency: String?
    let currencyCode: String
    let buyRate: Double
    let sellRate: Double
    let imgUrl: String
    let reverseRate: Bool
    let decimalPlaces: String
}
struct ExchangeRate: Codable {
    let currency: String?
    let currencyCode: String
    let buyRate: Double
    let sellRate: Double
    let imgUrl: String
    let reverseRate: Bool
    let decimalPlaces: String
}

struct Country: Codable {
    let countryCode: String
    let name: String
    let imageURL: String
}

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
}

struct Currency {
    let code: String
    let name: String
    let imgUrl: String
}
