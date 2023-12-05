import SwiftUI
import WebKit

struct FickerPhotoDetailView: View {
    
    var item: FlickerPhotoItem
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImageView(url: item.media.m, showDimensions: true, cornerRadius: 10)
                Divider()
                    .foregroundColor(.white)
                Text(item.title)
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.bottom, 16)
                Text("Published: \(item.publishedDateFormatted())")
                    .foregroundColor(.white)
                    .font(.subheadline)
                Text("Author: \(item.author)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.vertical, 16)
                Text("Tags: \(item.tags)")
                    .foregroundColor(.white)
                    .font(.caption)
            }
            .padding()
            .ignoresSafeArea()
        }
        .background(Color.black)
        .navigationBarTitle("Details", displayMode: .inline)
    }

}
