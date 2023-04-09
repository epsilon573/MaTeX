//
//  PdfView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct PdfView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PdfKitView(pdfUrl: "https://www.africau.edu/images/default/sample.pdf")
            HStack{
                Button {
                    //                Start Download
                    //                isButtonClicked = true
                } label: {
                    Label("Download", systemImage: "square.and.arrow.down")
                        .padding(10)
                }
                .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                .clipShape(Rectangle())
                .cornerRadius(10)
                .padding(20)
                .shadow(color: Color.black.opacity(0.2),radius: 5)
                
                Spacer()
                
                Button {
                    //                Start Download
                    //                isButtonClicked = true
                } label: {
                    Label("Render", systemImage: "highlighter")
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
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView()
    }
}
