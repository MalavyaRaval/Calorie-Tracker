import SwiftUI
import Firebase


struct ContentView: View {
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

                VStack {
                    Spacer()

                    // Use a custom button style with yoga-inspired design
                    NavigationLink("Login", destination: LoginView())
                        .buttonStyle(YogaButtonStyleLogin())
                        .contentShape(Rectangle())

                    Spacer()

                    NavigationLink("Sign Up", destination: SignupView())
                        .buttonStyle(YogaButtonStyleSignup())
                        .contentShape(Rectangle())

                    Spacer()
                }
                .padding(.horizontal, 40) // Add padding to the vertical stack for a more balanced layout
            }
            .navigationTitle("Namaste") // Use a yoga-themed greeting
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.mint) // Set the accent color to a refreshing mint hue
        }
    }
}


struct YogaButtonStyleLogin: ButtonStyle {
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
                Image(systemName: "figure.run")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.mint.opacity(0.6))
                    .clipShape(Circle())
                    .offset(x: -80, y: -20) // Position the symbol
            )
    }
}

struct YogaButtonStyleSignup: ButtonStyle {
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
                Image(systemName: "figure.wave")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.mint.opacity(0.6))
                    .clipShape(Circle())
                    .offset(x: -80, y: -20) // Position the symbol
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
