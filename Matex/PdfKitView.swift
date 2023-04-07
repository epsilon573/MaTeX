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

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct PdfKitView: View {
    var pdfUrl: String
    
    var body: some View {
        PDFKitRepresentedView(URL(string: pdfUrl)!)
    }
}

struct PdfKitView_Previews: PreviewProvider {
    static var previews: some View {
        PdfKitView(pdfUrl: "https://www.africau.edu/images/default/sample.pdf")
    }
}
