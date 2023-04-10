//
//  ProjectView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct ProjectView: View {
    
    @State
    var selectedIndex = 0
    
    var matexFile: MatexFile = MatexFile()
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            EditorView(markdownText: matexFile.content ?? "Empty", matexFile: matexFile)
                .tabItem{
                    Label("Editor", systemImage: "pencil.line")
                }
                .tag(0)
            
            PdfView(currMatexFile: matexFile)
                .tabItem{
                    Label("PDF", systemImage: "doc.text.fill")
                }
                .tag(1)
            
            ConfigView(currMatexFile: matexFile)
                .tabItem{
                    Label("Config", systemImage: "gearshape.fill")
                }
                .tag(2)
            
            AssistantView(currMatexFile: matexFile)
                .tabItem{
                    Label("Assistant", systemImage: "faceid")
                }
                .tag(3)
        }
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .navigationTitle(matexFile.filename!)
        .navigationBarTitleDisplayMode(.inline)
                
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
