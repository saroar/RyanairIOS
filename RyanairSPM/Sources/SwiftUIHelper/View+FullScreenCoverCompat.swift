import SwiftUI

public struct FullScreenCoverCompat<CoverContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  let content: () -> CoverContent

  public func body(content: Content) -> some View {
    GeometryReader { geo in
      ZStack {
        // this color makes sure that its enclosing ZStack
        // (and the GeometryReader) fill the entire screen,
        // allowing to know its full height
        Color.clear
        content
        ZStack {
          // the color is here for the cover to fill
          // the entire screen regardless of its content
          Color.white
          self.content()
        }
        .offset(y: isPresented ? 0 : geo.size.height)
        // feel free to play around with the animation speeds!
        .animation(.spring())
      }
    }
  }
}

extension View {
  public func fullScreenCoverCompat<Content: View>(isPresented: Binding<Bool>,
                        content: @escaping () -> Content) -> some View {
    self.modifier(FullScreenCoverCompat(isPresented: isPresented,
                      content: content))
  }
}
