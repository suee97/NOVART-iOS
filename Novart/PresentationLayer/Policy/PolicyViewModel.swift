import Foundation

final class PolicyViewModel {
    
    // 서비스 이용 약관
    private lazy var usageContent: [PolicyChapterModel] = [
        PolicyChapterModel(title: "제1장 총칙", descriptions: ["제1조 (목적)\n본 약관은 플레인(이하 \"컬쳐파인더\")이 제공하는 예술 종합 커뮤니티 애플리케이션 및 관련 제반 서비스(이하 \"컬쳐파인더\")의 이용 조건 및 절차, 이용자와 회사의 권리, 의무, 책임 사항을 규정함을 목적으로 합니다.", "제2조 (정의)\n본 약관에서 사용하는 용어의 정의는 다음과 같습니다.\n\"이용자\"란 본 약관에 동의하고 회사가 제공하는 서비스를 이용하는 회원 및 비회원을 말합니다.\"회원\"이란 회사에 개인정보를 제공하여 회원 등록을 한 자로서, 회사의 정보를 지속적으로 제공 받으며 회사가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.\"비회원\"이란 회원에 가입하지 않고 회사가 제공하는 서비스를 이용하는 자를 말합니다."]),
        PolicyChapterModel(title: "제2장 서비스 이용", descriptions: ["제1조 (이용 계약의 성립)\n이용 계약은 이용자가 약관의 내용에 동의한 후 회원가입 신청을 하고, 회사가 이러한 신청에 대해 승낙함으로써 성립합니다.회사는 이용자의 신청에 대해 서비스 이용을 승낙함을 원칙으로 합니다. 다만, 다음 각 호의 경우에는 승낙을 거부할 수 있습니다.\n﹒실명이 아니거나 타인의 명의를 이용한 경우\n﹒이용자 정보를 허위로 기재하였거나, 회사가 요구하는 내용을 기재하지 않은 경우﹒\n기타 회사가 정한 이용 신청 요건이 충족되지 않은 경우", "제2조 (회원의 의무)\n회원은 관계 법령, 본 약관의 규정, 이용 안내 및 서비스와 관련하여 공지한 주의 사항, 회사가 통지하는 사항 등을 준수하여야 하며, 기타 회사의 업무에 방해되는 행위를 하여서는 안 됩니다.회원은 회사의 사전 승낙 없이 서비스를 이용하여 어떠한 영업 활동도 할 수 없으며, 그 영업 활동의 결과에 대해 회사는 책임을 지지 않습니다. 회원이 본 약관을 위반하여 회사에 손해를 끼친 경우, 해당 회원은 회사에 대하여 모든 손해를 배상할 책임이 있습니다.", "제3조 (서비스의 제공 및 변경)\n회사는 다음과 같은 서비스를 제공합니다.\n﹒예술 작품의 업로드 및 공유\n﹒사용자 간의 소통을 위한 댓글 기능\n﹒작품에 대한 감상평 및 평가\n﹒기타 회사가 정하는 서비스\n회사는 운영상, 기술상의 필요에 따라 제공하는 서비스의 전부 또는 일부를 변경할 수 있으며, 변경 전에 해당 내용을 서비스 화면에 공지합니다. 단, 불가피한 사정으로 사전 공지가 어려운 경우에는 사후에 공지할 수 있습니다.", "제4조 (서비스의 중단)\n회사는 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.\n회사는 제1항의 사유로 서비스 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 일체 배상하지 않습니다."]),
        PolicyChapterModel(title: "제3장 계약 해지 및 이용 제한", descriptions: ["제1조 (회원 탈퇴 및 자격 상실)\n회원은 언제든지 회사에게 회원 탈퇴를 요청할 수 있으며, 회사는 즉시 회원 탈퇴를 처리합니다.\n회원이 다음 각 호의 사유에 해당하는 경우, 회사는 회원 자격을 제한 및 정지 시킬 수 있습니다.\n﹒가입 신청 시에 허위 내용을 등록한 경우\n﹒다른 사람의 서비스 이용을 방해하거나 그 정보를 도용하는 등 전자거래질서를 위협하는 경우\n﹒서비스를 이용하여 법령과 본 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우", "제2조 (손해배상)\n회원은 본인의 귀책사유로 인하여 회사 또는 다른 회원에게 손해를 입힌 경우, 그 손해를 배상할 책임이 있습니다."]),
        PolicyChapterModel(title: "제4장 기타", descriptions: ["제1조 (저작권의 귀속 및 이용 제한)\n회사가 제공하는 서비스, 그에 따른 저작물 및 컨텐츠의 저작권은 회사에 귀속됩니다.이용자는 서비스를 이용함으로써 얻은 정보를 회사의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리 목적으로 이용하거나 제3자에게 이용하게 해서는 안 됩니다.", "제2조 (약관의 해석)\n본 약관의 해석에 관하여는 대한민국의 법령을 기준으로 하며, 서비스 이용 중 발생한 회원과 회사 간의 분쟁에 대해서는 민사소송법상의 관할 법원에 제소할 수 있습니다.", "제3조 (분쟁해결)\n회사와 이용자는 서비스 이용과 관련하여 발생한 분쟁을 원만하게 해결하기 위하여 필요한 모든 노력을 해야 합니다. 제1항의 노력에도 불구하고 분쟁이 해결되지 않을 경우, 회사와 이용자는 대한민국 법령에 따른 법원의 중재를 받아 분쟁을 해결할 수 있습니다.", "제4조 (개인정보보호)\n회사는 이용자의 개인정보 수집 시 서비스 제공에 필요한 최소한의 정보를 수집합니다. 회사는 회원가입 시 또는 서비스 이용 과정에서 이용자로부터 수집한 개인정보를 목적 외의 용도로 이용하거나 제3자에게 제공하지 않습니다. 단, 법령에 의거하거나 이용자의 동의를 받은 경우에는 예외로 합니다. 이용자는 언제든지 회사가 가지고 있는 자신의 개인정보에 대해 열람 및 정정 요청을 할 수 있으며, 회사는 이에 대해 지체 없이 필요한 조치를 취해야 합니다. 회사는 개인정보 보호를 위해 관리자를 최소한으로 한정하며, 개인정보가 유출되거나 손상되지 않도록 안전성 확보에 필요한 기술적, 관리적 대책을 마련하고 있습니다. 회사 또는 그로 인해 개인정보를 취급하는 자는 개인정보의 보호에 관하여 관련 법령, 본 약관에 정의된 책임을 다해야 합니다."]),
        PolicyChapterModel(title: "제5장 마치며", descriptions: ["본 약관은 플레인 예술 종합 커뮤니티 애플리케이션의 서비스 이용과 관련하여 회사와 이용자 간의 권리와 의무, 책임사항 등 중요한 사항을 규정하고 있습니다. 이용자가 본 약관의 내용에 동의함으로써, 플레인 서비스의 회원으로서의 권리를 얻고, 서비스 이용과 관련된 중요한 사항에 대해 인지하게 됩니다. 따라서 이용자는 서비스 이용 전에 반드시 본 약관의 내용을 주의 깊게 검토해야 합니다. 본 약관의 내용 중 이해되지 않는 부분이 있거나, 서비스 이용 중 문의 사항이 발생하는 경우, 회사의 고객 지원 센터로 문의하여 도움을 받을 수 있습니다.\n\n본 약관은 2024년 5월 1일부터 시행됩니다.\n\n플레인 대표이사 (서명)"])]
    
    
    // 개인정보 처리방침
    private lazy var privacyContent: [PolicyChapterModel] = [
        PolicyChapterModel(title: "", descriptions: ["본 개인정보 처리방침은 플레인(이하 \"컬쳐파인더\")이 운영하는 예술 종합 커뮤니티 애플리케이션 및 관련 서비스(이하 \"컬쳐파인더\")에서 이용자의 개인정보를 어떻게 수집, 이용, 공유 및 보호하는지에 대해 설명합니다. 회사는 이용자의 개인정보 보호를 매우 중요시하며, 관련 법령 및 규정을 준수합니다."]),
        PolicyChapterModel(title: "1. 수집하는 개인정보 항목 및 수집 방법", descriptions: ["1.1 수집하는 개인정보 항목\n﹒필수항목:이메일 주소, 비밀번호, 닉네임, 프로필 사진, 출신 학교, 전공\n﹒선택항목:성별, 생년월일, 관심 분야, 배경 사진, 태그\n﹒서비스 이용 과정이나 처리 과정에서 자동으로 생성되어 수집될 수 있는 정보: IP 주소, 쿠키, 서비스 이용 기록, 방문 기록, 불량 이용 기록 등", "1.2 수집 방법\n﹒회사는 회원가입 과정, 서비스 이용 과정, 문의 및 상담 과정에서 이용자로부터 직접 제공받은 정보를 수집합니다.\n﹒또한, 기술적 방법을 통해 이용자가 서비스를 이용하는 과정에서 자동으로 생성되는 정보를 수집할 수 있습니다."]),
        PolicyChapterModel(title: "2. 개인정보의 이용 목적", descriptions: ["회사는 수집된 개인정보를 다음의 목적을 위해 이용합니다.\n﹒회원 관리: 회원제 서비스 이용에 따른 본인 확인, 개인식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 연령 확인, 불만처리 등 민원처리, 고지사항 전달\n﹒서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산\n﹒신규 서비스 개발, 마케팅 및 광고에 활용"]),
        PolicyChapterModel(title: "3. 개인정보의 공유 및 제공", descriptions: ["회사는 원칙적으로 이용자의 사전 동의 없이 개인정보를 외부에 공개하지 않습니다. 단, 다음의 경우에는 예외로 합니다.\n﹒법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우\n﹒서비스 제공에 관한 계약 이행을 위해 필요한 경우\n﹒통계작성, 학술연구 또는 시장조사를 위해 필요한 경우, (단 이 경우에는 개인을 식별할 수 없는 형태로 정보가 제공됩니다.)"]),
        PolicyChapterModel(title: "4. 개인정보의 보유 및 이용 기간", descriptions: ["이용자의 개인정보는 원칙적으로 회원 탈퇴 시 혹은 이용자의 개인정보 삭제 요청 시 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.\n﹒보존 항목: 로그인 기록\n﹒보존 근거: 불법 사용 방지\n﹒보존 기간: 6개월", "또한, 상법, 전자상거래 등에서의 소비자 보호에 관한 법률 등 법령에서 별도의 보존 기간을 정한 경우에는 해당 기간 동안 개인정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며, 보존 기간은 아래와 같습니다.\n﹒계약 또는 청약철회 등에 관한 기록\n    ﹒보존 이유: 전자상거래 등에서의 소비자 보호에 관한 법률\n    ﹒보존 기간: 5년\n﹒대금결제 및 재화 등의 공급에 관한 기록\n    ﹒보존 이유: 전자상거래 등에서의 소비자 보호에 관한 법률\n    ﹒보존 기간: 5년\n﹒전자금융 거래에 관한 기록\n    ﹒보존 이유: 전자금융거래법\n    ﹒보존 기간: 5년\n﹒소비자의 불만 또는 분쟁처리에 관한 기록\n    ﹒보존 이유: 전자상거래 등에서의 소비자 보호에 관한 법률\n    ﹒보존 기간: 3년\n﹒웹사이트 방문 기록\n    ﹒보존 이유: 통신비밀보호법보존\n    ﹒기간: 3개월"]),
        PolicyChapterModel(title: "5. 개인정보의 파기 절차 및 방법", descriptions: [
            """
            회사는 원칙적으로 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체 없이 해당 개인정보를 파기합니다. 파기 절차 및 방법은    다음과 같습니다.
            ﹒파기 절차: 이용자가 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라 일정 기간 저장된 후 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.
            ﹒파기 방법: 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다. 종이 문서에 기록된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.
            """
        ]),
        PolicyChapterModel(title: "6. 이용자의 권리와 그 행사 방법", descriptions: ["이용자는 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며, 회원 탈퇴 또는 동의 철회를 요청할 수 있습니다. 이러한 요청은 회사의 고객센터를 통해 직접 처리할 수 있으며, 회사는 이러한 요청에 대해 지체 없이 필요한 조치를 취합니다."]),
        PolicyChapterModel(title: "7. 개인정보 보호책임자", descriptions: [
            """
            회사는 이용자의 개인정보를 보호하고 개인정보와 관련된 불만을 처리하기 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
            ﹒이름: 양용수
            ﹒직책: 개인정보처리담당자
            ﹒이메일: yongdduddi2@gmail.com
            이용자는 회사의 서비스를 이용하면서 발생하는 모든 개인정보 보호 관련 문의, 불만 처리, 피해 구제 등을 개인정보 보호책임자 및 담당 부서로 신고할 수 있습니다. 회사는 이용자의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다.
            """]),
        PolicyChapterModel(title: "8. 변경에 관한 사항", descriptions: ["본 개인정보 처리방침은 법령, 정책 또는 보안기술의 변경에 따라 내용의 추가, 삭제 및 수정이 있을 수 있으며, 변경된 개인정보 처리방침은 회사의 웹사이트 또는 서비스 내 공지사항을 통해 공지할 것입니다.\n변경된 개인정보 처리방침은 공지 후 즉시 효력이 발생합니다. 이용자들은 웹사이트 방문 시 주기적으로 확인하여, 개인정보 처리방침의 변경사항을 확인하는 것이 좋습니다."]),
        PolicyChapterModel(title: "9. 개인정보의 안전성 확보 조치", descriptions: [
            """
            회사는 개인정보보호법에 따라 다음과 같은 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 취하고 있습니다.
            ﹒내부관리계획의 수립 및 시행
            ﹒개인정보에 대한 접근 제한
            ﹒접근 권한의 관리
            ﹒개인정보의 암호화
            ﹒보안프로그램 설치 및 주기적인 갱신 및 점검
            ﹒개인정보를 처리하는 직원의 최소화 및 교육
            ﹒개인정보에 대한 접근 기록의 보관 및 위반 시의 조치
            ﹒개인정보의 안전한 물리적 보관 장소 확보
            """, "회사는 이용자 개인의 소중한 개인정보를 보호하기 위하여 최선을 다하고 있습니다. 이용자 본인도 개인정보 보호에 주의를 기울여 주시기 바랍니다. 특히, 온라인 환경에서는 아이디와 비밀번호 등 개인정보가 타인에게 유출되지 않도록 주의해야 합니다."
        ]),
        PolicyChapterModel(title: "10. 개인정보 처리방침에 동의합니다.", descriptions: ["회사의 개인정보 처리방침에 대한 내용에 동의하시는 경우, 회원 가입 절차 진행 시 개인정보 처리방침에 동의하는 것으로 간주됩니다.", "본 개인정보 처리방침은 2024년 5월 1일부터 시행됩니다.\n위 예시는 표준적인 개인정보 처리방침의 예시로, 실제 애플리케이션 또는 서비스의 특성에 맞추어 필요한 내용을 추가하거나 수정할 필요가 있습니다. 법률적 요구사항을 충족하기 위해서는 해당 분야의 법률 전문가의 조언을 받는 것이 좋습니다."]),
        PolicyChapterModel(title: "추가 관련 정보", descriptions: ["1. 개인정보의 국제 이전\n데이터의 국제적인 이전이 필요한 경우, 회사는 이용자의 개인정보를 안전하게 보호할 수 있는 국가로만 이전합니다. 이 경우, 해당 국가의 개인정보 보호 수준, 이전 목적 및 이전되는 데이터의 양과 종류, 이용자의 동의 여부 등을 고려하여 이전합니다.", "2. 이용자의 권리 강화\n이용자는 자신의 개인정보에 대해 언제든지 접근, 정정, 삭제, 처리 제한, 그리고 데이터 포터빌리티 권리(개인정보를 다른 조직으로 이전할 수 있는 권리)를 요구할 수 있습니다.", "3. 자동화된 의사결정에 대한 권리\n이용자는 자신에게 법적 효력을 발생시키거나 유사하게 중대한 영향을 미치는 자동화된 의사결정 과정에 대해 동의 없이 포함되지 않을 권리를 가집니다. 해당 과정이 필요한 경우, 회사는 이용자에게 명확한 정보를 제공하고 필요한 경우 이용자의 명시적인 동의를 얻습니다.", "4. 개인정보 침해 대응\n개인정보 침해 사고가 발생한 경우, 회사는 지체 없이 해당 사실을 이용자 및 관련 기관에 통보하며, 발생 가능한 피해를 최소화하기 위한 조치를 취합니다.", "5. 개인정보 보호 교육\n회사는 직원들에게 정기적인 개인정보 보호 교육을 실시하여 개인정보 보호의 중요성을 인식시키고, 개인정보를 안전하게 처리하는 방법을 교육합니다.", "이러한 내용들은 개인정보 처리방침의 일부로 포함될 수 있으며, 이용자들에게 더욱 투명하고 안전한 개인정보 처리 환경을 제공하기 위한 노력의 일환입니다. 각 기업 또는 조직은 자신들의 운영 방식과 이용자들의 요구에 맞는 개인정보 처리방침을 수립하고, 이를 철저히 이행함으로써 개인정보 보호에 대한 신뢰를 구축해야 합니다."])
    ]
    
    
    // 커뮤니티 이용 가이드라인
    private lazy var communityContent: [PolicyChapterModel] = [
        PolicyChapterModel(title: "1. 서론", descriptions: ["플레인은 예술을 사랑하는 모든 이들이 모여 서로의 작품을 공유하고, 의견을 나누며, 영감을 받을 수 있는 플랫폼입니다. 우리는 모든 사용자가 존중받고, 안전하며, 창의적인 환경에서 활동할 수 있도록 커뮤니티 가이드라인을 마련하였습니다. 본 가이드라인은 플레인 커뮤니티 내에서의 상호 작용과 행동 기준을 설정하기 위해 존재합니다."]),
        PolicyChapterModel(title: "2. 존중과 포용", descriptions: ["﹒모든 사용자는 서로를 존중하고 예의를 갖춰야 합니다.\n﹒인종, 성별, 성 정체성, 연령, 국적, 장애, 종교 또는 성적 지향 등에 대한 차별적 또는 혐오 발언을 금지합니다.\n﹒다양성과 포용성을 존중하는 문화를 조성하기 위해 노력해 주세요."]),
        PolicyChapterModel(title: "3. 안전한 커뮤니티", descriptions: ["﹒개인 정보 또는 타인의 개인 정보를 공유하지 마세요.\n﹒폭력, 위협, 괴롭힘 또는 다른 사용자를 위협하는 행위는 금지됩니다.\n﹒불법 행위나 위험한 활동을 장려하거나 조장하는 콘텐츠는 게시할 수 없습니다."]),
        PolicyChapterModel(title: "4. 창의성과 저작권", descriptions: ["﹒자신의 창작물만을 업로드하고, 타인의 저작권을 존중해 주세요.\n﹒타인의 작품을 인용하거나 참조할 때는 반드시 출처를 명시해야 합니다.\n﹒저작권 침해가 의심되는 경우, 즉시 신고하여 주시기 바랍니다."]),
        PolicyChapterModel(title: "6. 가이드라인 위반 조치", descriptions: ["﹒본 가이드라인을 위반하는 사용자는 경고, 임시 정지, 영구 정지 등의 조치를 받을 수 있습니다.\n﹒가이드라인 위반 신고는 언제든지 커뮤니티 관리팀에게 제출할 수 있으며, 모든 신고는 신중하게 검토됩니다.\n﹒가이드라인을 준수하지 않을 경우 다음과 같은 조치가 취해질 수 있습니다. 각 커뮤니티마다 정확한 조치 방법은 다를 수 있으나, 일반적으로 적용되는 조치들을 아래에 소개합니다.\n﹒경고: 처음이거나 경미한 규정 위반의 경우, 경고를 통해 해당 행위에 대한 주의를 촉구합니다. 경고는 구두 또는 서면으로 이루어질 수 있으며, 이용자는 이후 행동을 개선해야 합니다.\n﹒게시물 삭제: 규정을 위반하는 게시물은 관리자 또는 운영진에 의해 사전 통보 없이 삭제될 수 있습니다. 중대한 내용이 포함된 경우, 삭제와 동시에 추가 조치가 이루어질 수 있습니다.\n﹒일시적 계정 정지: 반복적인 규정 위반 또는 중대한 규정 위반의 경우, 일정 기간 동안 계정 사용이 정지될 수 있습니다. 이 기간 동안 이용자는 커뮤니티 활동을 할 수 없으며, 기간은 위반의 심각도에 따라 달라집니다.\n﹒영구적 계정 정지: 매우 심각한 규정 위반 또는 반복적인 규정 위반으로 커뮤니티에 해를 끼친 경우, 해당 이용자의 계정은 영구적으로 정지될 수 있습니다. 이는 커뮤니티로부터 완전히 추방되는 것을 의미하며, 복구는 거의 불가능합니다.\n﹒법적 조치: 불법 행위나 타인의 권리를 침해하는 심각한 경우, 커뮤니티 운영진은 법적 조치를 취할 수 있습니다. 이는 경찰 조사 요청, 소송 제기 등을 포함할 수 있으며, 해당 국가의 법률에 따라 진행됩니다.\n﹒규정 위반에 대한 구체적인 조치는 커뮤니티의 성격, 위반의 심각도, 이전 위반 기록 등에 따라 달라질 수 있습니다. 모든 이용자는 가이드라인을 숙지하고 준수함으로써 건전한 커뮤니티 문화를 함께 만들어 가는 데 기여해야 합니다."]),
        PolicyChapterModel(title: "7. 마치며", descriptions: ["플레인 커뮤니티는 여러분의 참여로 더욱 풍부해집니다. 우리 모두가 서로를 존중하고, 안전하며, 창의적인 환경에서 활동할 수 있도록 노력해 주시기 바랍니다. 감사합니다."])
    ]
    
