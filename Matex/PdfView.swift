//
//  PdfView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct PdfView: View {
    var body: some View {
        VStack{
            PdfKitView(pdfUrl: "https://www.africau.edu/images/default/sample.pdf")
        }
    }
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView()
    }
}
