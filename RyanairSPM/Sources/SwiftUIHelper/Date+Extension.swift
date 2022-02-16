// We can create one more Helper for foundation and move this code there but for now i think its ok here

import Foundation

extension Date {

	private func component(_ component: Calendar.Component) -> Int {
		return Calendar.current.component(component, from: self)
	}

	public var day: Int { return component(.day) }

	public var monthName: String {
	   let dateFormatter = DateFormatter()
	   dateFormatter.dateFormat = "MMMM"
	   return dateFormatter.string(from: self)
   }

	public var toString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter.string(from: self)
	}

}
