import Foundation
import Combine

class CurrencyConverterViewModel: ObservableObject {
    @Published var amount: String = "" {
        didSet {
            formatAmount()
        }
    }
    @Published var sourceCurrency: Currency?
    @Published var targetCurrency: Currency?
    @Published var convertedAmount: String = ""
    @Published var exchangeRates: [ExchangeRate] = []
    @Published var baseExchangeRate: BaseExchangeRate?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    let kesFlagUrl = "https://demo32.netteller.com.cy/netteller-war/resources/images/flags/KES.png"
    private var currencies: [Currency] = []
    private var exchangeRateService = ExchangeRateService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchExchangeRates()
    }
    
    func formatAmount() {
        let filteredAmount = amount.filter { "0123456789.".contains($0) }
        if filteredAmount != amount {
            amount = filteredAmount
            return
        }
        
        let decimalCount = amount.filter { $0 == "." }.count
        if decimalCount > 1 {
            amount = String(amount.dropLast())
            return
        }
        
        if let dotIndex = amount.firstIndex(of: ".") {
                let decimalPart = amount[dotIndex...]
                if decimalPart.count > 3 {
                    // Удаляем лишние знаки после запятой
                    let excessCount = decimalPart.count - 3
                    amount.removeLast(excessCount)
                    return
            }
        }
        convert()
    }
    func fetchExchangeRates() {
        isLoading = true
        exchangeRateService.fetchExchangeRates { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.exchangeRates = response.data.exchangeRates
                    self?.baseExchangeRate = response.data.baseExchangeRate
                    self?.setupCurrencies()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func setupCurrencies() {
        guard let baseRate = baseExchangeRate else { return }
        
        self.currencies = self.exchangeRates.map { exchangeRate in
            Currency(code: exchangeRate.currencyCode, name: exchangeRate.currency ?? "", imgUrl: exchangeRate.imgUrl)
        }
        self.sourceCurrency = self.currencies.first
        self.targetCurrency = Currency(code: baseRate.currencyCode, name: baseRate.currency ?? "", imgUrl: baseRate.imgUrl)
    }
    
    func convert() {
        guard let amount = Double(self.amount), let sourceCurrency = sourceCurrency else {
            self.convertedAmount = "0.00"
            return
        }
        
        guard let sourceRate = exchangeRates.first(where: { $0.currencyCode == sourceCurrency.code })?.buyRate else {
            self.convertedAmount = "0.00"
            return
        }
        
        let kesRate = exchangeRates.first(where: { $0.currencyCode == "KES" })?.buyRate ?? 1.0
        
        let converted = amount * sourceRate / kesRate
        self.convertedAmount = String(format: "%.2f", converted)
    }
    
    func getCurrencies() -> [Currency] {
        return currencies
    }
}
