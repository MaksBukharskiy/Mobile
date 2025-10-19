import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            SplashScreen()
        }
    }
}

struct SplashScreen: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var body: some View {
        VStack {
            if isActive {
                LoginScreen()
            } else {
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 51)
                            .fill(Color.brandRed)
                            .frame(width: 120, height: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 51)
                                    .stroke(Color.white, lineWidth: 4)
                            )
                        
                        VStack(spacing: 4) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)
                    
                    VStack(spacing: 8) {
                        Text("ReverseEducation")
                            .font(.system(size: 35, weight: .black))
                            .foregroundColor(.brandDarkGray)
                            .multilineTextAlignment(.center)
                        
                        Text("Учись умнее: персональные курсы, тесты и карта вузов в одном месте")
                            .font(.system(size: 16))
                            .foregroundColor(.brandGray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .opacity(opacity)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.isActive = true
                }
            }
        }
    }
}

struct LoginScreen: View {
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var shouldNavigate = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Вход")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.brandDarkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 50)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Номер телефона")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.brandGray)
                    
                    TextField("", text: $phoneNumber)
                        .padding()
                        .background(Color.brandLightGray)
                        .cornerRadius(12)
                        .keyboardType(.phonePad)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Пароль")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.brandGray)
                    
                    SecureField("", text: $password)
                        .padding()
                        .background(Color.brandLightGray)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 40)
            
            if showError {
                Text(errorMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: {
                    validateInput()
                }) {
                    Text("Войти")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandRed)
                        .cornerRadius(100)
                }
                .padding(.horizontal, 16)
                
                HStack {
                    Text("Еще нет аккаунта?")
                        .font(.system(size: 16))
                        .foregroundColor(.brandGray)
                    
                    NavigationLink(destination: RegistrationScreen().navigationBarHidden(true)) {
                        Text("Регистрация")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.brandDarkGray)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(destination: CoursesScreen().navigationBarHidden(true), isActive: $shouldNavigate) {
                EmptyView()
            }
        )
    }
    
    private func validateInput() {
        if phoneNumber.isEmpty || password.isEmpty {
            errorMessage = "Заполните все поля"
            showError = true
            shouldNavigate = false
        } else if phoneNumber.count < 10 {
            errorMessage = "Некорректный номер телефона"
            showError = true
            shouldNavigate = false
        } else if password.count < 6 {
            errorMessage = "Пароль должен содержать минимум 6 символов"
            showError = true
            shouldNavigate = false
        } else {
            showError = false
            shouldNavigate = true
        }
    }
}

struct RegistrationScreen: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var shouldNavigate = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Регистрация")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.brandDarkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 50)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Имя")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.brandGray)
                    
                    TextField("", text: $firstName)
                        .padding()
                        .background(Color.brandLightGray)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Фамилия")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.brandGray)
                    
                    TextField("", text: $lastName)
                        .padding()
                        .background(Color.brandLightGray)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Номер телефона")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.brandGray)
                    
                    TextField("", text: $phoneNumber)
                        .padding()
                        .background(Color.brandLightGray)
                        .cornerRadius(12)
                        .keyboardType(.phonePad)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Пароль")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.brandGray)
                    
                    SecureField("", text: $password)
                        .padding()
                        .background(Color.brandLightGray)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 40)
            
            if showError {
                Text(errorMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: {
                    validateInput()
                }) {
                    Text("Зарегистрироваться")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandRed)
                        .cornerRadius(100)
                }
                .padding(.horizontal, 16)
                
                HStack {
                    Text("Уже есть аккаунт?")
                        .font(.system(size: 16))
                        .foregroundColor(.brandGray)
                    
                    NavigationLink(destination: LoginScreen().navigationBarHidden(true)) {
                        Text("Вход")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.brandDarkGray)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(destination: CoursesScreen().navigationBarHidden(true), isActive: $shouldNavigate) {
                EmptyView()
            }
        )
    }
    
    private func validateInput() {
        if firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty || password.isEmpty {
            errorMessage = "Заполните все поля"
            showError = true
            shouldNavigate = false
        } else if phoneNumber.count < 10 {
            errorMessage = "Некорректный номер телефона"
            showError = true
            shouldNavigate = false
        } else if password.count < 6 {
            errorMessage = "Пароль должен содержать минимум 6 символов"
            showError = true
            shouldNavigate = false
        } else {
            showError = false
            shouldNavigate = true
        }
    }
}

struct TestScreen: View {
    let subject: String
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var showError = false
    @State private var isCorrect = false
    @State private var showResult = false
    @State private var showResultsScreen = false
    @Environment(\.presentationMode) var presentationMode
    
