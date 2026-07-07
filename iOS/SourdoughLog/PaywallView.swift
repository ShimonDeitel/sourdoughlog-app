import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(Theme.accent)

            Text("Sourdough Log Pro")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.ink)

            Text("Unlimited history and a bake-outcome photo journal")
                .font(Theme.bodyFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.ink.opacity(0.75))
                .padding(.horizontal)

            if let product = purchases.product {
                Text("\(product.displayPrice)/month")
                    .font(Theme.headlineFont)
                    .foregroundStyle(Theme.accentSecondary)
            }

            Button {
                Task { await purchases.purchase() }
            } label: {
                Text("Unlock Pro")
                    .font(Theme.headlineFont)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .accessibilityIdentifier("button.purchase")
            .padding(.horizontal)

            Button("Not Now") { dismiss() }
                .accessibilityIdentifier("button.dismissPaywall")
                .foregroundStyle(Theme.ink.opacity(0.6))
        }
        .padding()
        .background(Theme.background.ignoresSafeArea())
    }
}
