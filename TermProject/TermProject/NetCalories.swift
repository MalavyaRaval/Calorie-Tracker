import SwiftUI

struct NetCaloriesView: View {
    var consumedCalories: Int
    var burnedCalories: Int

    @State private var resultText = ""
    @State private var feedbackText = ""

    var body: some View {
        VStack {
            Text("Net Calories")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Consumed Calories: \(consumedCalories)")
                .padding()

            Text("Burned Calories: \(burnedCalories)")
                .padding()

            Button("Calculate Net Calories") {
                calculateNetCalories()
            }
            .padding()

            Text(resultText)
                .font(.headline)
                .padding()

            Text("Feedback")
                .font(.title3)
                .fontWeight(.bold)
                .padding()

            Text(feedbackText)
                .font(feedbackFontStyle())
                .foregroundColor(feedbackTextColor())
                .padding()

            Spacer()
        }
        .padding()
    }

    private func calculateNetCalories() {
        let netCalories = consumedCalories - burnedCalories

        if netCalories > 0 {
            resultText = "Your net calorie intake is \(netCalories) calories."
            provideFeedback(netCalories: netCalories)
        } else if netCalories < 0 {
            resultText = "You burned more calories than you took in by \(-netCalories) calories."
            provideFeedback(netCalories: netCalories)
        } else {
            resultText = "Your calorie intake equals the calories burned."
            feedbackText = ""
        }
    }

    private func provideFeedback(netCalories: Int) {
        if netCalories < 0 {
            feedbackText = "Good job, you're losing weight."
        } else if netCalories < 3000 {
            feedbackText = "You're gaining weight."
        } else {
            feedbackText = "Your net calorie intake for the day is greater than 3000, which is not good for health."
        }
    }

    private func feedbackFontStyle() -> Font {
        return Font.system(size: 16).italic()
    }

    private func feedbackTextColor() -> Color {
        return feedbackText.isEmpty ? .clear : netCaloriesColor()
    }

    private func netCaloriesColor() -> Color {
        return feedbackText.contains("not good") ? .red : .green
    }
}

struct NetCaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        NetCaloriesView(consumedCalories: 0, burnedCalories: 0)
    }
}
