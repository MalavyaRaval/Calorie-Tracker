import SwiftUI
import Firebase

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}


struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isEmailValid = true
    @State private var isPhoneValid = true
    @State private var signupSuccess = false
    @State private var signupError: IdentifiableError?
    @StateObject private var viewModel = SignupViewModel()


    var body: some View {
        NavigationView {
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

            
            VStack(spacing: 16) {
                
                Section("New User") {
                    TextField("Full Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: name) { newName in
                            // Capitalize all words in the name
                            name = capitalizeAllWords(newName)
                        }
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: email) { newEmail in
                            email = newEmail.lowercased()
                            validateEmail()
                        }
                    if !isEmailValid {
                        Text("Invalid email format")
                            .foregroundColor(.red)
                    }
                    TextField("Phone Number", text: $phone)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: phone) { newPhone in
                            validatePhoneNumber()
                        }
                    if !isPhoneValid {
                        Text("Invalid phone number format")
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .foregroundColor(.red)
                    }
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                Spacer()
                
                NavigationLink(destination: LoginView(), isActive: $viewModel.signupSuccess) {
                    EmptyView()
                }
                .hidden()
                
                Button {
                    // Perform signup action only if all required fields are filled and both email and phone number are valid
                    if areAllFieldsFilled() && isEmailValid && isPhoneValid && passwordsMatch {
                        viewModel.performSignup(name: name, email: email, phone: phone, password: password, confirmPassword: confirmPassword)
                    } else {
                        // Set signup error message
                        signupError = IdentifiableError(message: generateErrorMessage())
                    }
                    let retrievedData = UserDefaults.standard.data(forKey: "currentUser")
                    if let retrievedUser = try? JSONDecoder().decode(User.self, from: retrievedData ?? Data()) {
                        print("User retrieved from UserDefaults: \(retrievedUser)")
                    } else {
                        print("No user data found in UserDefaults.")
                    }
                    
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(YogaButtonStyleSignin1())
                
                Spacer()
                    .navigationTitle("Sign Up")
                    .alert(item: $signupError) { error in
                        Alert(
                            title: Text("Signup Error"),
                            message: Text(error.message),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            }            .padding(.horizontal, 20)
            
        }
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

    private func isValidPhoneNumberFormat(phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }

    private func validatePhoneNumber() {
        isPhoneValid = isValidPhoneNumberFormat(phoneNumber: phone)
    }

    private func areAllFieldsFilled() -> Bool {
        return !name.isEmpty && !email.isEmpty && !phone.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    private var passwordsMatch: Bool {
            return password == confirmPassword
        }

    private func generateErrorMessage() -> String {
        var errorMessage = "Please fill out the following fields:\n"
        if name.isEmpty {
            errorMessage += "❌ Full Name\n"
        }
        if email.isEmpty || !isEmailValid {
            errorMessage += "❌ Valid Email Address\n"
        }
        if phone.isEmpty || !isPhoneValid {
            errorMessage += "❌ Valid Phone Number\n"
        }
        if password.isEmpty {
            errorMessage += "❌ Password\n"
        }
        if confirmPassword.isEmpty {
            errorMessage += "❌ Confirm Password\n"
        }
        if !passwordsMatch {
                    errorMessage += "❌ Passwords do not match\n"
        }
        return errorMessage
    }

}

class SignupViewModel: ObservableObject {
    @Published var signupSuccess = false
    @Published var signupError: IdentifiableError?

    func performSignup(name: String, email: String, phone: String, password: String, confirmPassword: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle Firebase signup error
                print("Firebase signup error: \(error.localizedDescription)")
                self.signupError = IdentifiableError(message: "Firebase signup error: \(error.localizedDescription)")
            } else {
                // Firebase signup success
                print("Firebase signup successful")

                // Save additional user data to Firestore
                let user = User(name: name, email: email, phone: phone, password: password)
                self.saveUserToFirestore(user)

                // Set signup success to true to show the success alert
                self.signupSuccess = true
            }
        }
    }

    private func saveUserToFirestore(_ user: User) {
        let db = Firestore.firestore()
        
        // Create a reference to the "users" collection and use the user's email as the document ID
        let userRef = db.collection("users").document(user.email)
        
        // Create a dictionary with user data
        let userData: [String: Any] = [
            "name": user.name,
            "email": user.email,
            "phone": user.phone,
            // Add any other fields you want to save
        ]
        
        // Set the data for the document
        userRef.setData(userData) { error in
            if let error = error {
                // Handle Firestore data saving error
                print("Error saving user data to Firestore: \(error.localizedDescription)")
            } else {
                // User data saved successfully
                print("User data saved to Firestore successfully")
            }
        }
    }

}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

struct YogaButtonStyleSignin1: ButtonStyle {
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
                Image(systemName: "figure.stand")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.mint.opacity(0.6))
                    .clipShape(Circle())
                    .offset(x: -80, y: -20) // Position the symbol
            )
    }
}

struct User: Codable {
    var name: String
    var email: String
    var phone: String
    var password: String
}

func capitalizeAllWords(_ input: String) -> String {
    let words = input.components(separatedBy: " ")
    let capitalizedWords = words.map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
    return capitalizedWords.joined(separator: " ")
}

