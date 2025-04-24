//
//  TaskBootcamp.swift
//  并发练习
//
//  Created by Star. on 2025/4/24.
//

import SwiftUI

class TaskBootcampViewModel:ObservableObject {
    
    @Published  var image:UIImage? = nil
    @Published  var image2:UIImage? = nil
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            await MainActor.run {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY!")
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch  {
            print(error.localizedDescription)
        }
    }

    
    
}
struct TaskBootcampHomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME! 🤓") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    //虽然 .task包含了取消和onappear，
    //但是取消了也会有延迟，需要用 .Task.cheekCancellation() 进行检查，有任务的话会抛出错误
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    @State private var fetchImageTask:Task<Sendable, Error>? = nil
    
    var body: some View {
        VStack(spacing: 40.0){
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear(perform: {
//            fetchImageTask?.cancel()
//        })
//        .onAppear {
//            fetchImageTask = Task{
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage()
//            }
        
//        }
        
        /*
         由高到低优先级，并不代表会先完成
        .userInitiated
        .high
        .medium
        .low
        .utility
        .background
         */
    }
}

#Preview {
    TaskBootcampHomeView()
}
