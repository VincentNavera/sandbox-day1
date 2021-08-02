//
//  ContentView.swift
//  sandbox-day1
//
//  Created by Vincio on 8/2/21.
//

import SwiftUI


extension URLSession {
    func decode<T: Decodable>(_type: T.Type = T.self, from url: URL, KeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, DataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
                              dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate) async throws -> T {
        let (data, _) = try await data(from: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = KeyDecodingStrategy
        decoder.dataDecodingStrategy = DataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy

        let decoded = try decoder.decode(T.self, from: data)

        return decoded
    }

}

struct Petition: Identifiable, Decodable{
    let id: String
    let title: String
    let body: String
    let signatureCount: Int
    let signatureThreshold: Int
}

struct ContentView: View {

    @State private var petitions = [Petition]()
    var body: some View {
        NavigationView {
            List(petitions) {
                petition in
                VStack{
                    Text(petition.title)
                    Text(petition.body)
                    Text(String(petition.signatureCount))
                    Text(String(petition.signatureThreshold))
                }
            }
        }.task{
            do{
                let url = URL(string: "https://hws.dev/petitions.json")!
                let (data, _) = try await URLSession.shared.data(from: url)
                petitions = try JSONDecoder().decode([Petition].self, from: data)

            } catch {
                print("failed to catch")
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
