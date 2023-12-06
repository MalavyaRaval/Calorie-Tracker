import SwiftUI




struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isEmailValid: Bool = false
    @State private var resetPasswordSuccess = false
    @State private var resetPasswordError: IdentifiableError?
    @StateObject private var viewModel = ForgotPasswordViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: Color.black.opacity(0.7), location: 0.5),
                    .init(color: .clear, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Forgot Password?")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding(.bottom, 42)
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: email) { newEmail in
                            email = newEmail.lowercased()
                            validateEmail()
                        }
                }
                .padding(.horizontal, 20)
                
                Button("Forgot Password") {
                    // Perform signup action only if all required fields are filled and both email and phone number are valid
                    if isEmailValid {
                        viewModel.resetPassword(email: email)
                    } else {
                        // Set signup error message
                        resetPasswordError = IdentifiableError(message: generateErrorMessage())
                    }
                }
                
                
                .navigationTitle("Forgot Password")
                .alert(item: $resetPasswordError) { error in
                    Alert(
                        title: Text("Forgot Password"),
                        message: Text(error.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            NavigationLink(destination: LoginView(), isActive: $viewModel.resetPasswordSuccess) {
            }
            .hidden()
        }}

    private func validateEmail() {
        isEmailValid = isValidEmailFormat(email: email)
    }

    private func isValidEmailFormat(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func generateErrorMessage() -> String {
        // Generate error message based on missing fields
        var errorMessage = "Please fill out the following fields:\n"
        if email.isEmpty {
            errorMessage += "❌ Enter Valid Email\n"
        } else if !isEmailValid {
            errorMessage += "❌ Enter Valid Email\n"
        }
        return errorMessage
    }
}

class ForgotPasswordViewModel: ObservableObject {
    @Published var resetPasswordSuccess = false
    @Published var resetPasswordError: IdentifiableError?

    func resetPassword(email: String) {
        // Perform reset password action here (e.g., send a reset password email)
        print("Resetting password for email: \(email)")

        // Set reset password success to true to show the success alert
        resetPasswordSuccess = true
    }
}
