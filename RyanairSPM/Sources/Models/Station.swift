import Foundation

// MARK: - Station
public struct Station: Codable, Equatable, Hashable, Identifiable {

	public let id =  UUID()
	public let code, name: String
	public let alternateName: String?
	public let alias: [String]
	public let countryCode, countryName: String
	public let countryAlias: String?
	public let countryGroupCode: String
	public let countryGroupName: CountryGroupName
	public let timeZoneCode, latitude, longitude: String
	public let mobileBoardingPass: Bool
	public let markets: [Market]
	public let notices: String?
	public let tripCardImageURL: String?
	public let airportShopping: Bool?

	public init(code: String, name: String, alternateName: String? = nil, alias: [String], countryCode: String, countryName: String, countryAlias: String? = nil, countryGroupCode: String, countryGroupName: CountryGroupName, timeZoneCode: String, latitude: String, longitude: String, mobileBoardingPass: Bool, markets: [Market], notices: String? = nil, tripCardImageURL: String? = nil, airportShopping: Bool? = nil) {
		self.code = code
		self.name = name
		self.alternateName = alternateName
		self.alias = alias
		self.countryCode = countryCode
		self.countryName = countryName
		self.countryAlias = countryAlias
		self.countryGroupCode = countryGroupCode
		self.countryGroupName = countryGroupName
		self.timeZoneCode = timeZoneCode
		self.latitude = latitude
		self.longitude = longitude
		self.mobileBoardingPass = mobileBoardingPass
		self.markets = markets
		self.notices = notices
		self.tripCardImageURL = tripCardImageURL
		self.airportShopping = airportShopping
	}

	public enum CodingKeys: String, CodingKey {
		case code, name, alternateName, alias, countryCode, countryName, countryAlias, countryGroupCode, countryGroupName, timeZoneCode, latitude, longitude, mobileBoardingPass, markets, notices
		case tripCardImageURL = "tripCardImageUrl"
		case airportShopping
	}
}

public enum CountryGroupName: String, Codable, Equatable, Hashable {
	case euEea = "EU/EEA"
	case nonEUEEA = "non EU/EEA"
}

extension Station {
	public func matches(_ searchString: String) -> Bool {
		searchString.isEmpty
		|| self.name.localizedCaseInsensitiveContains(searchString)
		|| self.countryName.localizedCaseInsensitiveContains(searchString)
		|| self.code.localizedCaseInsensitiveContains(searchString)
	}
}
