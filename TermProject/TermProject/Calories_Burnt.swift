import SwiftUI

struct Calories_Burnt: View {
    let activities = [
        ("Running/Jogging", 700),
        ("Cycling", 300),
        ("Swimming", 272),
        ("Jump Rope", 1074),
        ("High-Intensity Interval Training", 1000),
        ("Rowing", 575),
        ("Dancing", 250),
        ("Strength Training", 250),
        ("Hiking", 400),
        ("Group Fitness Classes", 500)
    ]
    
    @State private var activityDurations: [Int] = Array(repeating: 0, count: 10)
    var consumedCalories: Int
    var burnedCalories: Int {
        var sum = 0
        for (index, duration) in activityDurations.enumerated() {
            sum += (duration * activities[index].1) / 60 // Calculate calories based on duration in minutes
        }
        return sum
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Day's Calories Burnt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                ForEach(0..<activities.count) { index in
                    HStack {
                        Text("\(index + 1).")
                            .font(.headline)
                            .fontWeight(.bold)

                        Text("\(self.activities[index].0)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.trailing, 10)

                        Spacer() // Align + and - buttons to the right

                        Button(action: {
                            if self.activityDurations[index] > 0 {
                                self.activityDurations[index] -= 10
                            }
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                        }

                        Text("\(self.activityDurations[index]) min")
                            .padding(.horizontal, 5)

                        Button(action: {
                            self.activityDurations[index] += 10
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                        }
                    }
                }

                Spacer()

                Text("Total Calories Burnt: \(burnedCalories)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.top, 20)

                Spacer()

                Spacer() // Add extra spacer to center the "Next" button

                NavigationLink(destination: BMI(consumedCalories: consumedCalories, burnedCalories: burnedCalories)) {
                    Text("Next")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
