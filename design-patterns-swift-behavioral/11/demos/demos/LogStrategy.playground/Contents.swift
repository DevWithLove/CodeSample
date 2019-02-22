//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Strategy
//: Decouples algorithm implementation details from the type that uses it. Allows changing behavior at runtime.
//:
//: ##  Logger
//: Use different strategies to produce logs.
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation

protocol LogStrategy {
    func log(entry: String)
    func retrieveLogs() -> [String]?
}

final class LoggerContext {
    private var strategy: LogStrategy
    private var logQueue = DispatchQueue(label: "ConsoleLogQueue")
    
    init(strategy: LogStrategy) {
        self.strategy = strategy
    }
    
    func write(entry: String) {
        logQueue.sync {
            strategy.log(entry: entry)
        }
    }
    
    var logs: [String]? {
        var result: [String]? = nil
        logQueue.sync {
            result = strategy.retrieveLogs()
        }
        return result
    }
}

class ConsoleLogStrategy: LogStrategy {
    func log(entry: String) {
        print(entry)
    }
    
    func retrieveLogs() -> [String]? {
        return nil
    }
}

class InMemoryLogStrategy: LogStrategy {
    private var logEntries = [String]()
    
    func log(entry: String) {
        logEntries.append(entry)
    }
    
    func retrieveLogs() -> [String]? {
        return logEntries
    }
}
//: Testing
let logger = LoggerContext(strategy: InMemoryLogStrategy())
logger.write(entry: "Strategy pattern demo")
logger.write(entry: "Cool, isn't it?")

logger.logs?.forEach{ print($0) }
