import SwiftUI

struct CourseItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let subject: String
}

struct EducationalMapMarker: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let title: String
    let description: String?
    
    init(latitude: Double, longitude: Double, title: String, description: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.description = description
    }
}

extension EducationalMapMarker {
    static var moscowEducationalInstitutions: [EducationalMapMarker] {
        return [
            EducationalMapMarker(
                latitude: 55.703777,
                longitude: 37.528973,
                title: "МГУ им. Ломоносова",
                description: "Ведущий университет России. Фундаментальное образование."
            ),
            EducationalMapMarker(
                latitude: 55.670205,
                longitude: 37.482731,
                title: "МГИМО",
                description: "Международные отношения и дипломатия."
            ),
            EducationalMapMarker(
                latitude: 55.754588,
                longitude: 37.621590,
                title: "НИУ ВШЭ",
                description: "Экономика и социальные науки."
            ),
            EducationalMapMarker(
                latitude: 55.929723,
                longitude: 37.518611,
                title: "МФТИ",
                description: "Физтех - ведущий технический вуз."
            ),
            EducationalMapMarker(
                latitude: 55.800278,
                longitude: 37.708611,
                title: "МАИ",
                description: "Авиация и космонавтика."
            ),
            EducationalMapMarker(
                latitude: 55.731154,
                longitude: 37.603090,
                title: "РЭУ им. Плеханова",
                description: "Экономика и бизнес-образование."
            ),
            EducationalMapMarker(
                latitude: 55.786667,
                longitude: 37.598611,
                title: "МГТУ им. Баумана",
                description: "Техническое образование мирового уровня."
            )
        ]
    }
}

struct Question {
    let text: String
    let answer: String
    let subject: String
}
