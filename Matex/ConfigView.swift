//
//  ConfigView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct ConfigView: View {
    @State
    var documentTitle: String = ""

    @State
    var subtitle: String = ""
    
    @State
    var author: String = ""
    
    @State
    var dateCreated: Date = Date.now
    
    var fonts = ["DejaVu Sans",
                 "DejaVu Sans Mono",
                 "DejaVu Serif"]
    
    @State
    var pickedFont: String = "DejaVu Sans"
    
    @State
    var fontSize: Float = 8
    
    @State
    var horizontalMargin: Float = 20

    @State
    var verticalMargin: Float = 20
    
    @State
    var generateTableOfContents: Bool = false
    
    @State
    var colorLinks: Bool = false
    
    var matexFile: MatexFile?
    
    func SaveConfigSettings() -> Void {
        matexFile!.toConfig!.documentTitle! = documentTitle
        matexFile!.toConfig!.subtitle! = subtitle
        matexFile!.toConfig!.author! = author
        matexFile!.toConfig!.creationDate = dateCreated
        matexFile!.toConfig!.font! = pickedFont
        matexFile!.toConfig!.fontSize = fontSize
        matexFile!.toConfig!.verticalMargin = verticalMargin
        matexFile!.toConfig!.horizontalMargin = horizontalMargin
        matexFile!.toConfig!.generateTableOfContent = generateTableOfContents
        matexFile!.toConfig!.colorLinks = colorLinks

        PersistenceController.shared.save()
    }
    
    init(currMatexFile: MatexFile){
        matexFile = currMatexFile
        _documentTitle = State(initialValue: currMatexFile.toConfig!.documentTitle!)
        _subtitle = State(initialValue: currMatexFile.toConfig!.subtitle!)
        _author = State(initialValue: currMatexFile.toConfig!.author!)
        _dateCreated = State(initialValue: currMatexFile.toConfig!.creationDate!)
        _pickedFont = State(initialValue: currMatexFile.toConfig!.font!)
        _fontSize = State(initialValue: currMatexFile.toConfig!.fontSize)
        _verticalMargin = State(initialValue: currMatexFile.toConfig!.verticalMargin)
        _horizontalMargin = State(initialValue: currMatexFile.toConfig!.horizontalMargin)
        _generateTableOfContents = State(initialValue: currMatexFile.toConfig!.generateTableOfContent)
        _colorLinks = State(initialValue: currMatexFile.toConfig!.colorLinks)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Form{
                Section("Metadata") {
                    TextField("Document Title", text: $documentTitle)
                    TextField("Subitle", text: $subtitle)
                    TextField("Author", text: $author)
                    
                    DatePicker(selection: $dateCreated, in: ...Date.now, displayedComponents: .date) {
                        Text("Creation Date")
                    }
                }
                
                Section("Font Settings"){
                    Picker("Font", selection: $pickedFont){
                        ForEach(fonts, id: \.self){font in
                            Text(font)
                        }
                    }
                    
                    LabeledContent("Font Size"){
                        VStack{
                            Slider(value: $fontSize, in: 8...20, step: 1)
                            
                            HStack{
                                Spacer()
                                Text("\(Int(fontSize)) pt")
                                Spacer()
                            }
                        }
                    }
                }
                
                Section("Margins"){
                    LabeledContent("Vertical"){
                        VStack{
                            Slider(value: $verticalMargin, in: 0...130, step: 1)
                            
                            HStack{
                                Spacer()
                                Text("\(Int(verticalMargin)) mm")
                                Spacer()
                            }
                        }
                    }
                    
                    LabeledContent("Horizontal"){
                        VStack{
                            Slider(value: $horizontalMargin, in: 0...100, step: 1)
                            
                            HStack{
                                Spacer()
                                Text("\(Int(horizontalMargin)) mm")
                                Spacer()
                            }
                        }
                    }
                }
                
                Section("Miscellaneous"){
                    Toggle("Generate Table of Content", isOn: $generateTableOfContents)
                    Toggle("Color Links", isOn: $colorLinks)
                }
            }
            
            Button {
                SaveConfigSettings()
            } label: {
                Label("Save", systemImage: "pencil.slash")
                    .padding(10)
            }
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
            .clipShape(Rectangle())
            .cornerRadius(10)
            .padding(20)
            .shadow(color: Color.black.opacity(0.2),radius: 5)
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(currMatexFile: MatexFile())
    }
}
