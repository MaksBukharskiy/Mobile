import SwiftUI

struct CoursesScreen: View {
    @State private var courses: [CourseItem] = []
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Курсы")
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.brandDarkGray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                .padding(.top, 61)
            
            Text("Для прохождения теста выберите предмет, который вы сейчас изучаете")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 168/255, green: 170/255, blue: 172/255))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                .padding(.top, 8)
            
            NavigationLink(destination: MapScreen().navigationBarHidden(true)) {
                Text("Карта")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandRed)
                    .cornerRadius(100)
            }
            .padding(.horizontal, 21)
            .padding(.top, 24)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(courses) { course in
                        NavigationLink(destination: TestScreen(subject: course.subject).navigationBarHidden(true)) {
                            CourseCardView(course: course)
                                .padding(.horizontal, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadCoursesFromDatabase()
        }
    }
    
    private func loadCoursesFromDatabase() {
        courses = DatabaseManager.shared.getAllCourses()
        print("Displaying \(courses.count) courses on screen")
    }
    
    
    
    struct CourseCardView: View {
        let course: CourseItem
        
        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: getSystemImage(for: course.imageName))
                    .font(.system(size: 24))
                    .foregroundColor(.brandRed)
                    .frame(width: 60, height: 60)
                    .background(Color.brandLightGray)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(course.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.brandDarkGray)
                        .lineLimit(1)
                    
                    Text(course.description)
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 107/255, green: 107/255, blue: 107/255))
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.brandGray)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
        }
        
        private func getSystemImage(for imageName: String) -> String {
            switch imageName {
            case "discrete_math": return "function"
            case "probability": return "chart.bar"
            case "calculus": return "chart.xyaxis.line"
            case "algebra": return "square.grid.3x3"
            case "programming": return "laptopcomputer"
            case "physics": return "atom"
            case "chemistry": return "testtube.2"
            default: return "book"
            }
        }
    }
}
