//
//  ContentView.swift
//  TabViewBadges
//
//  Created by Benjamin Lewis on 3/11/21.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      ZStack {
        Image("wallpaper")
          .resizable()
          .ignoresSafeArea()
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
      }
      .tabItem {
        Image(systemName: "paperplane")
        Text("Email")
      }
      .badge(
        Text("3")
          .foregroundColor(.white)
      )
      Text("Hello, world!")
        .tabItem {
          Image(systemName: "icloud.slash")
          Text("Other")
        }
      Text("Hello, world!")
        .tabItem {
          Image(systemName: "ellipsis.circle")
          Text("More")
        }
      Text("Hello, world!")
        .tabItem {
          Image(systemName: "text.bubble")
          Text("Chat")
        }
      Text("Hello, world!")
        .tabItem {
          Image(systemName: "gearshape")
          Text("Settings")
        }
        .badge("1 new")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
