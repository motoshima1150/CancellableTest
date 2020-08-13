import Cocoa
import Combine

class AAAService {
    func fetch(query: String) -> Future<String, Error> {
        Future<String, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                promise(.success("Process \(query)"))
            }
        }
    }
}

class BBBVieModel {

    var cancellables = Set<AnyCancellable>()
    let service = AAAService()

    func someProcess(query: String) {
        service.fetch(query: query).sink(receiveCompletion: { completion in
            print("receiveCompletion :\(completion)")
        }) { (value) in
            print("value :\(value)")
        }.store(in: &cancellables)
    }
}

let viewModel = BBBVieModel()
viewModel.someProcess(query: "A")
print("Cancellables count :\(viewModel.cancellables.count)")
viewModel.someProcess(query: "B")
print("Cancellables count :\(viewModel.cancellables.count)")
viewModel.someProcess(query: "C")
print("Cancellables count :\(viewModel.cancellables.count)")
viewModel.someProcess(query: "D")
print("Cancellables count :\(viewModel.cancellables.count)")

DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
    print("Cancellables unreleased count :\(viewModel.cancellables.count)")
}
