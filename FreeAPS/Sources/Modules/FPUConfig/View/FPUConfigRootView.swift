import SwiftUI
import Swinject

extension FPUConfig {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()

        private var conversionFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1

            return formatter
        }

        private var intFormater: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.allowsFloats = false
            return formatter
        }

        var body: some View {
            Form {
                Section(header: Text("Convert Fat and Protein")) {
                    Toggle("Enable", isOn: $state.useFPUconversion)
                }

                Section(header: Text("Conversion settings")) {
                    HStack {
                        Text("Maximum Duration In Hours")
                        Spacer()
                        DecimalTextField("8", value: $state.timeCap, formatter: intFormater)
                    }
                    HStack {
                        Text("Interval In Minutes:")
                        Spacer()
                        DecimalTextField("20", value: $state.minuteInterval, formatter: intFormater)
                    }
                    HStack {
                        Text("Adjustment factor:")
                        Spacer()
                        DecimalTextField("0.5", value: $state.individualAdjustmentFactor, formatter: conversionFormatter)
                    }
                }

                Section(
                    footer: Text(
                        "Allows fat and protein to be converted to future carb equivalents using a formula of kilocalories divided by 10.\n\nThis spreads the carb equivilants over a maximum duration setting that can be configured from 8-12 hours.\n\nInterval in minutes is how many minutes are between entries. The shorter the interval, the smoother the results, but it becomes harder to manually delete entries if you later want to remove them. 10, 15, 20, 30, or 60 are reasonable choices.\n\nAdjustment factor is how much effect the fat and protein has on the entries. 1.0 is full effect and 0.5 is half effect.\nNote that you may find that your normal carb ratio needs to increase to a larger number if you begin adding fat and protein entries. For this reason, it is best to start with a factor of about 0.5 to ease into it.\n\nDefault settings:\n\nTime Cap: 8 hours\nInterval: 20 min\nFactor: 0.5"
                    )
                )
                    {}
            }
            .onAppear(perform: configureView)
            .navigationBarTitle("Fat and Protein")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
