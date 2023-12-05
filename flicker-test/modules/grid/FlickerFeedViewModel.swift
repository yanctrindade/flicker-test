import Foundation

class FlickerFeedViewModel: ObservableObject {
    
    enum State {
        case initial
        case fetched
        case error
        case noResults
        case loading
    }
    
    enum Action {
        case fetchImages(text: String)
    }
    
    @Published var state: State = .initial
    @Published var items: Array<FlickerPhotoItem>
    @Published var searchText = ""
    
    private let networkClient: NetworkClient
    
    init(items: Array<FlickerPhotoItem> = [], networkClient: NetworkClient = NetworkClientImp()) {
        self.items = items
        self.networkClient = networkClient
    }
    
    func send(action: Action) {
        switch action {
        case let .fetchImages(text):
            fetchPhotosItems(searchTags: text)
        }
    }
    
    private func fetchPhotosItems(searchTags: String) {
        if searchTags.isEmpty {
            state = .initial
            items.removeAll()
            return
        }
        debugPrint("Search triggered for: \(searchTags)")
        state = .loading
        networkClient.fetchPhotos(with: searchTags) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.items.count > 0 {
                        self.state = .fetched
                    } else {
                        self.state = .noResults
                    }
                    self.items = data.items
                }
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.state = .error
                }
            }
        }
    }
}
