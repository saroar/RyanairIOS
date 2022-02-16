import Foundation

public enum AirportsError: Error, Hashable, Equatable {
	case message(String)
}

extension AirportsError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case let .message(message):
			return message
		}
	}
}
