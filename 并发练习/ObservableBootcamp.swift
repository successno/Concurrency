//
//  ObservableBootcamp.swift
//  并发练习
//
//  Created by Star. on 2025/4/30.
//

import SwiftUI

actor TitleDatabase{
    
    func getNewTitle() -> String {
        "Some new title!"
    }
}


//@MainActor
//class ObservableBootcampViewModel:ObservableObject {
//    
//    let database = TitleDatabase()
//    @Published var title:String = "Starting title"
//    
//    func updatetitle() async {
//        title = await database.getNewTitle()
//    }
//}

// iOS 17.0开始

//@Observable class ObservableBootcampViewModel {
//    
//    @ObservationIgnored let database = TitleDatabase()
//    var title:String = "Starting title"
//    
//    func updatetitle() async {
//        title = await database.getNewTitle()
//    }
//}


//@Observable class ObservableBootcampViewModel {
//    
//    @ObservationIgnored let database = TitleDatabase()
//    @MainActor var title:String = "Starting title"
//    
//    //@MainActor  如果不想标志整个函数就可以 使用 NO 1
//    func updatetitle() async {
//        // NO 1 将title进行接受
//      let title = await database.getNewTitle()
//        
//        // NO 1 再使用 MainActor.run 换成主线程
//        await MainActor.run {
//            self.title = title
//            print(Thread.current)
//        }
//    }
//}


@Observable class ObservableBootcampViewModel {
    
    @ObservationIgnored let database = TitleDatabase()
    @MainActor var title:String = "Starting title"
    
    //@MainActor  如果不想标志整个函数就可以 使用 NO 2
    
    func updatetitle() {
        Task{ @MainActor in
        title = await database.getNewTitle()
        print(Thread.current)
            
        }
    }
}

struct ObservableBootcamp: View {
    
    @State private var vm = ObservableBootcampViewModel()
    
    var body: some View {
        Text(vm.title)
//            .task {
//                await vm.updatetitle()
//            }
        
        
        // NO 2
            .onAppear {
                vm.updatetitle()
            }
        
        
    }
}

#Preview {
    ObservableBootcamp()
}
