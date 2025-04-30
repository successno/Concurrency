//
//  TaskGroupBootcamp.swift
//  并发练习
//
//  Created by Star. on 2025/4/25.
//

import SwiftUI

class TaskGroupBootcampDataManager{
    
    
    func fecthImagesWithAsyncLet() async throws -> [UIImage] {
        async let fecthImage1 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/300")
        
        let (image1, image2, image3, image4) = await(try fecthImage1 ,try fetchImage2,try fetchImage3,try fetchImage4)
        
        return [image1, image2, image3, image4]
    }
    
    
    func fecthImagesWithTaskGroup() async throws -> [UIImage] {
        
        let urlString = [
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300"
        ]
        
      return try await withThrowingTaskGroup { group in
           var images:[UIImage] = []
          images.reserveCapacity(urlString.count)
          
          for urlString in urlString {
              group.addTask {
                  try? await  self.fetchImage(urlString: urlString)
              }
          }

//          group.addTask {
//            try await  self.fetchImage(urlString: "https://picsum.photos/300")
//          }
//          group.addTask {
//              try await  self.fetchImage(urlString: "https://picsum.photos/300")
//          }
//          group.addTask {
//              try await  self.fetchImage(urlString: "https://picsum.photos/300")
//          }
//          group.addTask {
//              try await  self.fetchImage(urlString: "https://picsum.photos/300")
//          }
//          
          for try await image in group{
              if let image = image {
                  images.append(image)
              }
          }
            return images
        }
    }
    

    func fetchImage(urlString:String) async throws -> UIImage{
        guard let url = URL(string: "https://picsum.photos/300") else {
            throw URLError(.badURL)
        }
        do {
            let (data, _ ) = try await URLSession.shared.data(for: URLRequest(url: url))
            if let image = UIImage(data: data){
                return image
            }else{
                throw URLError(.badURL)
            }
        } catch  {
            throw error
        }
    }
    
    
}

class TaskGroupBootcampViewModel:ObservableObject{
    @Published  var images:[UIImage] = []
    let manager = TaskGroupBootcampDataManager()
    
    func getImage() async {
        if let images = try? await manager.fecthImagesWithTaskGroup(){
            self.images.append(contentsOf: images)
        }
    }
}


struct TaskGroupBootcamp: View {
    
    @StateObject private var viewModel = TaskGroupBootcampViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height:150)
                    }
                } 
            }
            .navigationTitle("Task Group")
            .task {
                await viewModel.getImage()
            }
        }
    }
}

#Preview {
    TaskGroupBootcamp()
}
