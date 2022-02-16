// MARK: - Airport
public struct Airport: Codable, Equatable {
	public var stations: [Station] = []

	public init(stations: [Station] = []) {
		self.stations = stations
	}
}

extension Airport {
	static public var mock: Airport = .init(
		stations: [Station.mockRussia, Station.mockFinland]
	)
}

extension Station {
	static public var mockRussia: Station = .init(code: "LED", name: "St Petersburg", alternateName: nil, alias: ["st", "petersburg"], countryCode: "RU", countryName: "Russia", countryGroupCode: "1", countryGroupName: .nonEUEEA, timeZoneCode: "RU2", latitude: "594800N", longitude: "0301800E", mobileBoardingPass: true, markets: [])

	static public var mockFinland: Station = .init(code: "HEL", name: "Helsinki", alias: ["helsinki"], countryCode: "FI", countryName: "Finland", countryGroupCode: "1", countryGroupName: .euEea, timeZoneCode: "FI", latitude: "601932N", longitude: "0245818E", mobileBoardingPass: true, markets: [])
}

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
		return true
	}

	public var hashValue: Int {
		return 0
	}

	public func hash(into hasher: inout Hasher) {}

	public init() {}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if !container.decodeNil() {
			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}


//https://www.ryanair.com/gb/en/trip/flights/select?adults=1&teens=0&children=0&infants=0&dateOut=2022-02-26&dateIn=&isConnectedFlight=false&isReturn=false&discount=0&promoCode=&originIata=STN&destinationIata=LIS&tpAdults=1&tpTeens=0&tpChildren=0&tpInfants=0&tpStartDate=2022-02-26&tpEndDate=&tpDiscount=0&tpPromoCode=&tpOriginIata=STN&tpDestinationIata=LIS
