import SwiftUI

struct CurrencyButton: View {
    var currency: Currency?
    var action: () -> Void
    var hasArrow: Bool
    var body: some View {
        Button(action: action) {
            HStack {
                if let imgUrl = currency?.imgUrl, let url = URL(string: imgUrl) {
                    AsyncImage(url: url, scale: 1.7)
                        .frame(width: 24, height: 24)
                }
                Text(currency?.code ?? "Currency")
                if hasArrow{
                    Image(systemName: "chevron.down")
                    
                }
            }
        }
        .frame(width: 95)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

