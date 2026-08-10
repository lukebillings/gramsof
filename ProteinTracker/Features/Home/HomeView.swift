import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            Color.clear
                .navigationTitle("Protein Tracker")
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
