import Foundation

// MARK: - Flights
public struct Departure: Codable, Equatable, Hashable {

	public var termsOfUse: String
	public var currency: String
	public var currPrecision: Int
	public var routeGroup, tripType, upgradeType: String
	public var trips: [Trip]
	public var serverTimeUTC: String

	public init(termsOfUse: String, currency: String, currPrecision: Int, routeGroup: String, tripType: String, upgradeType: String, trips: [Trip], serverTimeUTC: String) {
		self.termsOfUse = termsOfUse
		self.currency = currency
		self.currPrecision = currPrecision
		self.routeGroup = routeGroup
		self.tripType = tripType
		self.upgradeType = upgradeType
		self.trips = trips
		self.serverTimeUTC = serverTimeUTC
	}
}

extension Departure {
	static public let mock: Departure = .init(termsOfUse: "AGREE", currency: "GBP", currPrecision: 2, routeGroup: "CITY", tripType: "CITY_BREAK", upgradeType: "PLUS", trips: [Trip.mock], serverTimeUTC: "2022-02-14T12:37:21.652Z")
}

// MARK: - Trip
public struct Trip: Codable, Equatable, Hashable, Identifiable {

	public var id: UUID? = UUID()
	public var origin: String
	public var originName: String
	public var destination: String
	public var destinationName, routeGroup, tripType, upgradeType: String
	public var dates: [DateElement]

	public init(origin: String, originName: String, destination: String, destinationName: String, routeGroup: String, tripType: String, upgradeType: String, dates: [DateElement]) {
		self.origin = origin
		self.originName = originName
		self.destination = destination
		self.destinationName = destinationName
		self.routeGroup = routeGroup
		self.tripType = tripType
		self.upgradeType = upgradeType
		self.dates = dates
	}
}


extension Trip {
	static public let mock: Trip = .init(origin: "STN", originName: "London (Stansted)", destination: "LIS", destinationName: "Lisbon ", routeGroup: "CITY", tripType: "CITY_BREAK", upgradeType: "PLUS", dates: [DateElement.mock])
}

// MARK: - DateElement
public struct DateElement: Codable, Equatable, Hashable, Identifiable {

	public var id: UUID? = UUID()
	public let dateOut: String
	public var flights: [Flight] = []

	public init(dateOut: String, flights: [Flight] = []) {
		self.dateOut = dateOut
		self.flights = flights
	}
}


extension DateElement {
	static public let mock: DateElement = .init(dateOut: "2022-02-10T00:00:00.000", flights: [])
}

// MARK: - Flight
public struct Flight: Codable, Equatable, Hashable, Identifiable {

	public var id: UUID? = UUID()
	public let faresLeft: Int
	public let flightKey: String
	public let infantsLeft: Int
	public let regularFare: RegularFare?
	public let operatedBy: String
	public let segments: [Segment]
	public let flightNumber: String
	public let time, timeUTC: [String]
	public let duration: String

	public init(faresLeft: Int, flightKey: String, infantsLeft: Int, regularFare: RegularFare?, operatedBy: String, segments: [Segment], flightNumber: String, time: [String], timeUTC: [String], duration: String) {
		self.faresLeft = faresLeft
		self.flightKey = flightKey
		self.infantsLeft = infantsLeft
		self.regularFare = regularFare
		self.operatedBy = operatedBy
		self.segments = segments
		self.flightNumber = flightNumber
		self.time = time
		self.timeUTC = timeUTC
		self.duration = duration
	}

}

// MARK: - RegularFare
public struct RegularFare: Codable, Equatable, Hashable {
	public let fareKey, fareClass: String
	public let fares: [Fare]
}

// MARK: - Fare
public struct Fare: Codable, Equatable, Hashable {

	public let type: String
	public let amount: Double
	public let count: Int
	public let hasDiscount: Bool
	public let publishedFare: Double
	public let discountInPercent: Int
	public let hasPromoDiscount: Bool
	public let discountAmount: Int
	public let hasBogof: Bool

	public init(type: String, amount: Double, count: Int, hasDiscount: Bool, publishedFare: Double, discountInPercent: Int, hasPromoDiscount: Bool, discountAmount: Int, hasBogof: Bool) {
		self.type = type
		self.amount = amount
		self.count = count
		self.hasDiscount = hasDiscount
		self.publishedFare = publishedFare
		self.discountInPercent = discountInPercent
		self.hasPromoDiscount = hasPromoDiscount
		self.discountAmount = discountAmount
		self.hasBogof = hasBogof
	}
}

public struct Passenger: Hashable {
	public init(passenger: Passengers = .adt, subTitle: String = "16+ years", count: Int = 1) {
		self.passenger = passenger
		self.subTitle = subTitle
		self.count = count
	}

	public var passenger: Passengers = .adt
	public var subTitle: String = "16+ years"
	public var count: Int = 1
}

extension Passenger {
	static public var passengers: [Passenger] = [
		.init(),
		.init(passenger: .teen, subTitle: "12-15 years", count: 0),
		.init(passenger: .chd, subTitle: "2-11 years", count: 0)
	]
}

extension Passenger: CustomStringConvertible {
	public var description: String {
		return "\(self.count) \(self.passenger.rawValue.capitalized)"
	}
}

public enum Passengers: String, Codable, Equatable, Hashable  {
	case adt = "Adults"
	case teen = "Teen"
	case chd = "Children"
}

// MARK: - Segment
public struct Segment: Codable, Equatable, Hashable {

	public let segmentNr: Int
	public let origin: String
	public let destination: String
	public let flightNumber: String
	public let time, timeUTC: [String]
	public let duration: String

	public init(segmentNr: Int, origin: String, destination: String, flightNumber: String, time: [String], timeUTC: [String], duration: String) {
		self.segmentNr = segmentNr
		self.origin = origin
		self.destination = destination
		self.flightNumber = flightNumber
		self.time = time
		self.timeUTC = timeUTC
		self.duration = duration
	}
}

public enum OD: String {
	case origin
	case destination
}
