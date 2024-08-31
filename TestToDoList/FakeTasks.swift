//
//  FakeTasks.swift
//  TestToDoList
//
//  Created by Marat Fakhrizhanov on 31.08.2024.
//

import Foundation


struct FakeTasks: Decodable {
    let todos: [FakeTask]
    let total: Int
    let skip: Int
    let limit: Int
}

struct FakeTask: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
