import SwiftUI
import Combine

struct CurrencyTextField: View {
    @Binding var text: String
    var isEditable: Bool
    var borderColor: Color
    @ObservedObject var viewModel: CurrencyConverterViewModel
    
    var body: some View {
        TextField("0.00", text: $text)
            .frame(width: 130)
            .padding()
            .disabled(!isEditable)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
            .onChange(of: text) { newValue in
                    viewModel.formatAmount()
            }
    }
}
