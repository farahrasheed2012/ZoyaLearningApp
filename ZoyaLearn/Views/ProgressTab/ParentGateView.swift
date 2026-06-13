//
//  ParentGateView.swift
//  ZoyaLearn
//

import SwiftUI
import LocalAuthentication

struct ParentGateView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isUnlocked: Bool
    @State private var passcode = ""
    @State private var errorMessage: String?
    private let fallbackPIN = "1234"

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Parents only")
                    .font(.title2.bold())
                Text("Use Face ID, Touch ID, or enter PIN")
                    .foregroundStyle(.secondary)

                SecureField("PIN", text: $passcode)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 240)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                Button("Unlock") {
                    if passcode == fallbackPIN {
                        unlock()
                    } else {
                        errorMessage = "Incorrect PIN"
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Use biometrics") {
                    authenticate()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("Parent Gate")
            .inlineNavTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear { authenticate() }
        }
    }

    private func authenticate() {
        let context = LAContext()
        var err: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) else {
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock parent dashboard") { success, _ in
            Task { @MainActor in
                if success { unlock() }
            }
        }
    }

    private func unlock() {
        isUnlocked = true
        dismiss()
    }
}
