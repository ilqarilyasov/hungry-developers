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
    let index: Int
    let lock = NSLock()
    
    init(index: Int) {
        self.index = index
    }
    
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
        print("\(name) picked left spoon index \(leftSpoon.index)")
        rightSpoon.pickUp()
        rsPickUpCount += 1
        print("\(name) picked right spoon index \(rightSpoon.index)")
    }
    
    func eat() {
        print("\(name) started eating")
        sleep(5)
        leftSpoon.putDown()
        lsPutDownCount += 1
        print("\(name) put left spoon index \(leftSpoon.index) down")
        rightSpoon.putDown()
        rsPutDownCount += 1
        print("\(name) put right spoon index \(rightSpoon.index) down")
    }
    
    func run() {
        var count = 0
        
        while count < 1 {
            think()
            eat()
            count += 1
        }
    }
}


// MARK: - TESTING

var developers = [Developer]()
var spoons = [Spoon]()


// MARK: - Create 5 spoons

for i in 1...5 {
    let spoon = Spoon(index: i)
    spoons.append(spoon)
}


// MARK: - Create 5 developers and assign them the spoons

for i in 1...spoons.count {
    if i == 1 {
        let developer = Developer(name: "Dev\(i)",leftSpoon: spoons[i - 1],
                                  rightSpoon: spoons[spoons.count - 1])
        developers.append(developer)
    } else {
        let developer = Developer(name: "Dev\(i)",leftSpoon: spoons[i - 2],
                                  rightSpoon: spoons[i - 1])
        developers.append(developer)
    }
}


// MARK: - Run developers in different threads

let startTime = CFAbsoluteTimeGetCurrent()
let difference = CFAbsoluteTimeGetCurrent() - startTime

DispatchQueue.concurrentPerform(iterations: 5) { index in
    print("Started work of \(index): \(startTime)")
    developers[index].run()
    print("Finished work of \(index): \(difference)")
    print("\(developers[index].name) lsPickUpCount: \(developers[index].lsPickUpCount)")
    print("\(developers[index].name) rsPickUpCount: \(developers[index].rsPickUpCount)")
    print("\(developers[index].name) lsPutDownCount: \(developers[index].lsPutDownCount)")
    print("\(developers[index].name) rsPutDownCount: \(developers[index].rsPutDownCount)")
}
