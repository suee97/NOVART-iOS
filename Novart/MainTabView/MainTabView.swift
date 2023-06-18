//
//  MainTabView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection = 0
    @State private var hasNewNotification = true
    @StateObject var discoverViewModel = DiscoverViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @State private var isShowingSearch = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ZStack(alignment: .top) {
                    VStack {
                        Spacer()
                            .frame(height: 63)
                        HomeView(viewModel: homeViewModel)
                    }
                    
                    VStack {
                        homeNavigationBar
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
                .tabItem {
                    Image(selection == 0 ? "home_icon_selected" : "home_icon_deselected")
                }
                .tag(0)
                
                
                ZStack(alignment: .top) {
                    VStack {
                        Spacer()
                            .frame(height: 63)
                        DiscoverView(viewModel: discoverViewModel)
                    }
                    
                    VStack {
                        discoverNavigationBar
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
                .tabItem {
                    Image(selection == 1 ? "discover_icon_selected" : "discover_icon_deselected")
                }
                .tag(1)
                
                MyPageView()
                    .tabItem {
                        Image(selection == 2 ? "mypage_icon_selected" : "mypage_icon_deselected")
                    }
                    .tag(2)
            }
        }
        
    }
    
    var homeNavigationBar: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 24)
                titleImage
                Spacer()
                notiItem
                Spacer()
                    .frame(width: 16)
                searchItem
                
                Spacer()
                    .frame(width: 24)
            }
            .background(Color.white)
            .frame(height: 23)
            Spacer()
                .frame(height: 20)
        }
        .frame(height: 63) // Adjust the height of the custom navigation bar
        
    }
    
    var discoverNavigationBar: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                HStack(spacing: 0) {
                    Spacer()

                    notiItem
                    Spacer()
                        .frame(width: 16)
                    searchItem
                    
                    Spacer()
                        .frame(width: 24)
                }
                .background(Color.white)
                .frame(height: 23)
                Text("둘러보기")
                    .foregroundColor(Color.Common.primaryDarkTextColor)
                    .font(.system(size: 16, weight: .bold))
            }
            Spacer()
                .frame(height: 20)
        }
        .frame(height: 63) // Adjust the height of the custom navigation bar
        
    }
    
    var titleImage: some View {
        Image("novart_title_logo")
    }
    
    
    var searchItem: some View {
        NavigationLink(destination: SearchView(isShowing: $isShowingSearch), isActive: $isShowingSearch) {
            Image("icon_search")

        }
    }
    
    var notiItem: some View {
        Button(action: {
            print("noti")
        }) {
            if hasNewNotification {
                Image("icon_noti_on")
            } else {
                Image("icon_noti_off")
            }
        }
            .buttonStyle(NoHighlightButtonStyle())
    }
}
