//
//  SendableBootcamp.swift
//  并发练习
//
//  Created by Star. on 2025/4/30.
//

import SwiftUI

actor CurrentUserManager{
    
    func updateDatabase(userInfo: MyClassInfo) -> () {
        
    }
    
}

struct MyUserInfo:Sendable {
    let name: String
}

//不推荐使用类来使用Sendable
final class MyClassInfo: @unchecked Sendable {
   private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    init(name: String) {
        self.name = name
    }
    func updateName(name:String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel:ObservableObject{
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info = MyClassInfo(name: "info")
        
        await manager.updateDatabase(userInfo:info )
    }
}

struct SendableBootcamp: View {
    
    @StateObject private var vm = SendableBootcampViewModel()
    
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

#Preview {
    SendableBootcamp()
}