    private lazy var marketingContent: [PolicyChapterModel] = [
        PolicyChapterModel(title: "", descriptions: ["플레인은 다음과 같은 목적으로 개인정보를 마케팅 및 광고에 활용하고자 합니다. 이에 대한 동의는 선택 사항이며, 동의하지 않으시더라도 서비스 이용에 제한은 없습니다."]),
        PolicyChapterModel(title: "1. 마케팅 및 광고에의 활용 목적", descriptions: ["﹒신제품이나 서비스의 안내\n﹒맞춤형 광고 게재\n﹒이벤트 및 프로모션 참여 기회 제공\n﹒고객 만족도 조사"]),
        PolicyChapterModel(title: "2. 수집 항목", descriptions: ["﹒이름, 사용자 정보, 이메일 주소, 전화번호 등 연락처 정보\n﹒서비스 이용 기록, 방문 기록, 구매 및 결제 기록"]),
        PolicyChapterModel(title: "3. 보유 및 이용 기간", descriptions: ["﹒동의일로부터 5년까지"]),
        PolicyChapterModel(title: "4. 동의 철회", descriptions: ["사용자는 언제든지 마케팅 목적의 개인정보 수집 및 이용에 대한 동의를 철회할 수 있습니다. 동의 철회는 [애플리케이션 내 설정] 또는 고객센터를 통해 요청할 수 있으며, 동의를 철회하더라도 기본적인 서비스 이용에는 영향을 미치지 않습니다."])
    ]
    
    func getPolicyChapters(category: PolicyType) -> [PolicyChapterModel] {
        switch category {
        case .Usage:
            return usageContent
        case .Privacy:
            return privacyContent
        case .Community:
            return communityContent
        case .Marketing:
            return marketingContent
        }
    }
}
