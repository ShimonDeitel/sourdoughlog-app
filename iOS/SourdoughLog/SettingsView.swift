import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingPaywall = false

    let categories = ["All", "Recent", "Favorites"]

    var body: some View {
        Form {
            Section("Filters") {
                ForEach(categories, id: \.self) { category in
                    Toggle(category, isOn: Binding(
                        get: { store.enabledCategories.contains(category) },
                        set: { isOn in
                            if isOn { store.enabledCategories.insert(category) }
                            else { store.enabledCategories.remove(category) }
                        }
                    ))
                    .accessibilityIdentifier("toggle.\(category)")
                }
            }

            Section("Sourdough Log Pro") {
                if purchases.isPro {
                    Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                        .foregroundStyle(Theme.accent)
                } else {
                    Button("Upgrade to Pro") { showingPaywall = true }
                        .accessibilityIdentifier("button.upgrade")
                }
                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .accessibilityIdentifier("button.restore")
            }

            Section("About") {
                Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/sourdoughlog-app/privacy.html")!)
                Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/sourdoughlog-app/terms.html")!)
                Text("Version 1.0")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }
}
