//
//  ContentView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var newFileDialog: Bool = false

    @State
    var newFilename: String = ""
    
    @Environment(\.managedObjectContext)
    var managedObjectContext
    
    @FetchRequest(entity: MatexFile.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \MatexFile.timestamp, ascending: false)])
    var matexFiles: FetchedResults<MatexFile>
    
    @State
    var needsLaunchScreen = true
    
    func removeFile(at offsets: IndexSet){
        for index in offsets{
            let fileToBeDeleted = matexFiles[index]
            PersistenceController.shared.delete(delete: fileToBeDeleted)
        }
    }
    
    var body: some View {
        
        if needsLaunchScreen {
            LottieView(name: "toucan") {
                needsLaunchScreen = false
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    needsLaunchScreen = false
                }
            }
        }
        else {
            NavigationStack{
                VStack {
                    List{
                        ForEach(matexFiles, id: \.self){matexFile in
                            NavigationLink(value: matexFile){
                                VStack(alignment: .leading){
                                    Text(matexFile.filename!)
                                        .font(.headline)
                                    Text(matexFile.content?.prefix(30) ?? "Empty!")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onDelete(perform: removeFile)
                    }
                    .navigationDestination(for: MatexFile.self){matexFile in
                        ProjectView(matexFile: matexFile)
                    }
                }
                .popover(isPresented: $newFileDialog) {
                    VStack(alignment: .center) {
                        
                        Spacer()
                        
                        Text("MaTeX")
                            .font(.custom("Roboto", size: 30, relativeTo: .headline).weight(.heavy))
                        
                        Text("Create A New File")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        TextField("Document Title", text: $newFilename)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            let newMatexFile = MatexFile(context: managedObjectContext)
                            newMatexFile.filename = newFilename
                            newMatexFile.timestamp = Date.now
                            newMatexFile.content = "Welcome to MaTeX!"
                            newMatexFile.fileid = UUID()
                            
                            let newConfig = MatexFileConfig(context: managedObjectContext)
                            newConfig.documentTitle = ""
                            newConfig.subtitle = ""
                            newConfig.author = ""
                            newConfig.creationDate = Date.now
                            newConfig.font = "DejaVu Serif"
                            newConfig.fontSize = 10
                            newConfig.verticalMargin = 25
                            newConfig.horizontalMargin = 20
                            newConfig.generateTableOfContent = false
                            newConfig.colorLinks = true
                            
                            let assistantChat = AssistantChat(context: managedObjectContext)
                            assistantChat.messages = ["Hello I am your personal AI Assistant, how can I help you?"]
                            
                            newMatexFile.toConfig = newConfig
                            newMatexFile.toChat = assistantChat
                            
                            PersistenceController.shared.save()
                            
                            newFileDialog.toggle()
                        } label: {
                            Label("Create", systemImage: "folder.badge.plus")
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("MaTeX")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem{
                        Button {
                            newFileDialog.toggle()
                        } label: {
                            Label("New File", systemImage: "plus")
                        }
                    }
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
