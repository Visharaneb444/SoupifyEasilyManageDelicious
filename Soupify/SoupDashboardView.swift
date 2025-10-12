import SwiftUI


@available(iOS 14.0, *)
struct SoupDashboardView: View {
    @StateObject private var dataStore = SoupDataStore()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.1), Color.orange.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        HeaderView(dataStore: dataStore)
                        
                    
                        VStack(spacing: 20) {
                            
                            BigDashboardCard(title: "Soup Recipes", icon: "fork.knife", color: Color.orange) {
                                RecipeListView(dataStore: dataStore)
                            }
                            .shadow(color: Color.orange.opacity(0.3), radius: 15, x: 0, y: 8)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                
                                SmallDashboardCard(title: "Ingredients", icon: "leaf.fill", color: Color.green) {
                                    IngredientListView(dataStore: dataStore)
                                }
                                
                                SmallDashboardCard(title: "Favorites", icon: "heart.fill", color: Color.red) {
                                    FavoriteEntryListView(dataStore: dataStore)
                                }
                                
                                SmallDashboardCard(title: "Reminders", icon: "bell.fill", color: Color.purple) {
                                    CookingReminderListView(dataStore: dataStore)
                                }
                                
                                SmallDashboardCard(title: "Searches", icon: "magnifyingglass.circle.fill", color: Color.blue) {
                                    SearchQueryListView(dataStore: dataStore)
                                }
                                
                                GridItemView {
                                    SmallDashboardCard(title: "Measurements", icon: "ruler.fill", color: Color.red) {
                                        MPListView(dataStore: dataStore)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Soup Dashboard")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}


private struct GridItemView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
    }
}


@available(iOS 14.0, *)
struct BigDashboardCard<Destination: View>: View {
    var title: String
    var icon: String
    var color: Color
    var destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title2).bold()
                        .foregroundColor(.primary)
                    
                    Text("Explore the complete collection.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(color)
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(
                // Glass-morphism effect
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.6))
                        .background(Color.white.opacity(0.2)) // Base color for blur
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                    // Blur effect
                    BlurView(style: .systemThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
            )
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default NavigationLink styling
    }
}

/// The smaller grid cards, also using a glass-morphism style.
@available(iOS 14.0, *)
struct SmallDashboardCard<Destination: View>: View {
    var title: String
    var icon: String
    var color: Color
    var destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
                    .padding(8)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.white.opacity(0.7))
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    
                    BlurView(style: .systemThinMaterialLight)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
            )
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

@available(iOS 14.0, *)
struct HeaderView: View {
    @ObservedObject var dataStore : SoupDataStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome Back, Soup Chef!")
                .font(.largeTitle).bold()
                .foregroundColor(.black.opacity(0.8))
            
                
        }
        .padding(.horizontal, 5)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


