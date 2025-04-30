//
//  AsyncStreamBootcamp.swift
//  并发练习
//
//  Created by Star. on 2025/4/30.
//
/*
 基本概念
 AsyncStream 是一种异步生成值的方式，类似于同步的 Sequence 协议，但它可以在异步上下文中工作。它允许你在不同的时间点生成值，而调用者可以使用 for await 循环来异步地接收这些值。
 使用场景
 事件流处理：当你需要处理一系列异步事件时，例如网络请求的响应、用户输入事件等，可以使用 AsyncStream 来表示这些事件流。
 数据生成：如果你需要异步地生成一系列数据，例如从数据库中逐行读取数据、从文件中逐块读取数据等，AsyncStream 可以很好地满足需求
 */


import SwiftUI
import Combine

class AsyncStreamDataManager {
    
    func getAsyncStream
    ()-> AsyncThrowingStream<Int, Error>
    {
        AsyncThrowingStream(Int.self)
        {
            [weak self] continuation in
            self?.getFakeData
            { value in
                continuation.yield(value)
            } onFinish:
            { error in
                    continuation.finish(throwing: error)
            }
        }
    }
    
    // 假设的api请求
    func getFakeData
    (newValue: @escaping (_ value: Int) -> Void,
     onFinish: @escaping (_ error: Error?)-> Void
    ){
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        for item in items
        {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Double(item),
                execute:
                    {
                newValue(item)
                    print("NEW DATA: \(item)")
                if item == items.last
                        {
                    onFinish(nil)
                        }
                    }
            )
            
        }
    }
    
}

@MainActor
final class
AsyncStreamViewModel:ObservableObject {
    
    let manager = AsyncStreamDataManager()
    @Published private(set) var currentNumber:Int = 0
    
    func onViewAppear() {
//        manager.getFakeData { [weak self] value in
//            self?.currentNumber = value
//        }
        let task =  Task {
            do{
                for try await value in manager.getAsyncStream(){
                    currentNumber = value
                }
            }catch{
                print(error)
            }
        }
        //取消任务时只是取消了逃逸的闭包，并未完全取消闭包内的底层函数
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            task.cancel()
            print("任务取消！")
        })
    }
    
}



struct AsyncStreamBootcamp: View {
    
    @StateObject private var vm = AsyncStreamViewModel()
    
    var body: some View {
        Text("\(vm.currentNumber)")
            .onAppear {
                vm.onViewAppear()
            }
        
        
    }
}

#Preview {
    AsyncStreamBootcamp()
}
