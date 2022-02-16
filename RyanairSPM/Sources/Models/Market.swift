import Foundation

// MARK: - Market
public struct Market: Codable, Equatable, Hashable {
	let code: String
	let group: Group?
	let stops: [Stop]?
	let onlyConnecting, pendingApproval, onlyPrintedBoardingPass: Bool?
}

public enum Group: String, Codable, Equatable, Hashable {
	case canary = "CANARY"
	case canaryGold = "CANARY_GOLD"
	case city = "CITY"
	case cityGold = "CITY_GOLD"
	case domestic = "DOMESTIC"
	case domesticGold = "DOMESTIC_GOLD"
	case ethnic = "ETHNIC"
	case leisure = "LEISURE"
	case leisureGold = "LEISURE_GOLD"
	case ukp = "UKP"
	case ukpGold = "UKP_GOLD"
}
