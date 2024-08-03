import SwiftUI

struct CurrencyPickerView: View {
    @ObservedObject var viewModel: CurrencyConverterViewModel
    @Binding var showCurrencyPicker: Bool
    @Binding var isSourceCurrency: Bool

    var body: some View {
        NavigationView {
            List(viewModel.getCurrencies(), id: \.code) { currency in
                Button(action: {
                    if isSourceCurrency {
                        viewModel.sourceCurrency = currency
                    } else {
                        viewModel.targetCurrency = currency
                    }
                    showCurrencyPicker = false
                    viewModel.convert()
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
}

struct CurrencyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPickerView(viewModel: CurrencyConverterViewModel(), showCurrencyPicker: .constant(false), isSourceCurrency: .constant(true))
    }
}