    var questions: [Question] {
        switch subject {
        case "discrete_math":
            return discreteMathQuestions
        case "probability":
            return probabilityQuestions
        case "calculus":
            return calculusQuestions
        case "algebra":
            return algebraQuestions
        case "programming":
            return programmingQuestions
        case "physics":
            return physicsQuestions
        case "chemistry":
            return chemistryQuestions
        default:
            return discreteMathQuestions
        }
    }
    
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.brandDarkGray)
                }
                
                Spacer()
                
                Text(getSubjectTitle(subject))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.brandDarkGray)
                
                Spacer()
                
                Text("\(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.brandDarkGray)
            }
            .padding(.horizontal, 27)
            .padding(.top, 56)
            
            ProgressBarView(currentIndex: currentQuestionIndex, totalCount: questions.count)
                .padding(.horizontal, 37)
                .padding(.top, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(currentQuestion.text)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.brandDarkGray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .padding(.top, 58)
                    
                    TextField("Введите ответ", text: $userAnswer)
                        .padding()
                        .background(Color.brandLightGray)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.top, 40)
                    
                    if showError {
                        Text("Ответ неверный, попробуйте еще раз")
                            .font(.system(size: 14))
                            .foregroundColor(.brandRed)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                    }
                    
                    if showResult {
                        Text(isCorrect ? "Правильно! ✅" : "Неправильно! ❌")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(isCorrect ? .green : .brandRed)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                    }
                }
            }
            .padding(.top, 16)
            
            Spacer()
            
            Button(action: {
                checkAnswer()
            }) {
                Text("Ответить")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandRed)
                    .cornerRadius(100)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 50)
            .disabled(userAnswer.isEmpty)
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(destination: ResultsScreen(), isActive: $showResultsScreen) {
                EmptyView()
            }
        )
    }
    
    private func getSubjectTitle(_ subject: String) -> String {
        switch subject {
        case "discrete_math": return "Дискретная математика"
        case "probability": return "Теория вероятностей"
        case "calculus": return "Математический анализ"
        case "algebra": return "Линейная алгебра"
        case "programming": return "Программирование"
        case "physics": return "Физика"
        case "chemistry": return "Химия"
        default: return "Тест"
        }
    }
    
    private func checkAnswer() {
        let normalizedAnswer = userAnswer.lowercased().trimmingCharacters(in: .whitespaces)
        let correctAnswer = currentQuestion.answer.lowercased().trimmingCharacters(in: .whitespaces)
        
        isCorrect = normalizedAnswer == correctAnswer
        
        if isCorrect {
            showError = false
            showResult = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showResult = false
                moveToNextQuestion()
            }
        } else {
            showError = true
            showResult = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showResult = false
            }
        }
    }
    
    private func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            userAnswer = ""
            showError = false
        } else {
            showResultsScreen = true
        }
    }
}


struct ProgressBarView: View {
    let currentIndex: Int
    let totalCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalCount, id: \.self) { index in
                Rectangle()
                    .fill(index <= currentIndex ? Color.brandRed : Color(red: 217/255, green: 217/255, blue: 217/255))
                    .frame(height: 8)
                    .cornerRadius(4)
            }
        }
    }
}

struct ResultsScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 24) {
                Text("Поздравляю, вы прошли тест!")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.brandDarkGray)
                    .multilineTextAlignment(.center)
                
                Text("Теперь вам доступен уникальный код для участия в розыгрыше")
                    .font(.system(size: 16))
                    .foregroundColor(.brandDarkGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text("ABCD1234")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.brandRed)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(Color.brandRed.opacity(0.1))
                    .cornerRadius(12)
            }
            
            Spacer()
            
            NavigationLink(destination: CoursesScreen().navigationBarHidden(true)) {
                Text("Главное меню")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandRed)
                    .cornerRadius(100)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 50)
        }
        .navigationBarHidden(true)
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    StarView(size: 47, offset: CGPoint(x: -100, y: 50))
                }
                Spacer()
                HStack {
                    StarView(size: 74, offset: CGPoint(x: 80, y: -150))
                    Spacer()
                }
            }
        )
    }
}

