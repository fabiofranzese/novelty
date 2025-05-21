//
//  ContentView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var manager: NoveltyManager
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(manager.allNovelties.first?.title ?? "No")
        }
        .padding()
    }
}

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        let previewManager = NoveltyManager()
        return MainView()
            .environmentObject(previewManager)
    }
}
