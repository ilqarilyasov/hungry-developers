//
//  main.swift
//  HungryDevelopers
//
//  Created by Ilgar Ilyasov on 2/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

// MARK: - Spoon class

class Spoon {
    
    let lock = NSLock()
    
    func pickUp() {
        lock.lock()
    }
    
    func putDown() {
        lock.unlock()
    }
}


// MARK: - Developer class

class Developer {
    
    let name: String
    let leftSpoon: Spoon
    let rightSpoon: Spoon
    var lsPickUpCount = 0
    var rsPickUpCount = 0
    var lsPutDownCount = 0
    var rsPutDownCount = 0
    
    init(name: String, leftSpoon: Spoon, rightSpoon: Spoon) {
        self.name = name
        self.leftSpoon = leftSpoon
        self.rightSpoon = rightSpoon
    }
    
    func think() {
        print("\(name) started thinking")
        leftSpoon.pickUp()
        lsPickUpCount += 1
        print("\(name) picked left spoon")
        rightSpoon.pickUp()
        rsPickUpCount += 1
        print("\(name) picked right spoon")
    }
    
    func eat() {
        print("\(name) started eating")
        usleep(200)
        leftSpoon.putDown()
        lsPutDownCount += 1
        print("\(name) put left spoon down")
        rightSpoon.putDown()
        rsPutDownCount += 1
        print("\(name) put right spoon down")
    }
    
    func run() {
        var count = 0
        
        while count < 20 {
            think()
            eat()
            count += 1
        }
    }
}


// MARK: - TEST

var developers = [Developer]()
let startTime = CFAbsoluteTimeGetCurrent()
let difference = CFAbsoluteTimeGetCurrent() - startTime

for i in 0..<5 {
    let developer = Developer(name: "Dev\(i)",leftSpoon: Spoon(), rightSpoon: Spoon())
    developers.append(developer)
}

DispatchQueue.concurrentPerform(iterations: 5) { index in
    print("Started work of \(index): \(startTime)")
    developers[index].run()
    print("Finished work of \(index): \(difference)")
    print("\(developers[index].name) lsPickUpCount: \(developers[index].lsPickUpCount)")
    print("\(developers[index].name) rsPickUpCount: \(developers[index].rsPickUpCount)")
    print("\(developers[index].name) lsPutDownCount: \(developers[index].lsPutDownCount)")
    print("\(developers[index].name) rsPutDownCount: \(developers[index].rsPutDownCount)")
}
