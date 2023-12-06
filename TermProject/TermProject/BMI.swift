import SwiftUI

struct BMI: View {
    var consumedCalories: Int
    var burnedCalories: Int
    
    @State private var gender: String = ""
    @State private var heightUnit: String = ""
    @State private var feetValue: Double = 0.0
    @State private var inchesValue: Double = 0.0
    @State private var weightUnit: String = ""
    @State private var weightValue: Double = 0.0
    @State private var bmi: Double?
    @State private var bmiCategory: String = ""
    @State private var showBMI: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer().frame(height: 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("BMI Calculation")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    Section(header: Text("Gender")) {
                        Picker("Select Gender", selection: $gender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Height")) {
                        Picker("Select Height Unit", selection: $heightUnit) {
                            Text("Centimeters").tag("cm")
                            Text("Feet and Inches").tag("ft")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if heightUnit == "cm" {
                            TextField("Enter Height (cm)", value: $feetValue, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .padding()
                        } else {
                            HStack {
                                TextField("Feet", value: $feetValue, formatter: NumberFormatter())
                                    .keyboardType(.decimalPad)
                                    .padding()
                                
                                Text("ft")
                                
                                TextField("Inches", value: $inchesValue, formatter: NumberFormatter())
                                    .keyboardType(.decimalPad)
                                    .padding()
                                
                                Text("in")
                            }
                        }
                    }
                    
                    Section(header: Text("Weight")) {
                        Picker("Select Weight Unit", selection: $weightUnit) {
                            Text("Kilograms").tag("kg")
                            Text("Pounds").tag("lbs")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        TextField("Enter Weight", value: $weightValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .padding()
                    }
                    
                    Button("Calculate BMI") {
                        calculateBMI()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    if showBMI, let calculatedBMI = bmi {
                        VStack {
                            Text("Your BMI is \(String(format: "%.2f", calculatedBMI))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)
                            
                            Text("Category: \(bmiCategory)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding(.bottom, 20)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: NetCaloriesView(consumedCalories: consumedCalories, burnedCalories: burnedCalories)) {
                        Text("Next")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .isDetailLink(false)
                }
                .padding()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private func calculateBMI() {
        var heightInMeters: Double = 0.0
        
        if heightUnit == "cm" {
            heightInMeters = feetValue / 100.0
        } else {
            heightInMeters = (feetValue * 0.3048) + (inchesValue * 0.0254)
        }
        
        let weightInKg = weightUnit == "kg" ? weightValue : weightValue * 0.453592
        
        bmi = weightInKg / (heightInMeters * heightInMeters)
        
        if let calculatedBMI = bmi {
            if calculatedBMI < 18.5 {
                bmiCategory = "Underweight"
            } else if calculatedBMI < 25 {
                bmiCategory = "Normal weight"
            } else if calculatedBMI < 30 {
                bmiCategory = "Overweight"
            } else {
                bmiCategory = "Obesity"
            }
            
            showBMI = true
        }
    }
}
