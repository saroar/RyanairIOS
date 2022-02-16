// MARK: - Stop
public struct Stop: Codable, Equatable, Hashable {
	let code: Code
}


public enum Code: String, Codable, Equatable {
	case bgy = "BGY"
	case crl = "CRL"
	case fco = "FCO"
	case opo = "OPO"
	case stn = "STN"
}

