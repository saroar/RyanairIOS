import Foundation

public struct QueryParams: Equatable, Hashable {


	public var origin: String
	public var destination: String
	public var dateout: String
	public var datein: String?
	public var flexdaysbeforeout: Int = 3
	public var flexdayout: Int = 3
	public var flexdaysbeforein: Int = 3
	public var flexdaysin: Int = 3
	public var adt: Int = 1
	public var teen: Int = 0
	public var chd: Int = 0
	public var roundtrip: Bool = false
	public var ToUs: String = "AGREED" // AGREED
	public var Disc: Int = 0

	public init(origin: String, destination: String, dateout: String, datein: String? = nil, flexdaysbeforeout: Int = 3, flexdayout: Int = 3, flexdaysbeforein: Int = 3, flexdaysin: Int = 3, adt: Int = 1, teen: Int = 0, chd: Int = 0, roundtrip: Bool = false, ToUs: String = "AGREED", Disc: Int = 0) {
		self.origin = origin
		self.destination = destination
		self.dateout = dateout
		self.datein = datein
		self.flexdaysbeforeout = flexdaysbeforeout
		self.flexdayout = flexdayout
		self.flexdaysbeforein = flexdaysbeforein
		self.flexdaysin = flexdaysin
		self.adt = adt
		self.teen = teen
		self.chd = chd
		self.roundtrip = roundtrip
		self.ToUs = ToUs
		self.Disc = Disc
	}

}

extension QueryParams {
	public var isValid: Bool {
		guard self.origin.isEmpty || self.destination.isEmpty || self.dateout.isEmpty else {
			return true
		}

		return false
	}
}

extension QueryParams {
	public func buildQueryItems(_ urlComponents: URLComponents) -> [URLQueryItem]? {

		var queryItems = urlComponents.queryItems

		queryItems = [

			URLQueryItem(name: "origin", value: self.origin),
			URLQueryItem(name: "destination", value: self.destination),
			URLQueryItem(name: "dateout", value: self.dateout),

			URLQueryItem(name: "flexdaysbeforeout", value: "\(self.flexdaysbeforeout)"),
			URLQueryItem(name: "flexdayout", value: "\(self.flexdayout)"),
			URLQueryItem(name: "flexdaysbeforein", value: "\(self.flexdaysbeforein)"),

			URLQueryItem(name: "flexdaysin", value: "\(self.flexdaysin)"),
			URLQueryItem(name: "adt", value: "\(self.adt)"),
			URLQueryItem(name: "teen", value: "\(self.teen)"),

			URLQueryItem(name: "chd", value: "\(self.chd)"),
			URLQueryItem(name: "roundtrip", value: "\(self.roundtrip)"),
			URLQueryItem(name: "ToUs", value: self.ToUs),

			URLQueryItem(name: "Disc", value: "\(self.Disc)"),

		]

		return queryItems
	}
}

extension QueryParams {
	static public var mockSTNtoLIS: QueryParams = .init(origin: "STN", destination: "LIS", dateout: "2022-03-28")
}