struct MapScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var educationalInstitutions: [EducationalMapMarker] = []
    @State private var selectedMarker: EducationalMapMarker?
    @State private var showMarkerDetail = false
    @State private var isLoading = true
    
    let yandexAPIKey = "8650589a-ddea-47c0-8abc-c042f79dde1c"
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 39, height: 39)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.brandDarkGray)
                        }
                    }
                    .padding(.leading, 14)
                    .padding(.top, 57)
                    
                    Spacer()
                    
                    Text("Яндекс Карты")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.brandDarkGray)
                        .padding(.top, 57)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 39, height: 39)
                        .padding(.trailing, 14)
                        .padding(.top, 57)
                }
                
                ZStack {
                    if !isLoading {
                        YandexWebMapView(
                            apiKey: yandexAPIKey,
                            markers: educationalInstitutions,
                            onMarkerTap: { marker in
                                print("=== MARKER TAPPED IN SWIFT ===")
                                print("Marker: \(marker.title)")
                                selectedMarker = marker
                                showMarkerDetail = true
                            }
                        )
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    } else {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .frame(height: 400)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Образовательные учреждения Москвы")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.brandDarkGray)
                    
                    Text("\(educationalInstitutions.count) ведущих вузов на карте")
                        .font(.system(size: 14))
                        .foregroundColor(.brandGray)
                    
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.brandRed)
                                .frame(width: 20, height: 24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Красные маркеры - ведущие университеты")
                            .font(.system(size: 12))
                            .foregroundColor(.brandGray)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            if showMarkerDetail, let marker = selectedMarker {
                MarkerDetailView(marker: marker, isShowing: $showMarkerDetail)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadMarkersFromDatabase()
        }
    }
    
    private func loadMarkersFromDatabase() {
        let markers = DatabaseManager.shared.getAllMapMarkers()
        print("Loaded \(markers.count) markers from database")
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.educationalInstitutions = markers
            self.isLoading = false
            print("Markers set to state: \(self.educationalInstitutions.count)")
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}

struct EducationalMapPin: View {
    let title: String
    let x: CGFloat
    let y: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Circle()
                    .fill(Color.brandRed)
                    .frame(width: 32, height: 32)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.brandDarkGray)
                .multilineTextAlignment(.center)
                .padding(6)
                .background(Color.white)
                .cornerRadius(6)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                .offset(y: -35)
                .frame(width: 100)
        }
        .offset(x: x, y: y)
    }
}

struct CustomMapPin: View {
    let title: String
    let x: CGFloat
    let y: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brandRed)
                    .frame(width: 28, height: 29)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            
            Triangle()
                .fill(Color.brandRed)
                .frame(width: 8, height: 12)
                .offset(y: 6)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.brandDarkGray)
                .multilineTextAlignment(.center)
                .padding(6)
                .background(Color.white)
                .cornerRadius(6)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                .offset(y: -35)
                .frame(width: 80)
        }
        .offset(x: x - 187.5, y: y - 406)
    }
}

struct MapPinView: View {
    let x: CGFloat
    let y: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brandRed)
                    .frame(width: 28, height: 29)
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 8)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            
            Triangle()
                .fill(Color.brandRed)
                .frame(width: 8, height: 12)
                .offset(y: 6)
        }
        .offset(x: x - 187.5, y: y - 406)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct MapViewWrapper: View {
    @Binding var markers: [EducationalMapMarker]
    
    var body: some View {
        YandexMapView(markers: $markers)
    }
}

struct StarView: View {
    let size: CGFloat
    let offset: CGPoint
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 253/255, green: 240/255, blue: 217/255))
                .frame(width: size, height: size)
                .cornerRadius(3)
                .offset(x: offset.x, y: offset.y)
            
            Rectangle()
                .fill(Color(red: 243/255, green: 178/255, blue: 65/255).opacity(0.71))
                .frame(width: size * 0.6, height: size * 0.6)
                .cornerRadius(3)
                .offset(x: offset.x + size * 0.1, y: offset.y + size * 0.15)
        }
    }
}

struct MarkerDetailView: View {
    let marker: EducationalMapMarker
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowing = false
                }
            
            VStack(spacing: 16) {
                Text(marker.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.brandDarkGray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                ScrollView {
                    Text(marker.description ?? "Образовательное учреждение")
                        .font(.system(size: 16))
                        .foregroundColor(.brandGray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 20)
                }
                .frame(maxHeight: 200)
                
                Button(action: {
                    isShowing = false
                }) {
                    Text("Назад")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandRed)
                        .cornerRadius(100)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .frame(width: 340, height: 400)
        }
    }
}

let discreteMathQuestions = [
    Question(text: "Граф имеет 6 вершин нечётной степени. Может ли в нём существовать эйлерова цепь?", answer: "Нет", subject: "Дискретная математика"),
    Question(text: "Сколько перестановок из 5 элементов существует?", answer: "120", subject: "Дискретная математика"),
    Question(text: "Сколькими способами можно выбрать упорядоченную пару (i, j) из 10 элементов без повторений?", answer: "90", subject: "Дискретная математика"),
    Question(text: "Сколько подмножеств содержит множество из n элементов?", answer: "2^n", subject: "Дискретная математика"),
    Question(text: "Какой минимальный размер окна по принципу Дирихле нужен, чтобы среди 367 людей нашлись двое с одним днём рождения?", answer: "367", subject: "Дискретная математика")
]

