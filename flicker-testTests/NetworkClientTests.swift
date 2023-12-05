import XCTest
@testable import flicker_test

class MockNetworkClient: NetworkClient {
    
    func fetchPhotos(with tags: String, completion: @escaping (Result<flicker_test.FlickrResponse, flicker_test.NetworkError>) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(flicker_test.FlickrResponse.self, from: expectedMockResponseData)
            completion(.success(response))
        } catch let error {
            completion(.failure(NetworkError.requestError(error)))
        }
    }

}

final class NetworkClientTests: XCTestCase {

    func testMockEndpoint() throws {
        let tags = "porcupine"
        let expectation = self.expectation(description: "Mock Data should be fetched successfully")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let expectedResponse = try! jsonDecoder.decode(flicker_test.FlickrResponse.self, from: expectedMockResponseData)

        let networkClient = MockNetworkClient()
        networkClient.fetchPhotos(with: tags) { result in
            guard case let .success(data) = result else {
                XCTFail()
                return
            }
            XCTAssertEqual(expectedResponse, data)
            XCTAssertEqual(data.items.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
}
                                                       
public let expectedMockResponseData = """
{
    "title": "Recent Uploads tagged porcupine",
    "link": "https://www.flickr.com/photos/tags/porcupine/",
    "description": "",
    "modified": "2023-12-01T01:47:12Z",
    "generator": "https://www.flickr.com",
    "items": [
        {
            "title": "Cincinnati Zoo 11-30-23-01265",
            "link": "https://www.flickr.com/photos/djjamphoto/53367684078/",
            "media": {
                "m": "https://live.staticflickr.com/65535/53367684078_6d6f406982_m.jpg"
            },
            "date_taken": "2023-11-30T15:35:39-08:00",
            "description": "",
            "published": "2023-12-01T01:47:12Z",
            "author": "nobody@flickr.com ('joemastrullo')",
            "author_id": "124191108@N08",
            "tags": "cincinnati zoo botanical garden violet baby porcupine"
        }
    ]
}
""".data(using: .utf8)!
                                                       
