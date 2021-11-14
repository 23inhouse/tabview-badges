//
//  ContentView.swift
//  TabViewBadges
//
//  Created by Benjamin Lewis on 3/11/21.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Image("wallpaper")
        .resizable()
        .ignoresSafeArea()
      CustomTabView {
        ScrollView {
          VStack {
            Text("Hello, world!")
              .padding(50)
            Text("Hello, world!")
              .padding(50)
            Text("Hello, world!")
              .padding(50)
            Text("Hello, world!")
              .padding(50)
            Text("Hello, world!")
              .padding(50)
          }
          .background(Color.secondary)
        }
        .customTabItem {
          Image(systemName: "paperplane")
          Text("Email")
        }
        Text("Other, world!")
          .customTabItem {
            Image(systemName: "icloud.slash")
            Text("Other")
          }
        Text("More, world!")
          .customTabItem {
            Image(systemName: "ellipsis.circle")
            Text("More")
          }
        Text("Chat, world!")
          .customTabItem {
            Image(systemName: "text.bubble")
            Text("Chat")
          }
        Text("Settings, world!")
          .customTabItem {
            Image(systemName: "gearshape")
            Text("Settings")
          }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
