import UIKit

struct ProfileEditUserDataModel {
    var nickname: String
    
    var profileFileName: String? = nil
    var profileImage: UIImage? = nil
    var originalProfileImageUrl: String? = nil
    var compressedProfileImageUrl: String? = nil
    
    var backgroundFileName: String? = nil
    var backgroundImage: UIImage? = nil
    var originalBackgroundImageUrl: String? = nil
    var compressedBackgroundImageUrl: String? = nil
    
    var email: String? = nil
    var link: String? = nil
}
