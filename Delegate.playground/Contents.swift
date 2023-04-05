import UIKit

protocol RemoteControlDelegate {
    func channelUp()
    func channelDown()
}

class RemoteControl {
    var delegate: RemoteControlDelegate?
    
    func doSomething() {
        print("리모콘의 조작이 일어나고 있음")
    }
    
    func channelUp() {
        delegate?.channelUp()
    }
    
    func channelDown() {
        delegate?.channelDown()
    }
}

class TV: RemoteControlDelegate {
    func channelUp() {
        print("TV의 채널이 올라간다.")
    }
    
    func channelDown() {
        print("TV의 채널이 내려간다.")
    }
}

let remote = RemoteControl()
let samsungTV = TV()
remote.delegate = samsungTV
remote.channelUp()
remote.channelDown()

class SmartPhone: RemoteControlDelegate {
    
    init(remote: RemoteControl) {
        remote.delegate = self
    }
    
    func channelUp() {
        print("스마트폰의 채널이 올라간다.")
    }
    
    func channelDown() {
        print("스마트폰의 채널이 내려간다.")
    }
}

let smartPhone = SmartPhone(remote: remote)
remote.channelUp()
remote.channelDown()
