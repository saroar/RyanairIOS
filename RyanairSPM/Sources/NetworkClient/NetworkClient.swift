import Foundation
import Models

public typealias APIKey = String

public enum Constants {
	public static let scheme = "https"
	public static let host = "sit-nativeapps.ryanair.com"
	public static let version = "/api/v4"
}

//https://mobile-testassets-dev.s3.eu-west-1.amazonaws.com/stations.json

//https://sit-nativeapps.ryanair.com/api/v4/Availability?origin=DUB&destination=STN&dateout=2020-08-09&datein=&flexdaysbeforeout=3&flexdaysout=3&flexdaysbeforein=3&flexdaysin=3&adt=1&teen=0&chd=0&roundtrip=false&ToUs=AGREED&Disc=0

public enum Method: String {
	case GET
}

public final class NetworkClient {
	public static let shared = NetworkClient()

	public init() {}

	private func makeComponents() -> URLComponents {
		var components = URLComponents()
		components.scheme = Constants.scheme
		components.host = Constants.host
		components.path = Constants.version

		return components
	}

	public func makeAirpotStationsRequest(httpMethod: Method = .GET) -> URLRequest? {

		guard let url = URL(string: "https://mobile-testassets-dev.s3.eu-west-1.amazonaws.com/stations.json") else {
			return nil
		}

		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		return request

	}


	public func makeTicketAvailabilityRequest(
		endPoint: Endpoint = .searchTicket,
		httpMethod: Method = .GET,
		query params: QueryParams
	) -> URLRequest? {

		var components = URLComponents()
		components.scheme = Constants.scheme
		components.host = Constants.host
		components.path = Constants.version

		components.queryItems = params.buildQueryItems(components)
		guard var url = components.url else { return nil }

		url.appendPathComponent(endPoint.rawValue)

		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue

		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("ios", forHTTPHeaderField: "client")

		return request

	}
}

public enum Endpoint: String {
	case searchTicket = "Availability"
}
