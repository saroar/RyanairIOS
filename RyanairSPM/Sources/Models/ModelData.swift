import Foundation

extension Departure {
	static public var departureFullMock: Departure = load("departureData.json")
}

func load<T: Decodable>(_ filename: String) -> T {
	let data: Data

//	Bundle.module.url(forResource: "config", withExtension: "json")
	guard let file = Bundle.module.url(forResource: filename, withExtension: nil)
		else {
			fatalError("Couldn't find \(filename) in main bundle.")
	}

	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}

	do {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
}
