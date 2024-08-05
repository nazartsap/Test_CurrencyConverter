import SwiftUI

struct CurrencyPickerView: View {
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @Binding var showCurrencyPicker: Bool
    @Binding var isSourceCurrency: Bool

    var body: some View {
        NavigationView {
            List(viewModel.getCurrencies(), id: \.code) { currency in
                Button(action: {
                    selectCurrency(currency: currency)
                }) {
                    HStack {
                        if let url = URL(string: currency.imgUrl) {
                            AsyncImage(url: url, scale: 1.7)
                                .frame(width: 24, height: 24)
                                .accessibilityLabel("\(currency.name) flag")
                        }
                        Text(currency.name)
                            .accessibilityLabel(currency.name)
                            .accessibilityHint("Select this currency")
                    }
                }
            }
            .navigationTitle("Select Currency")
            .navigationBarItems(trailing: Button("Done") {
                showCurrencyPicker = false
            }
            .accessibilityLabel("Close currency picker")
            .accessibilityHint("Tap to close the currency picker"))
        }
    }

    private func selectCurrency(currency: Currency) {
        Task {
            if isSourceCurrency {
                await MainActor.run {
                    viewModel.sourceCurrency = currency
                }
            } else {
                await MainActor.run {
                    viewModel.targetCurrency = currency
                }
            }
            await MainActor.run {
                showCurrencyPicker = false
                viewModel.convert()
            }
        }
    }
}

struct CurrencyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPickerView(viewModel: CurrencyConverterViewModel(), showCurrencyPicker: .constant(false), isSourceCurrency: .constant(true))
    }
}
