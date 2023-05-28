//
//  ProductDetailView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/05/20.
//

import SwiftUI

struct ProductDetailView: View {
    
    let mock_picks = ["mock_table", "mock_chair_2"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        GeometryReader { geometry in
            
            ScrollView(showsIndicators: true) {
                VStack(spacing: 0) {
                    Group {
                        Image("mock_table")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.width)
                        
                        Spacer()
                            .frame(height: 24)
                        
                        productInfoView
                        
                        Spacer()
                            .frame(height: 48)
                        
                        productIntroView
                        
                        Spacer()
                            .frame(height: 16)
                        
                        // 소개 사진
                        VStack(spacing: 14) {
                            ForEach(mock_picks, id: \.self) { pic in
                                Image(pic)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width - 48, height: geometry.size.width - 48)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 48)
                    }
                    
                    Group {
                        // 다각도 이미지
                        HStack {
                            Text("다각도 이미지")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.Common.primaryDarkTextColor)
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 16)
                        
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(0..<4, id: \.self) { _ in
                                Image("mock_table")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width / 2 - 26, height: geometry.size.width / 2 - 26)
                            }
                        }
                        Spacer()
                            .frame(height: 48)
                    }
                    .padding([.leading, .trailing], 24)
                    
                    // 상세정보
                    Group {
                        
                        HStack {
                            Text("상세정보")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.Common.primaryDarkTextColor)

                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 16)
                        
                        VStack(spacing: 6) {
                            ZStack {
                                HStack {
                                    Text("Material")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.Common.subtextDarkColor)
                                    Spacer()
                                    Text("ABS, Silicon")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.Common.primaryDarkTextColor)
                                }
                                HStack(spacing: 0) {
                                    Spacer()
                                        .frame(width: 90)
                                    Rectangle()
                                        .foregroundColor(.Common.subtextColor)
                                        .frame(width: 1, height: 14)
                                    Spacer()
                                }
                            }
                            
                            Rectangle()
                                .foregroundColor(.Common.subtextColor)
                                .frame(height: 1)
                        }
                        
                        Spacer()
                            .frame(height: 16)
                        
                        VStack(spacing: 6) {
                            ZStack {
                                HStack {
                                    Text("Size")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.Common.subtextDarkColor)
                                    Spacer()
                                    Text("297*420*320")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.Common.primaryDarkTextColor)
                                }
                                HStack(spacing: 0) {
                                    Spacer()
                                        .frame(width: 90)
                                    Rectangle()
                                        .foregroundColor(.Common.subtextColor)
                                        .frame(width: 1, height: 14)
                                    Spacer()
                                }
                            }
                            
                            Rectangle()
                                .foregroundColor(.Common.subtextColor)
                                .frame(height: 1)
                        }
                                                
                        Spacer()
                            .frame(height: 16)

                        VStack(spacing: 6) {
                            ZStack {
                                HStack {
                                    Text("Period")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.Common.subtextDarkColor)
                                    Spacer()
                                    Text("2022/10/11 ~ 2022/12/13")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.Common.primaryDarkTextColor)
                                }
                                HStack(spacing: 0) {
                                    Spacer()
                                        .frame(width: 90)
                                    Rectangle()
                                        .foregroundColor(.Common.subtextColor)
                                        .frame(width: 1, height: 14)
                                    Spacer()
                                }
                            }
                            
                            Rectangle()
                                .foregroundColor(.Common.subtextColor)
                                .frame(height: 1)
                        }
                    }
                    .padding([.leading, .trailing], 24)
                    
                    Spacer()
                        .frame(height: 48)
                    
                    // 작가의 다른 작품
                    Group {
                        HStack {
                            Text("작가의 다른 작품")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.Common.primaryDarkTextColor)

                            Spacer()
                            
                            Button {
                                print("전체보기")
                            } label: {
                                HStack(spacing: 0) {
                                    Text("전체보기")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.Common.subtextDarkColor)
                                    Image("icon_chevron_right")
                                }
                            }

                        }
                        Spacer()
                            .frame(height: 16)
                        
//                        LazyVGrid(columns: columns, spacing: 14) {
//                            ForEach(0..<4, id: \.self) { _ in
//                                RecentProductItem(item: <#T##RecentProductItemModel#>)
//                                    .frame(width: (geometry.size.width - 62) / 2, height: (geometry.size.width - 62) / 2 + 48)
//                            }
//                        }
                    }
                    .padding([.leading, .trailing], 24)
                }
            }
        }
    }
}

extension ProductDetailView {
    var productInfoView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("서랍형 탁자")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.Common.primaryDarkTextColor)
                
                Spacer()
                
                Image("icon_heart_fill")
            }
            
            Spacer()
                .frame(height: 11)
            
            HStack(spacing: 4) {
                ForEach(["힙한", "귀여운", "모던한"], id: \.self) { data in
                    Text(data)
                        .foregroundColor(Color.Common.subtextDarkColor)
                        .font(.system(size: 14, weight: .regular))
                        .padding([.leading, .trailing], 8)
                        .padding([.top, .bottom], 4)
                        .background(Color.Common.primaryTextColor)
                        .cornerRadius(4)
                }
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 12)
            
            HStack {
                Spacer()
                
                Text("100,000원")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.Common.primaryDarkTextColor)
            }
            
            Spacer()
                .frame(height: 16)
            
            Button {
                print("작가")
            } label: {
                HStack {
                    Image("mock_artist_square")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                    
                    Spacer()
                        .frame(width: 14)
                    
                    Text("작가ㅣ작가이름")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.Common.primaryDarkTextColor)
                    Spacer()
                    Image("icon_chevron_right")
                }
                .padding([.all], 10)
                .background(Color.Common.primaryTextColor)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.Common.subtextColor, lineWidth: 1)
                )
                
            }

        }
        .padding([.leading, .trailing], 24)
    }
    
    var productIntroView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Text("작품 소개")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.Common.primaryDarkTextColor)
                Image("tips_badge")
                Spacer()
            }
            .padding([.leading], 24)
            Spacer()
                .frame(height: 16)
            HStack {
                Rectangle()
                    .foregroundColor(.Common.primaryDarkTextColor)
                    .frame(width: 40, height: 2)
                Spacer()
            }
            .padding([.leading], 24)

            Spacer()
                .frame(height: 16)
            Text("본작품은이러이러한가치가있고어떤 것을의도하여정말좋다라는것입니본작품은이러이러한가치가있고어떤것을의도하여정본 작품은이러이러한가치가있고어떤 것을의도하여정말좋다라")
                .multilineTextAlignment(.leading)
                .padding([.leading, .trailing], 24)
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView()
    }
}
