//
//  DownloadImageAsyncViewModel.swift
//  并发练习
//
//  Created by Star. on 2025/4/24.
//

import Foundation
import SwiftUI
import Combine

class DownloadImageAsyncViewModel:ObservableObject {
    
    @Published var image: UIImage?
    let loader = DownloadImageAsyncImageLoder()
    var cancellable = Set<AnyCancellable>()
    
    func fetchImage() async {
//        loader.downloadWithEscaping {[weak self] image, error in
//            DispatchQueue.main.async{
//                self?.image = image
//            }
//        }

//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//    
//            } receiveValue: { [weak self] image in
//                            DispatchQueue.main.async{
//                                self?.image = image
//                            }
//            }
//            .store(in: &cancellable)

        
        let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}

class DownloadImageAsyncImageLoder{
    
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func urlResponse(data:Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            200...299 ~= response.statusCode else {return nil}
        return image
    }
    
    func downloadWithEscaping(completionHandle: @escaping (_ image:UIImage?,_ error:Error?)->() ){
        URLSession.shared.dataTask(with: url) { data, response, error in
            let image = self.urlResponse(data:data,response: response)
            completionHandle(image, error)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(urlResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
//    func downloadWithAsync() async throws -> UIImage? {
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
//            return urlResponse(data:data,response: response)
//        } catch {
//            throw error
//        }
//        
//    }
    
    func downloadWithAsync() async throws -> UIImage? {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        // 如果 urlResponse 方法抛出错误 ， 那么try是必要的不可去掉，忽略警告即可
            return try urlResponse(data: data, response: response)
    }
    
}
