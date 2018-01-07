//
//  20171212_01.swift
//  socket20171208
//
//  Created by Egbert Chang on 12/12/2017.
//  Copyright © 2017 Aleph Tdu. All rights reserved.
//

import Foundation

/*
 * 在类中定义数据，在扩展中定义方法
 */
class send_sketch1 {
//    var stringArr: [String] = []
    var socket: CFSocket!
    var addressStruct: UnsafeMutablePointer<sockaddr_in> = UnsafeMutablePointer<sockaddr_in>.allocate(capacity: 1)
    
    init() {}
}

class message_box {
    var messagePointer: UnsafeRawPointer!
    var message: String!
    
    init(_ address: UnsafeRawPointer) {
        self.messagePointer = address
    }
    
    func showmessage() {
        
        // UnsafeRawPointer
        var lengthData = Data.init()
        // 不会超过14位数的，如果在16B中截取的数值不对的话，那这个传输的比特流数量大的惊人！
        let bufferPointer = UnsafeRawBufferPointer.init(start: self.messagePointer.advanced(by: 48), count: 1 << 4)
        var iterator = bufferPointer.makeIterator()
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        
        while true {
            let u = iterator.next()!
            if u > 0 {
                lengthData.append(u)
            } else {
                break
            }
        }
        
        // bufferPointer.filter { (u) in
        //     lengthData.append(u)
        //     if Character.init(Unicode.Scalar(u)) == "}" {
        //         print("Enter here ")
        //     }
        //     print(Character.init(Unicode.Scalar(u)))
        //     return true
        // }
        
        // let singleMessageLength = Data.init(bytes: (self.messagePointer.advanced(by: 48)), count: 1 << 2)
        let msg = String.init(data: lengthData, encoding: String.Encoding.utf8)
        print(msg!)
    }
}

var count: Int = 1

func notificationFromServer(_ address: UnsafeRawPointer) {
    count = count + 1
    let message = message_box(address)
    message.showmessage()
    
    // print(count)
    // print("A new message coming ...")
}


