//
//  20171212_01.swift
//  socket20171208
//
//  Created by Egbert Chang on 12/12/2017.
//  Copyright © 2017 Aleph Tdu. All rights reserved.
//

import Foundation
import UIKit

/*
 * 在类中定义数据，在扩展中定义方法
 */
class send_sketch1 {
//    var stringArr: [String] = []
    var socket: CFSocket!
    var addressStruct: UnsafeMutablePointer<sockaddr_in> = UnsafeMutablePointer<sockaddr_in>.allocate(capacity: 1)
    
    init() {}
}


// 以下操作完全是基于正常的网络请求实现的操作
class message_box {
    var messagePointer: UnsafeRawPointer!
    var message: String!
    var messageContentOffset: Int!
    var messageSize: Int!
    var socket: CFSocket!
    var address: CFData!
    
    init(_ pointer: UnsafeRawPointer, _ socket: CFSocket, _ addressData: CFData) {
        self.messagePointer = pointer
        self.socket = socket
        self.address = addressData
    }
    
    
    func showmessage() {
        
        // 如果数据超过了5位，那几乎是变态的数据量
        // 这里也会出现问题，就是不知道服务器传输过来的byte流的长度。使用一个大致的缓冲区来接收这些数据，但不要做任何的解码操作
        // 因为数据的不完整性会导致任何解码错误，将raw数据copy一部分到Data中，调用Data中相关方法摘取byte流的量
        
        let buffer = UnsafeRawBufferPointer.init(start: self.messagePointer, count: 48)
        let bytelen = buffer[24...25]
        let array = bytelen.map({ (c) -> UInt8 in
            return c
        })
        var value : UInt32 = 0
        let data = NSData(bytes: array, length: 2)
        data.getBytes(&value, length: 2)
        value = UInt32(littleEndian: value)
        print(value) // 14
        // return
        
        let fileData = Data.init(bytes: self.messagePointer.advanced(by: 48), count: Int(value))
        // let sizeData = containSizeData.split(separator: 125, maxSplits: 1, omittingEmptySubsequences: true)[0].dropFirst()
        print(fileData.count)
        // 这里最好使用抛出异常的方式来实现
        // let sizeInString = String.init(data: sizeData, encoding: String.Encoding.utf8)!
        // print(sizeInString)
        // self.messageContentOffset = sizeData.count + 2
        // self.messageSize = Int(sizeInString)
        // print(self.messageSizeOffset)
        // print(Int(messageSizeString)!)
        
        // let messageData = Data.init(
            // bytes: self.messagePointer.advanced(by: 48 + self.messageContentOffset),
            // count: self.messageSize)
        // let message = String.init(data: messageData, encoding: String.Encoding.utf8)
        // print(message!)
        
        // print(NSHomeDirectory())
        let directPath = "\(NSHomeDirectory())/Documents/Direct"
        let imagePath = "\(directPath)/ikea.jpg"
        let fileHandle = FileHandle.init(forWritingAtPath: imagePath)
        fileHandle?.seekToEndOfFile()
        
        
        // let image = UIImage.init(data: fileData)
//         let imageData = UIImageJPEGRepresentation(image!, 1.0)
        
        
        fileHandle?.write(fileData)
        //fileHandle?.write(imageData!)
        // let createImageStat = FileManager.default.createFile(atPath: imagePath, contents: UIImageJPEGRepresentation(image!, 1), attributes: nil)
        // print(createImageStat)
        
        

        //let createImageStat = FileManager.default.createFile(atPath: imagePath, contents: UIImageJPEGRepresentation(image!, 1.0), attributes: nil)
        
        // let createImageStat = FileManager.default.createFile(atPath: imagePath, contents: Data(), attributes: nil)
        // print(createImageStat)
        // self.responsToServer()
        
        
        // var iterator = bufferPointer.makeIterator()
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        // print(Character.init(Unicode.Scalar(iterator.next()!)))
        
//        while true {
//            let u = iterator.next()!
//            if u > 0 {
//                lengthData.append(u)
//            } else {
//                break
//            }
//        }
        
        // bufferPointer.filter { (u) in
        //     lengthData.append(u)
        //     if Character.init(Unicode.Scalar(u)) == "}" {
        //         print("Enter here ")
        //     }
        //     print(Character.init(Unicode.Scalar(u)))
        //     return true
        // }
        
        // let singleMessageLength = Data.init(bytes: (self.messagePointer.advanced(by: 48)), count: 1 << 2)
//        let msg = String.init(data: lengthData, encoding: String.Encoding.utf8)
//        print(msg!)
    }
    
    
    func responsToServer() {
        var array: [UInt8]  = [69, 110, 100]
        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &array, count: array.count)
        var dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: array.count)
        dataPtr = arrayPtr.baseAddress!
        let sendData = CFDataCreate(kCFAllocatorDefault, dataPtr, 10)!
        CFSocketSendData(self.socket, self.address, sendData, CFTimeInterval(3.0))
    }
    
}

var count: Int = 1

func notificationFromServer(_ address: UnsafeRawPointer, _ socket: CFSocket, _ addressData: CFData) {
    count = count + 1
    let message = message_box(address, socket, addressData)
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
                    notificationFromServer(serverMessage!, socket!, addressData!)
                    
                    
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
                     let buffer = UnsafeRawBufferPointer.init(start: serverMessage, count: 18886)
                    // init(bytes: UnsafeRawPointer, count: Int)
                    // init<SourceType>(buffer: UnsafeBufferPointer<SourceType>)
                    // init<SourceType>(buffer: UnsafeMutableBufferPointer<SourceType>)
                    
                    let bytelen = buffer[24...25]
                    // print(bytelen)
                    let array = bytelen.map({ (c) -> UInt8 in
                        // print(c)
                        return c
                    })
                    var value : UInt32 = 0
                    let data = NSData(bytes: array, length: 2)
                    data.getBytes(&value, length: 2)
                    value = UInt32(littleEndian: value)
                    // print(value) // 14

                    
                    // print(buffer.count)
                    // print(serverMessage!)         // 输出的内容形式如下：0x00006000000bc680
                    // print(buffer.baseAddress!)    // 输出的内容形式如下：0x00006000000bc680
                    // print(buffer.isEmpty)
                    // print(buffer.sorted())
                    
                     let charArray = buffer.map({ (c) -> Character in
                          // print(Character.init(Unicode.Scalar(c)))
                          return Character.init(Unicode.Scalar(c))
                     })
                     let uint8Array = buffer.map({ (c) -> UInt8 in
                         // print(Character.init(Unicode.Scalar(c)))
                         return c
                     })
                     // print(charArray)
                    // print(uint8Array)
//                    print("\n")
                    print("\n")
                    
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
