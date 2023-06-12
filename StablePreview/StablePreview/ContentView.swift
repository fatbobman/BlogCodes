import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            ForEach(viewModel.items) { item in
                Text(verbatim: item.name)
            }
        }
        .padding()
    }
}

typealias Item = ContentView.Item

extension ContentView {
    final class ViewModel: ObservableObject {
        let items: [Item] = [
            Item(name: "first"),
            Item(name: "second"),
        ]
        func select(_: Item) {
            // implement
        }
    }

    struct Item: Identifiable {
        let name: String
        var id: String { name }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
