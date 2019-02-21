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
    
    init(name: String, leftSpoon: Spoon, rightSpoon: Spoon) {
        self.name = name
        self.leftSpoon = leftSpoon
        self.rightSpoon = rightSpoon
    }
    
    func think() {
        print("\(name) started thinking")
        if rightSpoon.index > leftSpoon.index {
            leftSpoon.pickUp()
            rightSpoon.pickUp()
        } else {
            rightSpoon.pickUp()
            leftSpoon.pickUp()
        }
    }
    
    func eat() {
        print("\(name) started eating")
        usleep(2000)
        print("\(name) finished eating")
        leftSpoon.putDown()
        rightSpoon.putDown()
    }
    
    func run() {
        
//        while true {
//            think()
//            eat()
//        }
        
        for _ in 0...20 {
            think()
            eat()
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

/*
 Dev1 = spoon 1 - spoon 5
 Dev2 = spoon 1 - spoon 2
 Dev3 = spoon 2 - spoon 3
 Dev4 = spoon 3 - spoon 4
 Dev5 = spoon 4 - spoon 5
 */

for i in 1...spoons.count {
    if i == 1 {
        let developer = Developer(name: "Dev\(i)",
            leftSpoon: spoons[i - 1],
            rightSpoon: spoons[spoons.count - 1])
        developers.append(developer)
    } else {
        let developer = Developer(name: "Dev\(i)",
            leftSpoon: spoons[i - 2],
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
}