extension send_sketch1 {
    private func createSocket() {
        
        // let ipDeci: String = "121.43.183.17"
        let ipDeci: String = "127.0.0.1"
        let ipToCChars = ipDeci.cString(using: String.Encoding.ascii)
        // in_addr_t 一般为 32位的unsigned int
        let ipBinary: UnsafeMutablePointer<in_addr_t> = UnsafeMutablePointer<in_addr_t>.allocate(capacity: 1)
        let port = UInt16(9090)
        
        // 将点分十进制地址转换为二进制代码
        inet_pton(AF_INET, ipToCChars, ipBinary)
        // public typealias __uint8_t = UInt8
        // public var sin_len: __uint8_t
        addressStruct.pointee.sin_len = __uint8_t(MemoryLayout.size(ofValue: sockaddr_in()))
        addressStruct.pointee.sin_family = sa_family_t(AF_INET)
        addressStruct.pointee.sin_port = in_port_t(port.bigEndian)
        // sin_zero用来将sockaddr_in结构填充到与struct sockaddr同样的长度，可以用bzero()或memset()函数将其置为零
        addressStruct.pointee.sin_zero = (0,0,0,0,0,0,0,0)
        // in_add表示一个结构体
        addressStruct.pointee.sin_addr = in_addr(s_addr: ipBinary.pointee)
        
        let sockaddr_in_struct_len = __uint8_t(MemoryLayout.size(ofValue: sockaddr_in()))
        let addressPointer = addressStruct.withMemoryRebound(to: UInt8.self, capacity: Int(sockaddr_in_struct_len)) { (ptr: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return ptr
        }
        // print("Create Socket")
        // #define AF_INET 2
        // #define SOCK_STREAM 1
        // #define IPPROTO_TCP 6  tcp
        let addressData = CFDataCreate(kCFAllocatorDefault, addressPointer, CFIndex(sockaddr_in_struct_len))
        let unmanageData: Unmanaged<CFData> = Unmanaged<CFData>.passRetained(addressData!)
        
        let signature = CFSocketSignature.init(
            protocolFamily: 2,
            socketType: 1,
            protocol: 6,
            address: unmanageData)
        
        // let signaturePointer: UnsafePointer<CFSocketSignature> = UnsafePointer<CFSocketSignature>(&signature)
        let mp: UnsafeMutablePointer<CFSocketSignature> = UnsafeMutablePointer<CFSocketSignature>.allocate(capacity: 1)
        mp.pointee = signature
        let signaturePointer: UnsafePointer<CFSocketSignature> = UnsafePointer.init(mp)
        
        //UnsafeMutablePointer<CFSocketSignature>.allocate(capacity: 1)
        // kCFSocketConnectCallBack = 4,
        
        
       
        
        socket = CFSocketCreateConnectedToSocketSignature(
            kCFAllocatorDefault,
            signaturePointer,
            3, {(socket, CFSocketCallBackType, addressData, serverMessage, info) in
                // addressData: CFData
                // serverMessage: UnsafeRawPointer
                
                if serverMessage != nil {
                    notificationFromServer(serverMessage!)
                    
                    
                    // init(UnsafeMutablePointer<Pointee>
                    // let messagePointer = serverMessage
                    // let data = Data.init(bytes: (serverMessage?.advanced(by: 48))!, count: 60)
                    
                    // print(data)  // 这里会输出byte的长度，类似如下的输出：20 bytes
                    
                    // let messageString = String.init(data: data, encoding: String.Encoding.utf8)
                    // self.stringArr.append(messageString!)
                    // print(self.stringArr)
                    // print(messageString)
                    
                    // notificationFromServer("A new message coming ...")
                    
                    
                    // print(messageString!)
                    // print(messageString?.count)

                    // let charArray = data.forEach({ (uint) in
                    //    print(Character.init(Unicode.Scalar(uint)))
                    // })
                    
                    
                    
                    // buffer: UnsafeRawBufferPointer
                    // UnsafeMutableRawBufferPointer
                    
                    // 申请1M的内存
                    // let buffer = UnsafeRawBufferPointer.init(start: serverMessage, count: 1 << 8)
                    // init(bytes: UnsafeRawPointer, count: Int)
                    // init<SourceType>(buffer: UnsafeBufferPointer<SourceType>)
                    // init<SourceType>(buffer: UnsafeMutableBufferPointer<SourceType>)
                    
                    
                    
                    // print(buffer.count)
                    // print(serverMessage!)         // 输出的内容形式如下：0x00006000000bc680
                    // print(buffer.baseAddress!)    // 输出的内容形式如下：0x00006000000bc680
                    // print(buffer.isEmpty)
                    // print(buffer.sorted())
                    
                    // let charArray = buffer.map({ (c) -> Character in
                         // print(Character.init(Unicode.Scalar(c)))
                         // return Character.init(Unicode.Scalar(c))
                    // })
                    // let uint8Array = buffer.map({ (c) -> UInt8 in
                        // print(Character.init(Unicode.Scalar(c)))
                        // return c
                    // })
                    // print(charArray)
                    // print("\n")
                    // print(uint8Array)
                    
                }
            
        }, nil, CFTimeInterval(3.0))
        
        
        
        var array: [UInt8]  = [97, 98, 99, 100]
        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &array, count: array.count)
        var dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: array.count)
        dataPtr = arrayPtr.baseAddress!
        
        
        let sendData = CFDataCreate(kCFAllocatorDefault, dataPtr, 10)!
        CFSocketSendData(socket, addressData, sendData, CFTimeInterval(3.0))
    
        // 获取输入源
        let runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, CFIndex(10))
        // 将输入源添加到当前线程中的RunLoop中去
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource!, CFRunLoopMode.defaultMode)
        
        // 下面三行代码在listening的作用上看上去有点多余！
        // CFRunLoopWakeUp(CFRunLoopGetCurrent())
        // let secondaryThread = Thread(target: self, selector: #selector(self.startThreadWithRunloop), object: nil)
        // secondaryThread.start()
    }
    
    
    // 两类输入源的区别在于如何显示: 基于端口的输入源由内核自动发送，而自定义的则需要人工从其他线程发送。
    // To listen for messages, you need to create a run loop source with CFSocketCreateRunLoopSource(_:_:_:)
    // and add it to a run loop with CFRunLoopAddSource(_:_:_:).
    // You can select the types of socket activities, such as connection attempts or data arrivals,
    // that cause the source to fire and invoke your CFSocket’s callback function.
    @objc func startThreadWithRunloop() {
        // 获取输入源
        let runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, CFIndex(10))
        // 将输入源添加到当前线程中的RunLoop中去
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource!, CFRunLoopMode.defaultMode)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
        
        var count: Int = 0
        var done = false
        repeat {
            count = count + 1
            print(count)
            let result = CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, true)
            if ((result == CFRunLoopRunResult.stopped) || (result == CFRunLoopRunResult.finished)) {
                done = true
            }
        } while(!done)
    }
}

extension send_sketch1 {
    public func sendMessage() -> Void {
        self.createSocket()
        // print("Send Message ...")    // 上一行socket的执行是异步的
    }
}
