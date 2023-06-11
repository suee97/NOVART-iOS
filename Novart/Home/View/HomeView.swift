//
//  HomeView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import Combine
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CatalogView(items: viewModel.catalogItems)
                        .frame(width: geometry.size.width, height: 590)
                    
                    SectionHeaderView(title: "인기 예술품", isLogoEnabled: true)
                        .frame(height: 54)
                    
                    PopularProductView(items: viewModel.popularItems)
                        .padding(.bottom, 32)
                    SectionHeaderView(title: "최근 등록된 예술품", isLogoEnabled: false)
                        .frame(height: 54)
                    
                    RecentProductView(items: viewModel.recentItems)
                        .frame(height: geometry.size.width + 74)
                        .padding(.bottom, 32)
                    
                    SectionHeaderView(title: "작가 소개", isLogoEnabled: true)
                        .frame(height: 54)
                    
                    ArtistIntroView(items: viewModel.artistItems)
                        .frame(height: CGFloat(129 * viewModel.artistItems.count + 28))
                }
                .navigationBarTitleDisplayMode(.inline)
            }

        }
        .onAppear {
            viewModel.fetchHomeItems()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
