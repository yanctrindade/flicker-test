import SwiftUI
import Combine

struct FlickerFeedView: View {
    
    @StateObject private var viewModel = FlickerFeedViewModel()
    @State private var isFirstResponder = false
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                    .padding(.top, 64)
                switch viewModel.state {
                case .initial:
                    showMessage("Find Images using Flicker API\ntyping on search bar !")
                case .fetched:
                    photoGrid
                case .error:
                    showMessage("Ooops! Something goes wrong, try again!")
                case .loading:
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(3)
                    Spacer()
                case .noResults:
                    showMessage("No results found for: \(viewModel.searchText)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
    
    var searchBar: some View {
        TextField("Search", text: $viewModel.searchText)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .onReceive(viewModel.$searchText.debounce(for: .seconds(1), scheduler: RunLoop.main)) { text in
                viewModel.send(action: .fetchImages(text: viewModel.searchText))
            }
            .accessibility(label: Text("SearchBar"))
            .accessibility(hint: Text("Input words to find pictures using flicker API"))
    }
    
    var photoGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(viewModel.items, id: \.self) { item in
                    GridItemView(item: item)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func showMessage(_ text: String) -> some View {
        Group {
            Spacer()
            Text(text)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.headline)
            Spacer()
        }
    }
}

struct GridItemView: View {
    var item: FlickerPhotoItem
    
    var body: some View {
        NavigationLink(destination: FickerPhotoDetailView(item: item)) {
            AsyncImageView(url: item.media.m)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .accessibility(label: Text(item.title))
                .accessibility(hint: Text("Double-tap to view a larger version"))
        }
    }
}

#Preview {
    FlickerFeedView()
}

