//
//  CustomTabView.swift
//  TabViewBadges
//
//  Created by Benjamin Lewis on 14/11/21.
//

import SwiftUI


struct CustomTabView<Content>: View where Content: View {
  @State private var currentIndex: Int = 0

  let content: () -> Content

  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  struct TabItem {
    let tag: Int
    let tab: AnyView
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        pagesInHStack(screenGeometry: geometry)
      }
      .overlayPreferenceValue(CustomTabItemPreferenceKey.self) { preferences in
        createTabBar(screenGeometry: geometry, tabItems: preferences.map { TabItem(tag: $0.tag, tab: $0.item) })
      }
    }
  }

  func getTabBarHeight(screenGeometry: GeometryProxy) -> CGFloat {
    // https://medium.com/@hacknicity/ipad-navigation-bar-and-toolbar-height-changes-in-ios-12-91c5766809f4
    // ipad 50
    // iphone && portrait 49
    // iphone && portrait && bottom safety 83
    // iphone && landscape 32
    // iphone && landscape && bottom safety 53
    if UIDevice.current.userInterfaceIdiom == .pad {
      return 50 + screenGeometry.safeAreaInsets.bottom
    } else if UIDevice.current.userInterfaceIdiom == .phone {
      return 32 + screenGeometry.safeAreaInsets.bottom
    }
    return 50
  }

  func pagesInHStack(screenGeometry: GeometryProxy) -> some View {
    let tabBarHeight = getTabBarHeight(screenGeometry: screenGeometry)
    let heightCut = tabBarHeight - screenGeometry.safeAreaInsets.bottom
    let spacing: CGFloat = 100 // so pages don't overlap (in case of leading and trailing safetyInset), arbitrary

    return HStack(spacing: spacing) {
      content()
        .frame(width: screenGeometry.size.width, height: screenGeometry.size.height - heightCut)
        .offset(y: -heightCut/2 - 0.1)
    }
    .frame(width: screenGeometry.size.width, height: screenGeometry.size.height, alignment: .leading)
    .offset(x: -CGFloat(self.currentIndex) * screenGeometry.size.width + -CGFloat(self.currentIndex) * spacing)
  }

  func createTabBar(screenGeometry: GeometryProxy, tabItems: [TabItem]) -> some View {
    let height = getTabBarHeight(screenGeometry: screenGeometry)

    return VStack {
      Spacer()
      HStack(spacing: screenGeometry.size.width / (CGFloat(tabItems.count + 1) + 0.5)) {
        Spacer()
        ForEach(0..<tabItems.count, id: \.self) { i in
          Group {
            Button(action: {
              self.currentIndex = i
            }) {
              tabItems[i].tab
            }.foregroundColor(self.currentIndex == i ? .blue : .gray)
          }
        }
        Spacer()
      }
      // move up from bottom safety inset
      .padding(.bottom, screenGeometry.safeAreaInsets.bottom > 0 ? screenGeometry.safeAreaInsets.bottom - 5 : 0 )
      .frame(width: screenGeometry.size.width, height: height)
      .background(
        self.getTabBarBackground(screenGeometry: screenGeometry)
      )
    }
    // move down to cover bottom of new iphones and ipads
    .offset(y: screenGeometry.safeAreaInsets.bottom)
  }

  func getTabBarBackground(screenGeometry: GeometryProxy) -> some View {
    return GeometryReader { tabBarGeometry in
      self.getBackgrounRectangle(tabBarGeometry: tabBarGeometry)
    }
  }

  func getBackgrounRectangle(tabBarGeometry: GeometryProxy) -> some View {
    return VStack {
      Rectangle()
        .fill(Color.white)
        .opacity(0.8)
      // border top
      // https://www.reddit.com/r/SwiftUI/comments/dehx9t/how_to_add_border_only_to_bottom/
        .padding(.top, 0.2)
        .background(Color.gray)

        .edgesIgnoringSafeArea([.leading, .trailing])
    }
  }
}

// MARK: - Tab Item Preference
struct CustomTabItemPreferenceData: Equatable {
  var tag: Int
  let item: AnyView
  let stringDescribing: String // to let preference know when the tab item is changed
  var badgeNumber: Int // to let preference know when the badgeNumber is changed

  static func == (lhs: CustomTabItemPreferenceData, rhs: CustomTabItemPreferenceData) -> Bool {
    lhs.tag == rhs.tag && lhs.stringDescribing == rhs.stringDescribing && lhs.badgeNumber == rhs.badgeNumber
  }
}

struct CustomTabItemPreferenceKey: PreferenceKey {
  typealias Value = [CustomTabItemPreferenceData]

  static var defaultValue: [CustomTabItemPreferenceData] = []

  static func reduce(value: inout [CustomTabItemPreferenceData], nextValue: () -> [CustomTabItemPreferenceData]) {
    value.append(contentsOf: nextValue())
  }
}

// TabItem
extension View {
  func customTabItem<Content>(@ViewBuilder content: @escaping () -> Content) -> some View where Content: View {
    self.preference(key: CustomTabItemPreferenceKey.self, value: [
      CustomTabItemPreferenceData(tag: 0, item: AnyView(content()), stringDescribing: String(describing: content()), badgeNumber: 0)
    ])
  }
}

// Tag
extension View {
  func customTag(_ tag: Int, badgeNumber: Int = 0) -> some View {
    self
      .transformPreference(CustomTabItemPreferenceKey.self) { (value: inout [CustomTabItemPreferenceData]) in

        guard value.count > 0 else { return }
        value[0].tag = tag
        value[0].badgeNumber = badgeNumber

      }
      .transformPreference(CustomTabItemPreferenceKey.self) { (value: inout [CustomTabItemPreferenceData]) -> Void in

        guard value.count > 0 else { return }
        value[0].tag = tag
        value[0].badgeNumber = badgeNumber
      }
      .tag(tag)
  }
}
