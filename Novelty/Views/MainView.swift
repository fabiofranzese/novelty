//
//  ContentView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var manager: NoveltyManager
    
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(manager.todayNovelty?.id ?? "no")
            Text(NextNoveltyId)
            Text(Date(timeIntervalSince1970: NextNoveltyTime).description)
            Text(NextNoveltyTime.description)
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
