//
//  AssistantView.swift
//  Matex
//
//  Created by Sahil Sharma on 04/04/23.
//

import SwiftUI

struct AssistantView: View {
    
    var matexFile: MatexFile?
    
    @State
    var messages: [String] = ["Fetching messages..."]
    
    @State
    var query = ""
    
    @State
    var loadSpinner: Bool = false
    
    func fetchChatGPTResponse() async -> Void {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
  
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return }
        guard let mySecretApiKey: String = infoDictionary["OpenAIApiKey"] as? String else { return }

        request.setValue(mySecretApiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var chatMessages = [Message]()
        
        for (index, message) in messages.enumerated(){
            if index == 0 {
                chatMessages.append(Message(role: "system", content: "YYou are a helpful assistant."))
            }
            else if index%2 == 0 {
                chatMessages.append(Message(role: "assistant", content: message))
            }
            else{
                chatMessages.append(Message(role: "user", content: message))
            }
        }
        
        let chatGptQuery = ChatGptQuery(messages: chatMessages)
        
        guard let uploadData = try? JSONEncoder().encode(chatGptQuery) else {
            return
        }
        
        request.httpBody = uploadData
        
        let task = URLSession.shared.dataTask(with: request){ responseData, _ ,error in
            guard let responseData = responseData, error == nil else {
                return
            }
            
            do{
                let response = try JSONDecoder().decode(ChatGptResponse.self, from: responseData)
                messages.append(response.choices[0].message.content)
                loadSpinner.toggle()
            }
            catch {
                return
            }
        }
        
        task.resume()
    }
    
    func SaveMessages() -> Void {
        matexFile!.toChat!.messages! = messages

        PersistenceController.shared.save()
    }
    
    init(currMatexFile: MatexFile){
        matexFile = currMatexFile
        _messages = State(initialValue: matexFile!.toChat!.messages!)
    }
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    ForEach(messages.indices, id: \.self){index in
                        let message = messages[index]
                        if index % 2 == 0 {
                            ChatBubble(direction: .left) {
                                Text(message)
                                    .padding(.all, 12)
                                    .foregroundColor(Color.black)
                                    .background(Color(red: 216 / 255, green: 216 / 255, blue: 216 / 255))
                            }
                        }
                        else{
                            ChatBubble(direction: .right) {
                                Text(message)
                                    .padding(.all, 12)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                            }
                        }
                    }
                }
            }
            .overlay(alignment: .bottom){
                HStack{
                    TextField("Ask your query here...", text: $query)
                    Button{
                        
                        Task{
                            await fetchChatGPTResponse()
                        }
                    
                        loadSpinner.toggle()
                        messages.append(query)
                        query = ""
                    } label: {
                        Label("Send", systemImage: "paperplane.fill")
                    }
                }
                .padding(12)
                .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                .clipShape(Rectangle())
                .cornerRadius(20)
                .padding(10)
                .shadow(color: Color.black.opacity(0.2),radius: 5)
            }
            
            if loadSpinner{
                Spinner()
            }
        }
        
    }
}

//struct AssistantView_Previews: PreviewProvider {
//    static var previews: some View {
//        AssistantView(currMatexFile: MatexFile())
//    }
//}
