//
//  PdfView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct PdfView: View {
    
    let ngrokUrl: String
    
    let pdfUrl: URL
    
    @State
    var isPdfRenderedOnce = false
    
    @State
    var needRender = true
    
    init(currMatexFile: MatexFile) {
        matexFile = currMatexFile
        ngrokUrl = "http://13.233.212.57"
        pdfUrl = URL(string: "\(ngrokUrl)/servePdf/\(matexFile!.fileid!.uuidString).pdf")!
    }
    
    @State
    var loadSpinner = false
    
    var matexFile: MatexFile?
    
    func RenderPdf() async -> Void {
        let url = URL(string: ngrokUrl + "/renderPdf")!
  
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        
        let pdfData = PdfData(title: matexFile!.toConfig!.documentTitle!,
                              subtitle: matexFile!.toConfig!.subtitle!,
                              author: matexFile!.toConfig!.author!,
                              date: formatter.string(from: matexFile!.toConfig!.creationDate!) ,
                              horizontalMargin: matexFile!.toConfig!.horizontalMargin.description,
                              verticalMargin: matexFile!.toConfig!.verticalMargin.description,
                              fontsize: matexFile!.toConfig!.fontSize.description,
                              colorlinks: matexFile!.toConfig!.colorLinks,
                              isTocEnabled: matexFile!.toConfig!.generateTableOfContent,
                              content: matexFile!.content!,
                              filename: matexFile!.fileid!.uuidString)
        
        guard let uploadData = try? JSONEncoder().encode(pdfData) else {
            return
        }
        
        request.httpBody = uploadData
        
        let task = URLSession.shared.dataTask(with: request){ _, _ ,error in
            guard error == nil else {
                return
            }
            
            loadSpinner.toggle()
            needRender.toggle()
        }
        
        task.resume()
    }
    
    var body: some View {
        ZStack{
            ZStack(alignment: .bottomTrailing) {
                
                PDFKitRepresentedView(pdfUrl: pdfUrl, needRender: $needRender)
                
                HStack{
                    Button {
                        FileDownloader.loadFileAsync(url: pdfUrl) { (path, error) in
                            print("PDF File downloaded to : \(path!)")
                        }
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
                        Task{
                            await RenderPdf()
                        }
                        loadSpinner.toggle()
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
            .onAppear{
                if !isPdfRenderedOnce {
                    Task{
                        await RenderPdf()
                    }
                    loadSpinner.toggle()
                    isPdfRenderedOnce.toggle()
                }
            }
            
            if loadSpinner{
                Spinner()
            }
        }
    }
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView(currMatexFile: MatexFile())
    }
}
