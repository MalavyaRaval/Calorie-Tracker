import SwiftUI

struct HomeView: View {
    let foodItems = [
        ("French Fries", 365),
        ("Hamburgers", 354),
        ("Mashed Potatoes", 214),
        ("Grilled Cheese", 378),
        ("Steak and Baked Potatoes", 161),
        ("Cheese Burger", 303),
        ("Fried Chicken", 320),
        ("Hash Browns", 470),
        ("Steak and Fries", 365),
        ("Corn and Cob", 155)
    ]
    
    @State private var itemFrequencies: [Int] = Array(repeating: 0, count: 10)
    
    var consumedCalories: Int {
        var sum = 0
        for (index, frequency) in itemFrequencies.enumerated() {
            sum += frequency * foodItems[index].1
        }
        return sum
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Day’s Calorie Intake")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    ForEach(0..<foodItems.count) { index in
                        HStack {
                            Text("\(index + 1).")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(foodItems[index].0)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.trailing, 10)
                            
                            Spacer() // Align + and - buttons to the right
                            
                            Button(action: {
                                if self.itemFrequencies[index] > 0 {
                                    self.itemFrequencies[index] -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                            }
                            Text("\(self.itemFrequencies[index])")
                                .padding(.horizontal, 5)
                            Button(action: {
                                self.itemFrequencies[index] += 1
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("Total Calories: \(consumedCalories)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Spacer() // Add extra spacer to center the "Next" button
                    
                    NavigationLink(destination: Calories_Burnt(consumedCalories: consumedCalories)) {
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
            .navigationBarTitle("", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
