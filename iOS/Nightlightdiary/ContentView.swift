import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showSettings = false
    @State private var showPaywall = false

    @State private var newRating = 3
    @State private var newNote = ""
    @State private var newConditions: Set<String> = []

    private let conditionOptions = ["Blackout Curtains", "White Noise", "Cool Room", "Warm Room", "Nightlight On", "Fan Running", "Pets in Room", "Partner Snoring"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(entry.date, style: .date).font(Theme.headlineFont).foregroundStyle(Theme.primary)
                            Spacer()
                            Text("\(entry.rating)/5").font(Theme.headlineFont).foregroundStyle(Theme.accent)
                        }
                        if !entry.conditions.isEmpty {
                            Text(entry.conditions.joined(separator: ", ")).font(Theme.captionFont).foregroundStyle(Theme.secondary)
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }
                .onDelete(perform: store.delete)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Nightlight Diary")

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.isAtLimit && !purchases.isPro {
                            showPaywall = true
                        } else {
                            showAddSheet = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
            .sheet(isPresented: $showPaywall) { PaywallView() }

            .sheet(isPresented: $showAddSheet) {
                NavigationStack {
                    Form {
                        Stepper("Sleep Quality: \(newRating)", value: $newRating, in: 1...5)
                            .accessibilityIdentifier("ratingStepper")
                        Section("Conditions Present") {
                            ForEach(conditionOptions, id: \.self) { cond in
                                Toggle(cond, isOn: Binding(
                                    get: { newConditions.contains(cond) },
                                    set: { isOn in if isOn { newConditions.insert(cond) } else { newConditions.remove(cond) } }
                                ))
                            }
                        }
                        TextField("Note", text: $newNote)
                            .accessibilityIdentifier("noteField")
                    }
                    .navigationTitle("New Entry")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAddSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                store.add(Entry(date: Date(), rating: newRating, conditions: Array(newConditions), note: newNote))
                                newRating = 3; newNote = ""; newConditions = []
                                showAddSheet = false
                            }
                            .accessibilityIdentifier("saveEntryButton")
                        }
                    }
                    .background(
                        Color.clear.contentShape(Rectangle())
                            .onTapGesture { hideKeyboard() }
                    )
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
