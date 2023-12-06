import SwiftUI
import Firebase




struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEmailValid: Bool = false
    @State private var loginSuccess = false
    @State private var showForgotPassword = false
    @State private var loginError: IdentifiableError?
    @StateObject private var viewModel = LoginViewModel()


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
                Text("Welcome Back")
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

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    // Perform login action only if all required fields are filled, email is valid, phone number is valid, and passwords match
                    if areAllFieldsFilled() && isEmailValid {
                        viewModel.performLogin()
                    } else {
                        // Set login error message
                        loginError = IdentifiableError(message: generateErrorMessage())
                    }
                }) {
                    Text("Sign In")
                }
                .buttonStyle(YogaButtonStyleSignin())
                .padding(.top, 20)

                NavigationLink(destination: HomeView(), isActive: $viewModel.loginSuccess) {
                    EmptyView()
                }
                .hidden()

                NavigationLink(destination: ForgotPasswordView(), isActive: $showForgotPassword) {
                    Text("Forgotten Password?")
                        .fontWeight(.thin)
                        .foregroundColor(Color.blue)
                        .underline()
                        .padding(.top, 16)
                }
                .padding(.top, 20) // Add top padding to adjust the spacing between the Sign In button and the Forgotten Password link
            }
            .navigationTitle("Login")
            .alert(item: $loginError) { error in
                Alert(
                    title: Text("Login Error"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }

            
            .padding(.top, 20) // Add top padding to adjust the spacing between the Sign In button and the Forgotten Password link

        }
        
    }
    private func isValidEmailFormat(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func validateEmail() {
        isEmailValid = isValidEmailFormat(email: email)
    }

    private func areAllFieldsFilled() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }


    private func generateErrorMessage() -> String {
        // Generate error message based on missing fields
        var errorMessage = "Please fill out the following fields:\n"
        if email.isEmpty {
            errorMessage += "❌ Email\n"
        }
        if password.isEmpty {
            errorMessage += "❌ Password\n"
        }
        if !isEmailValid {
            errorMessage += "❌ Valid Email Address\n"
        }
        return errorMessage
    }
}

class LoginViewModel: ObservableObject {
    @Published var loginSuccess = false
    @Published var loginError: IdentifiableError?

    func performLogin() {
        // Perform login action here
        print("Logging in...")

        // Set login success to true to show the success alert
        loginSuccess = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct YogaButtonStyleSignin: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(Color.mint.opacity(0.8))
            .clipShape(Capsule())
            .overlay(
                // Use the Hamsa hand symbol for a more yoga-related icon
                Image(systemName: "figure.walk")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.mint.opacity(0.6))
                    .clipShape(Circle())
                    .offset(x: -80, y: -20) // Position the symbol
            )
    }
}
