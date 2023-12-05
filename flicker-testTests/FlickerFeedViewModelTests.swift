import XCTest
@testable import flicker_test

class FlickerFeedViewModelTests: XCTestCase {
    
    var viewModel: FlickerFeedViewModel!
    var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        viewModel = FlickerFeedViewModel(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkClient = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state, .initial)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(viewModel.searchText, "")
    }
    
    func testFetchImages() throws {
        viewModel.searchText = "porcupine"
        viewModel.send(action: .fetchImages(text: viewModel.searchText))
        XCTAssertEqual(viewModel.state, .loading)
        XCTAssertEqual(viewModel.items.count, 0)
    }
    
    func testFetchImagesWithEmptyString() throws {
        viewModel.searchText = ""
        viewModel.send(action: .fetchImages(text: viewModel.searchText))
        XCTAssertEqual(viewModel.state, .initial)
        XCTAssertEqual(viewModel.items.count, 0)
    }

}
