import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let rwUrl = URL(string: "https://www.raywenderlich.com")!

var subscriptions = Set<AnyCancellable>()

//example(of: "shared") {
//	let shared = URLSession.shared
//		.dataTaskPublisher(for: rwUrl)
//		.map(\.data)
//		.print("shared")
//		.share()
//	
//	print("subscription first")
//	
//	let subscription1 = shared.sink(receiveCompletion: { _ in }, receiveValue: {
//		print("subscription received: '\($0)'")
//	})
//	.store(in: &subscriptions)
//	
////	print("subscription second")
//	
////	let subscription2 = shared.sink(receiveCompletion: { _ in }, receiveValue: {
////		print("subscription2 received: '\($0)'")
////	})
////		.store(in: &subscriptions)
//	
//	var subscription2: AnyCancellable? = nil
//	DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//		print("subscription second")
//		subscription2 = shared.sink(receiveCompletion: { _ in }, receiveValue: {
//			print("subscription2 received: '\($0)'")
//		})
//	}
//}

example(of: "multicast") {
	let subject = PassthroughSubject<Data, URLError>()
	let multicasted = URLSession.shared
		.dataTaskPublisher(for: rwUrl)
		.map(\.data)
		.print("shared")
		.multicast(subject: subject)
	
	multicasted.sink(receiveCompletion: { _ in },
									 receiveValue: { print("subscription1 received '\($0)'") })
	
	multicasted.sink(receiveCompletion: { _ in },
									 receiveValue: { print("subscription2 received '\($0)'") })
	
	multicasted.connect()
	subject.send(Data())
	
}

/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
