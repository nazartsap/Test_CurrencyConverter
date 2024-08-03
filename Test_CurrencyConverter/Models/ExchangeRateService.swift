import Foundation
class ExchangeRateService {
    private let urlString = "https://demo32.netteller.com.cy/netteller-apis-war/apis/systemTools/exchangeRatesInfo"
    private let token = "eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiIxZGJmNWEzNC1mNGU3LTRhMGQtYjNkZS03NzU1OTU1YTM2N2MiLCJpc3MiOiJodHRwczovL2RlbW8zMi5uZXR0ZWxsZXIuY29tLmN5L25ldHRlbGxlci13YXIvTG9naW4ueGh0bWwiLCJzdWIiOiIiLCJhdWQiOiJlYmU2NmM5ZGI4Y2Y0NjIyODZmYTJlZjY5YjQ5MmU1OSIsImlhdCI6MTU1NDM4NDU5OSwiZXhwIjoxODY5NzQ0NTk5fQ.smdmZcySHKCN39Ddbind4hUUwHSM40Jetu7DIB-jlygyH8pEqqhUV60mKBViGpKz4rKRs-aZHTk9ZTP0YWrL7w"
    
    func fetchExchangeRates(completion: @escaping (Result<ExchangeRateResponse, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ebe66c9db8cf462286fa2ef69b492e59", forHTTPHeaderField: "x-client-id")
        request.addValue("da963011-7031-4f76-9fce-fd00f3197fdd", forHTTPHeaderField: "x-fapi-interaction-id")
        request.addValue("en", forHTTPHeaderField: "Language")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.unknown))
            }
        }.resume()
    }
}
