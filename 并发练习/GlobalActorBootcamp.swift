//
//  GlobalActorBootcamp.swift
//  并发练习
//
//  Created by Star. on 2025/4/27.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
    
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five", "Six"]
    }
    
}

//@MainActor
class GlobalActorBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    //    @Published var dataArray1: [String] = []
    //    @Published var dataArray2: [String] = []
    //    @Published var dataArray3: [String] = []
    //    @Published var dataArray4: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    
    //    nonisolated
    @MyFirstGlobalActor func getData() {
        
        // HEAVY COMPLEX METHODS
        
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run(body: {
                self.dataArray = data
            })
        }
    }
    
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
    
}

#Preview {
    GlobalActorBootcamp()
}
