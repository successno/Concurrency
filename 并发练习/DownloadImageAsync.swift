//
//  DownloadImageAsync.swift
//  并发练习
//
//  Created by Star. on 2025/4/24.
//

import SwiftUI

struct DownloadImageAsync: View {
    
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
                    
            }
                
        }
        .onAppear{
            Task {
                await viewModel.fetchImage()
            }
            
        }
    }
}

#Preview {
    DownloadImageAsync()
}
