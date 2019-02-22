//: **[Design Pattern in Swift: Behavioral](https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral)**
//:
//: Source Code
//: _ _ _
//: ## Memento
//: Captures the important state of an object without exposing its internal data. The saved state can be used to reset the object if needed.
//:
//: ##  GameSceneManager
//: Create a snapshot of the game’s state. Restore the game to a previous state
//:
//: - Callout(Interested in Swift programming?):
//: Check out my [Swift courses on Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)
//: | [Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)
//: | [Blog](http://www.leakka.com)
import Foundation
import PlaygroundSupport

// GameScene
public final class GameScene {
    private var score: UInt
    private var progress: Float
    private var sessionTime: TimeInterval
    
    lazy private var sessionTimer = Timer.init(timeInterval: 1, repeats: true) { (timer) in
        self.sessionTime += timer.timeInterval
    }
    
    public init() {
        self.score = 0
        self.progress = 0
        self.sessionTime = 0
    }
    
    public func start() {
        RunLoop.current.add(sessionTimer, forMode: RunLoopMode.defaultRunLoopMode)
        sessionTimer.fire()
    }
    
    public var levelScore: UInt {
        get {
            return score
        }
        set {
            score = newValue
        }
    }
    
    public var levelProgress: Float {
        get {
            return progress
        }
        set {
            progress = newValue <= 100 ? newValue : 100
        }
    }
}

extension GameScene: CustomStringConvertible {
    public var description: String {
        return "Level progress \(progress), player score: \(score). Play time \(sessionTime) seconds"
    }
}


protocol Memento {
    associatedtype State
    var state: State { get set }
}

protocol Originator {
    associatedtype M: Memento
    func createMemento() -> M
    mutating func apply(memento: M)
}

protocol Caretaker {
    associatedtype O: Originator
    func saveState(originator: O, identifier: AnyHashable)
    func restoreState(originator: O, identifier: AnyHashable)
}

struct GameMemento: Memento {
    var state: ExternalGameState
}

struct ExternalGameState {
    var playerScore: UInt
    var levelProgress: Float
}

extension GameScene: Originator {
    func createMemento() -> GameMemento {
        let currentState = ExternalGameState(playerScore: score, levelProgress: progress)
        return GameMemento(state: currentState)
    }
    
    func apply(memento: GameMemento) {
        let restoreState = memento.state
        score = restoreState.playerScore
        progress = restoreState.levelProgress
    }
}

public final class GameSceneManager: Caretaker {
    private lazy var snapshots = [AnyHashable: GameMemento]()
    
    public func saveState(originator: GameScene, identifier: AnyHashable) {
        let snapshot = originator.createMemento()
        snapshots[identifier] = snapshot
    }
    
    public func restoreState(originator: GameScene, identifier: AnyHashable) {
        if let snapshot = snapshots[identifier] {
            originator.apply(memento: snapshot)
        }
    }
    
    public init() {}
}

let gameScene = GameScene()
gameScene.start()

let sceneManager = GameSceneManager()
sceneManager.saveState(originator: gameScene, identifier: "initial")
print(gameScene)

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
    gameScene.levelProgress = 55
    gameScene.levelScore = 2500
    
    sceneManager.saveState(originator: gameScene, identifier: "snapshot_1")
    print(gameScene)
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        gameScene.levelProgress = 80
        gameScene.levelScore = 10000
        
        sceneManager.saveState(originator: gameScene, identifier: "snapshot_2")
        print(gameScene)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            sceneManager.restoreState(originator: gameScene, identifier: "initial")
            print("\nRestoring \"initial\"")
            print(gameScene)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                sceneManager.restoreState(originator: gameScene, identifier: "snapshot_2")
                print("\nRestoring \"snapshot_2\"")
                print(gameScene)
                
                PlaygroundPage.current.finishExecution()
            })
        })
    })
}

PlaygroundPage.current.needsIndefiniteExecution = true
