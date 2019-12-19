import Combine
import UIKit

check1("empty", publisher: Empty<Int, SampleError>())

//---------Publisher--------
check("Empty") {
    Empty<Int, SampleError>()
}

check("Just") {
    Just("Hello SwiftUI")
}

check("Sequence") {
    Publishers.Sequence<[Int], Never>(sequence: [1, 2, 3])
}

check("Array") {
    [1, 2, 3].publisher
}

check("Map") {
    [1, 2, 3]
        .publisher
        .map { $0 * 2 }
}

check("Map Just") {
    Just(7)
        .map { $0 * 2 }
}

check("Reduce") {
    [1, 2, 3, 4, 5]
        .publisher
        .reduce(0, +)
}

check("Scan") {
    [1, 2, 3, 4, 5]
        .publisher
        .scan(0, +)
}

check("Compact Map") {
    ["1", "2", "3", "cat", "5"]
        .publisher
        .compactMap { Int($0) }
}

check("Compact Map By Filter") {
    ["1", "2", "3", "cat", "5"]
        .publisher
        .map { Int($0) }
        .filter { $0 != nil }
        .map { $0! }
}

check("Flat Map 1") {
    [[1, 2, 3], ["a", "b", "c"]]
        .publisher
        .flatMap { $0.publisher }
}

check("Flat Map 2") {
    ["A", "B", "C"]
        .publisher
        .flatMap { (letter) in
            [1, 2, 3]
            .publisher
                .map { "\(letter)\($0)" }
        }
}

check("Remove Duplicates") {
    ["S", "Sw", "Sw", "Sw", "Swi", "Swi", "Swift"]
        .publisher
        .removeDuplicates()
}

//---------错误处理--------

check("Fail") {
    Fail<Int, SampleError>(error: .sampleError)
}

check("Map Error") {
    Fail<Int, SampleError>(error: .sampleError)
        .mapError { _ in MyError.myError }
}

check("Throw") {
    ["1", "2", "swift", "4"]
        .publisher
        .tryMap { (s) -> Int in
            if let result = Int(s) {
                return result
            }
            throw MyError.myError
        }
}

check("Replace Error") {
    ["1", "2", "swift", "4"]
        .publisher
        .tryMap { (s) -> Int in
            if let result = Int(s) {
                return result
            }
            throw MyError.myError
        }
        .replaceError(with: -1)
}

check("Catch with Just") {
    ["1", "2", "swift", "4"]
        .publisher
        .tryMap { (s) -> Int in
            if let result = Int(s) {
                return result
            }
            throw MyError.myError
        }
        .catch { (error) in
            Just(-1)
        }
}

check("Catch with Another Publisher") {
    ["1", "2", "swift", "4"]
        .publisher
        .tryMap { (s) -> Int in
            if let result = Int(s) {
                return result
            }
            throw MyError.myError
        }
        .catch { (error) in
            [-1, -2, -3].publisher
        }
}

check("Catch and Continue") {
    ["1", "2", "swift", "4"]
    .publisher
        .flatMap { (s) in
            Just(s)
                .tryMap { (temp) in
                    if let result = Int(temp) {
                        return result
                    }
                    throw MyError.myError
                }
                .catch { (error) in
                    Just(-1)
                }
        }
}

let p1 = [[1, 2, 3], [4, 5, 6]].publisher.flatMap { $0.publisher }
//Publishers.FlatMap<Publishers.Sequence<[Int], Never>, Publishers.Sequence<[[Int]], Never>>

let p1_ = Publishers.FlatMap(upstream: [[1, 2, 3], [4, 5, 6]].publisher, maxPublishers: .unlimited) { $0.publisher }
//Publishers.FlatMap<Publishers.Sequence<[Int], Never>, Publishers.Sequence<[[Int]], Never>>

let p2 = p1.map { $0 * 2}
// Publishers.Map<Publishers.FlatMap<Publishers.Sequence<[Int], Never>, Publishers.Sequence<[[Int]], Never>>, Int>

let p2_ = Publishers.Map(upstream: p1_) { $0 * 2}
//Publishers.Map<Publishers.FlatMap<Publishers.Sequence<[Int], Never>, Publishers.Sequence<[[Int]], Never>>, Int>

let p3 = p2.eraseToAnyPublisher()
//AnyPublisher<Int, Never>

[1, 2, 3].publisher.map { $0 * 2 }

Just(10).map { String($0) }

check("Filter") {
    [1, 2, 3, 4, 5]
        .publisher
        .filter { $0 % 2 == 0 }
}

check("Contains") {
    [1, 2, 3, 4, 5]
        .publisher
        .print("[Original]")
        .contains { $0 == 3 }
}

//check("TimerPublish") {
//    [1: "A", 2: "B", 3: "C"]
//        .timerPublisher
//}

//check("TimerPublish Merge") {
//    [1: "A", 3: "C"]
//        .timerPublisher
//        .merge(with: [2: "B", 4: "D"].timerPublisher)
//}

//---------Passthrough--------
//let s1 = check("Subject") { () -> PassthroughSubject<Int, Never> in
//    let subject = PassthroughSubject<Int, Never>()
//    delay(1) {
//        subject.send(1)
//        delay(1) {
//            subject.send(2)
//            delay(1) {
//                subject.send(completion: .finished)
//            }
//        }
//    }
//    return subject
//}

//---------Merge--------
//let subject_example1 = PassthroughSubject<Int, Never>()
//let subject_example2 = PassthroughSubject<Int, Never>()
//
//check("Subject Order") {
//    subject_example1.merge(with: subject_example2)
//}
//
//subject_example1.send(20)
//subject_example2.send(1)
//subject_example1.send(40)
//subject_example1.send(60)
//subject_example2.send(1)
//subject_example1.send(80)
//subject_example1.send(100)
//subject_example1.send(completion: .finished)
//subject_example2.send(completion: .finished)

//---------Zip--------
let subject1 = PassthroughSubject<Int, Never>()
let subject2 = PassthroughSubject<String, Never>()

//check("Zip") {
//    subject1.zip(subject2)
//}

subject1.send(1)
subject2.send("A")
subject1.send(2)
subject2.send("B")
subject2.send("C")
subject2.send("D")
subject1.send(3)
subject1.send(4)
subject1.send(5)
subject1.send(completion: .finished)
subject2.send(completion: .finished)

//---------CombineLatest--------
let subject3 = PassthroughSubject<String, Never>()
let subject4 = PassthroughSubject<String, Never>()

check("Combine Latest") {
    subject3.combineLatest(subject4)
}

subject3.send("1")
subject4.send("A")
subject3.send("2")
subject4.send("B")
subject4.send("C")
subject4.send("D")
subject3.send("3")
subject3.send("4")
subject3.send("5")
subject3.send(completion: .finished)
subject4.send(completion: .finished)

//---------Future--------
func loadPage(url: URL, handle: @escaping (Data?, URLResponse?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        handle(data, response, error)
    }.resume()
}

let future = check("Future") {
    Future<(Data, URLResponse), Error> { promise in
        loadPage(url: URL(string: "https://apple.com")!) { (data, response, error) in
            if let data = data, let response = response {
                promise(.success((data, response)))
            } else {
                promise(.failure(error!))
            }

        }
    }
}
