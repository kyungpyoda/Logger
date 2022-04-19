//
//  Log.swift
//  UtilityModule
//
//  Created by 홍경표 on 2021/08/05.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
    static let fatal = OSLog(subsystem: subsystem, category: "Fatal")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let database = OSLog(subsystem: subsystem, category: "Database")
}

public struct Logger {
    
    private init() {}
    
    private enum Level {
        case debug
        case info
        case error
        case fatal
        case network
        case database
        
        var prefix: String {
            switch self {
            case .debug:
                return "💬Debug"
            case .info:
                return "💡Info"
            case .error:
                return "⚠️Error"
            case .fatal:
                return "🔥Fatal"
            case .network:
                return "📡Network"
            case .database:
                return "💾Database"
            }
        }
        
        var osLog: OSLog {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .error:
                return .error
            case .fatal:
                return .fatal
            case .network:
                return .network
            case .database:
                return .database
            }
        }
    }
    
    private static func log(
        level: Level,
        output: [Any],
        separator: String,
        fileName: String,
        function: String,
        line: Int
    ) {
        #if DEBUG
        let message = "\(toOutput(with: output, separator: separator))"
        let messageInfo = "[\(sourceFileName(filePath: fileName)):#\(line):\(function)]"
        let separator = "------------------------------"
        if #available(iOS 14.0, *) {
            print("\n[\(level.prefix)]", terminator: " ")
            os_log(log: level.osLog, "\(messageInfo)\n>> \(message)\n\(separator)")
            print()
        } else {
            print("\n[\(level.prefix)]", terminator: " ")
            os_log("%@\n>> %@\n%@", log: level.osLog, messageInfo, message, separator)
            print()
        }
        #endif
    }
    
    public static func debug(
        _ items: Any...,
        separator: String = " ",
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .debug, output: items, separator: separator, fileName: fileName, function: function, line: line)
    }
    
    public static func info(
        _ items: Any...,
        separator: String = " ",
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .info, output: items, separator: separator, fileName: fileName, function: function, line: line)
    }
    
    public static func error(
        _ items: Any...,
        separator: String = " ",
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .error, output: items, separator: separator, fileName: fileName, function: function, line: line)
    }
    
    public static func fatal(
        _ items: Any...,
        separator: String = " ",
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .fatal, output: items, separator: separator, fileName: fileName, function: function, line: line)
    }
    
    public static func network(
        _ items: Any...,
        separator: String = " ",
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .network, output: items, separator: separator, fileName: fileName, function: function, line: line)
    }
    
    public static func database(
        _ items: Any...,
        separator: String = " ",
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .database, output: items, separator: separator, fileName: fileName, function: function, line: line)
    }
    
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        let fileName = components.last ?? ""
        return String(fileName.split(separator: ".").first ?? "")
    }
    
    private static func toOutput(with items: [Any], separator: String) -> Any {
        return items.map({ String("\($0)") }).joined(separator: separator)
    }
}
