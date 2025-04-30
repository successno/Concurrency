//
//  StructClassActorBootcamp.swift
//  并发练习
//
//  Created by Star. on 2025/4/25.
//
/*
 值类型（VALUE TYPES）：包含结构体、枚举、字符串、整数等，存储在栈中，速度快，线程安全，赋值或传递时会创建新的数据副本。
 
 引用类型（REFERENCE TYPES）：包含类、函数、参与者等，存储在堆中，速度相对较慢但支持同步操作，默认情况下不是线程安全的，赋值或传递时会创建指向原实例的新引用（指针）。
 
 栈（STACK）：存储值类型，变量直接存储在内存中，访问速度快，每个线程都有自己的栈。
 
 堆（HEAP）：存储引用类型，在多个线程间共享。
 
 结构体（STRUCT）：基于值，可修改，存储在栈中。
 
 类（CLASS）：基于引用（实例），存储在堆中，可继承其他类。
 
 参与者（ACTOR）：与类类似，但具备线程安全特性。
 
 同时，还给出了结构体、类和参与者的常见使用场景：
 
 结构体：适用于数据模型、视图。
 
 类：常用于视图模型。
 
 参与者actor：适用于共享的 “管理器” 和 “数据存储”
 
 */

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StructClassActorBootcamp()
}
