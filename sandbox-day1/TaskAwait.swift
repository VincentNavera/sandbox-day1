//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by Vincio on 8/3/21.
//

import SwiftUI


struct SwiftUIView2: View {
    @State private var inbox = [Message]()
    @State private var sent = [Message]()

    @State private var selectedBox = "Inbox"
    let messageBoxes = ["Inbox", "Sent"]

    var messages: [Message] {
        if selectedBox == "Inbox" {
            return inbox
        } else {
            return sent
        }
    }

    var body: some View {
        NavigationView {
            List(messages) { message in
                Text("\(message.user): ").bold() +
                Text(message.text)
            }
            .navigationTitle("Inbox")
            .toolbar {
                Picker("Select a message box", selection: $selectedBox) {
                    ForEach(messageBoxes, id: \.self, content: Text.init)
                }
                .pickerStyle(.segmented)
            }
            .task {
                do {
                    let inboxTask = Task { () -> [Message] in let inboxURL = URL(string: "https://hws.dev/inbox.json")!
                        return try await URLSession.shared.decode(from: inboxURL)
                    }

                    let sentTask = Task { () -> [Message] in let sentURL = URL(string: "https://hws.dev/sent.json")!
                        return try await URLSession.shared.decode(from: sentURL)
                    }



                    inbox = try await inboxTask.value
                    sent = try await sentTask.value
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

//    func fetchInbox() async throws -> [Message] {
//        var inboxURL = URL(string: "https://hws.dev/inbox.json")!
//        return try await URLSession.shared.decode(from: inboxURL)
//    }
//
//    func fetchSent() async throws -> [Message] {
//        var inboxURL = URL(string: "https://hws.dev/sent.json")!
//        return try await URLSession.shared.decode(from: inboxURL)
//    }
}

struct SwiftUIView2_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView2()
    }
}
