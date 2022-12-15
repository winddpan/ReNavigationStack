//
//  ContentView.swift
//  NavigationStackDemo
//
//  Created by PAN on 2022/12/12.
//

import ReNavigationStack
import SwiftUI

struct Park: Identifiable, Hashable {
    var id: String {
        name
    }

    let name: String

    init(_ name: String) {
        self.name = name
    }
}

struct ParkDetails: View {
    let park: Park

    var body: some View {
        Text(park.name)
    }
}

struct NavigationStackDataPathView: View {
    @State private var presentedParks: [Park] = []
    @State private var parks: [Park] = [Park("Yosemite"), Park("Sequoia")]

    var body: some View {
        NavigationStack(path: $presentedParks) {
            VStack {
                List(parks) { park in
                    NavigationLink(park.name, value: park)
                }
            }
            .navigationDestination(for: Park.self) { park in
                ParkDetails(park: park)
                    .onTapGesture {
                        showParks()
                    }
                    .navigationTitle(park.name)
            }
            .navigationTitle("NavigationStack")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func showParks() {
        presentedParks = [Park("A"), Park("B")]
    }
}

struct ReNavigationStackDataPathView: View {
    @State private var presentedParks: [Park] = []
    @State private var parks: [Park] = [Park("Yosemite"), Park("Sequoia")]

    var body: some View {
        ReNavigationStack(path: $presentedParks) {
            VStack {
                List(parks) { park in
                    ReNavigationLink(park.name, value: park)
                }
            }
            .reNavigationDestination(for: Park.self) { park in
                ParkDetails(park: park)
                    .onTapGesture {
                        showParks()
//                        presentedParks.removeLast()
                    }
                    .navigationTitle(park.name)
            }
            .navigationTitle("ReNavigationStack")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func showParks() {
        presentedParks = presentedParks + [Park("\(Int.random(in: 1 ... 100))")]
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            ReNavigationStackDataPathView()
                .tabItem {
                    Text("ReNavigationStack")
                }
            NavigationStackDataPathView()
                .tabItem {
                    Text("NavigationStack")
                }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