let probabilityQuestions = [
    Question(text: "Монета подбрасывается 4 раза. Какова вероятность получить хотя бы один орёл?", answer: "15/16", subject: "Теория вероятностей"),
    Question(text: "Вероятности независимых A и B равны 0.6 и 0.5. Найдите P(A∩B)", answer: "0.3", subject: "Теория вероятностей"),
    Question(text: "Кубик бросают 3 раза. Вероятность не получить ни одной шестёрки?", answer: "125/216", subject: "Теория вероятностей"),
    Question(text: "Из колоды вытянули карту. Вероятность попасть в черву?", answer: "1/4", subject: "Теория вероятностей"),
    Question(text: "Есть событие с вероятностью 0.2. Какова вероятность, что оно не произойдёт?", answer: "0.8", subject: "Теория вероятностей")
]

let calculusQuestions = [
    Question(text: "Найдите производную f(x) = x^3 − 5x^2 + 4x − 7", answer: "3x^2 − 10x + 4", subject: "Математический анализ"),
    Question(text: "Вычислите ∫(3x^2 − 2x + 1) dx", answer: "x^3 − x^2 + x + C", subject: "Математический анализ"),
    Question(text: "Найдите предел lim(x→0) (1 − cos x)/x^2", answer: "1/2", subject: "Математический анализ"),
    Question(text: "Чему равна производная ln(x)?", answer: "1/x", subject: "Математический анализ"),
    Question(text: "Определите ∫(e^x) dx", answer: "e^x + C", subject: "Математический анализ")
]

let algebraQuestions = [
    Question(text: "Найдите ранг матрицы [[1,2,3],[2,4,6],[1,1,1]]", answer: "2", subject: "Линейная алгебра"),
    Question(text: "Определитель матрицы [[1,0],[0,1]]", answer: "1", subject: "Линейная алгебра"),
    Question(text: "Собственные значения матрицы [[2,0],[0,3]]", answer: "2 и 3", subject: "Линейная алгебра"),
    Question(text: "След матрицы [[4,−1],[0,5]]", answer: "9", subject: "Линейная алгебра"),
    Question(text: "Решите уравнение Ax=b при невырожденной A — что нужно сделать?", answer: "A^{-1}b", subject: "Линейная алгебра")
]

let programmingQuestions = [
    Question(text: "Какой тип коллекции в Swift упорядочен и изменяем?", answer: "Array", subject: "Программирование"),
    Question(text: "Как объявить константу в Swift?", answer: "let", subject: "Программирование"),
    Question(text: "Что делает оператор ?? в Swift?", answer: "nil-coalescing", subject: "Программирование"),
    Question(text: "Какой результат у выражения 2 + 3 * 4?", answer: "14", subject: "Программирование"),
    Question(text: "Как называется механизм инкапсуляции данных и методов в типе?", answer: "Класс", subject: "Программирование")
]

let physicsQuestions = [
    Question(text: "Единица измерения силы в СИ?", answer: "Ньютон", subject: "Физика"),
    Question(text: "Какой закон описывает связь силы, массы и ускорения?", answer: "Второй закон Ньютона", subject: "Физика"),
    Question(text: "Как называется энергия движения?", answer: "Кинетическая", subject: "Физика"),
    Question(text: "Чему равна скорость света, приблизительно (км/с)?", answer: "300000", subject: "Физика"),
    Question(text: "Какой заряд у протона?", answer: "Положительный", subject: "Физика")
]

let chemistryQuestions = [
    Question(text: "Как называется минимум энергии для начала реакции?", answer: "Энергия активации", subject: "Химия"),
    Question(text: "Какая температура кипения воды при 1 атм (°C)?", answer: "100", subject: "Химия"),
    Question(text: "Какая валентность у кислорода в воде?", answer: "2", subject: "Химия"),
    Question(text: "Как называется процесс перехода из твёрдого в газ минуя жидкость?", answer: "Сублимация", subject: "Химия"),
    Question(text: "Формула поваренной соли?", answer: "NaCl", subject: "Химия")
]

extension Color {
    static let brandRed = Color(red: 186/255, green: 33/255, blue: 53/255)
    static let brandGray = Color(red: 151/255, green: 151/255, blue: 151/255)
    static let brandDarkGray = Color(red: 51/255, green: 51/255, blue: 51/255)
    static let brandLightGray = Color(red: 240/255, green: 240/255, blue: 240/255)
    
}

