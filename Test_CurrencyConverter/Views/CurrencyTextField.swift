import SwiftUI

struct CurrencyTextField: View {
    @Binding var text: String
    var isEditable: Bool
    var borderColor: Color
    
    var body: some View {
        TextField("0.00", text: $text)
            .keyboardType(.decimalPad)
            .frame(width: 130)
            .padding()
            .disabled(!isEditable)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}
