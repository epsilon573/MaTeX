//
//  PdfKitView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    @Binding
    var needRender: Bool
    
    init(pdfUrl url: URL,needRender renderBind: Binding<Bool>) {
        self.url = url
        _needRender = renderBind
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFView {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
        pdfView.document = PDFDocument(url: self.url)
    }
}

