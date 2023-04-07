//
//  EditorView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct AddonButton : Equatable, Hashable {
    static func == (lhs: AddonButton, rhs: AddonButton) -> Bool {
        return lhs.buttonName == rhs.buttonName
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(buttonName)
    }
    
    var buttonName: String
    var buttonImage: String
    var onClick : (String) -> String
}

struct EditorView: View {
    @State
    var markdownText: String
    
    @State
    var isButtonClicked: Bool = false
    
    var matexFile: MatexFile = MatexFile()
    
    let addOnButtonList: [AddonButton] = [ AddonButton(buttonName: "Bold", buttonImage: "bold", onClick: {text in text + "\n**  Bold Text Here  **"}),
                                           AddonButton(buttonName: "Italics", buttonImage: "italic", onClick: {text in text + "\n*  Italic Text Here  *"}),
                                           AddonButton(buttonName: "Strikethrough", buttonImage: "strikethrough", onClick: {text in text + "\n~~  Strikethrough Text Here  ~~"}),
                                           AddonButton(buttonName: "Heading+", buttonImage: "plus.square.fill", onClick: {text in text + ( text.last == "#" ? "#" : "\n#" ) }),
                                           AddonButton(buttonName: "Heading-", buttonImage: "minus.square.fill", onClick: {text in text.last == "#" ? String(text.dropLast()) : text }),
                                           AddonButton(buttonName: "Ordered List", buttonImage: "list.number", onClick: {text in text + "\n1. First Item\n2. Second Item\n3. Third Item"}),
                                           AddonButton(buttonName: "Unordered List", buttonImage: "list.bullet", onClick: {text in text + "\n- First Item\n- Second Item\n- Third Item"}),
                                           AddonButton(buttonName: "Line Break", buttonImage: "arrow.down.and.line.horizontal.and.arrow.up", onClick: {text in text + "\n---\n"}),
                                           AddonButton(buttonName: "Link", buttonImage: "link", onClick: {text in text + "\n[ text ]( url )"}),
                                           AddonButton(buttonName: "Image", buttonImage: "photo.fill", onClick: {text in text + "\n![ description ]( image_name )"}),
                                           AddonButton(buttonName: "Code Block", buttonImage: "curlybraces", onClick: {text in text + "\n```\nAdd Code Here\n```"}),
                                           AddonButton(buttonName: "Equations", buttonImage: "x.squareroot", onClick: {text in text + "\n$$\nAdd Equation Here\n$$"})]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            TextEditor(text: $markdownText)
                .font(.custom("Courier New", size: 13))
                .onChange(of: markdownText){newMarkDownText in
                    matexFile.content = newMarkDownText
                    PersistenceController.shared.save()
                }
            
            Button {
                isButtonClicked = true
            } label: {
                Label("Customize", systemImage: "slider.horizontal.3")
                    .padding(10)
            }
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
            .clipShape(Rectangle())
            .cornerRadius(10)
            .padding(20)
            .shadow(color: Color.black.opacity(0.2),radius: 5)
        }
        .popover(isPresented: $isButtonClicked){
            Spacer()
            
            Text("Style")
                .font(.custom("Roboto", size: 30, relativeTo: .headline).weight(.heavy))
            
            Text("Select Add-on")
                .font(.subheadline)
            
            Spacer()
            
            List{
                ForEach(addOnButtonList, id: \.self){addOnButton in
                    Button{
                        markdownText = addOnButton.onClick(markdownText)
                        isButtonClicked.toggle()
                    } label: {
                        Label(addOnButton.buttonName, systemImage: addOnButton.buttonImage)
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(markdownText: "A very large text that is supposed to span over multiple lines.")
    }
}
