import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = CurrencyConverterViewModel()
    @State private var showCurrencyPicker = false
    @State private var isSourceCurrency = true
    
    var body: some View {
        VStack {
            Text("Currency Converter")
                .font(.headline)
                .padding(.bottom, 10)
                .accessibilityLabel("Currency Converter")
                .accessibilityHint("This is the currency converter tool")
            
            VStack {
                HStack {
                    CurrencyTextField(text: $viewModel.amount, isEditable: true, borderColor: .blue)
                        .accessibilityLabel("Amount to convert")
                        .accessibilityHint("Enter the amount you wish to convert")
                    
                    CurrencyButton(currency: viewModel.sourceCurrency, action: {
                        isSourceCurrency = true
                        showCurrencyPicker.toggle()
                    }, hasArrow: true)
                    .accessibilityLabel("Source Currency")
                    .accessibilityHint("Select the currency you want to convert from")
                }
                .padding()
                
                HStack {
                    CurrencyTextField(text: $viewModel.convertedAmount, isEditable: false, borderColor: .gray)
                        .accessibilityLabel("Converted Amount")
                        .accessibilityHint("This is the converted amount")
                    
                    CurrencyButton(currency: Currency(code: "KES", name: "Kenyan Shilling", imgUrl: viewModel.kesFlagUrl), action: {}, hasArrow: false)
                        .accessibilityLabel("Target Currency")
                        .accessibilityHint("The target currency is Kenyan Shilling")
                }
                .padding()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .padding()
        .onAppear {
            viewModel.fetchExchangeRates()
        }
        .sheet(isPresented: $showCurrencyPicker) {
            CurrencyPickerView(viewModel: viewModel, showCurrencyPicker: $showCurrencyPicker, isSourceCurrency: $isSourceCurrency)
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Currency Picker")
                .accessibilityHint("Select a currency from the list")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
