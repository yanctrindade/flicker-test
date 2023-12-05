import Foundation

struct FlickrResponse: Codable, Equatable {
    let title: String
    let link: URL
    let description: String
    let modified: String
    let generator: String
    let items: [FlickerPhotoItem]
}

struct FlickerPhotoItem: Codable, Hashable {
    let title: String
    let link: URL
    let media: FlickerMedia
    let dateTaken: String
    let published: String
    let author: String
    let authorId: String
    let tags: String
    let description: String
    
    func dateTakeFormatted() -> String {
        formmatDateFromString(dateTaken) ?? ""
    }
    
    func publishedDateFormatted() -> String {
        formmatDateFromString(published) ?? ""
    }
    
    private func formmatDateFromString(_ dateInput: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // POSIX locale for fixed-format date strings

        if let date = inputFormatter.date(from: dateInput) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

struct FlickerMedia: Codable, Hashable {
    let m: URL
}
