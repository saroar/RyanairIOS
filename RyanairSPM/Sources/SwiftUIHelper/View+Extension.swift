import SwiftUI

public struct RoundedCorner: Shape {
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners

	public init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
		self.radius = radius
		self.corners = corners
	}

	public func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}


extension View {
	public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape( RoundedCorner(radius: radius, corners: corners) )
	}
}

extension View {
  @ViewBuilder public func stackNavigationViewStyle() -> some View {
	if #available(iOS 15.0, *) {
	  self.navigationViewStyle(.stack)
	} else {
	  self.navigationViewStyle(StackNavigationViewStyle())
	}
  }
}
