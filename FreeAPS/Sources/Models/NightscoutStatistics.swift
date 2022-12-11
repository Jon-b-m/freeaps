import Foundation

struct NightscoutStatistics: JSON {
    let report: String = "statistics"
    let dailystats: Statistics?
}
