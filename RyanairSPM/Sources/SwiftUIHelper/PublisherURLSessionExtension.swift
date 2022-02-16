import Foundation
import Combine
import Models

public extension Publisher where Output == (data: Data, response: HTTPURLResponse), Failure == AirportsError {

	func assumeHTTP() -> AnyPublisher<(data: Data, response: HTTPURLResponse), AirportsError> {
		tryMap { (data: Data, response: URLResponse) in
			guard let http = response as? HTTPURLResponse else { throw AirportsError.message("Non-HTTP response received") }
			return (data, http)
		}
		.mapError { error in
			if error is AirportsError {
				return error as! AirportsError
			} else {
				return AirportsError.message("Network error \(error)")
			}
		}
		.eraseToAnyPublisher()
	}

}

public extension Publisher where Output == (data: Data, response: HTTPURLResponse), Failure == AirportsError {
	func responseData() -> AnyPublisher<Data, AirportsError> {
		tryMap { (data: Data, response: HTTPURLResponse) -> Data in
			switch response.statusCode {
			case 200...299: return data
			case 400...499: throw AirportsError.message("\(#line) error with status code: \(response.statusCode)")
			case 500...599: throw AirportsError.message("\(#line) error with status code: \(response.statusCode)")
			default:
				throw AirportsError.message("\(#line) error with status code: \(response.statusCode)")
			}
		}
		.mapError { $0 as! AirportsError }
		.eraseToAnyPublisher()
	}
}

public extension Publisher where Output == (data: Data, response: URLResponse) {

	func assumeHTTP() -> AnyPublisher<(data: Data, response: HTTPURLResponse), AirportsError> {
		tryMap { (data: Data, response: URLResponse) in
			guard let http = response as? HTTPURLResponse else { throw AirportsError.message("Non-HTTP response received") }
			return (data, http)
		}
		.mapError { error in
			if error is AirportsError {
				return error as! AirportsError
			} else {
				return AirportsError.message("Network error \(error)")
			}
		}
		.eraseToAnyPublisher()
	}

}


public extension Publisher where Output == Data, Failure == AirportsError {
	func decoding<D: Decodable, Decoder: TopLevelDecoder>(
		_ type: D.Type,
		decoder: Decoder
	) -> AnyPublisher<D, AirportsError> where Decoder.Input == Data {
		decode(type: D.self, decoder: decoder)
			.mapError { error in
				if error is DecodingError {
					return AirportsError.message("decodingError \(error as! DecodingError)")
				} else {
					return error as! AirportsError
				}

			}
			.eraseToAnyPublisher()
	}
}
