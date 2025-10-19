import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    private let databaseName = "ReverseEducation.sqlite"
    
    private init() {
        openDatabase()
        createTables()
        insertInitialData()
    }
    
    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databaseName)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        print("Database opened successfully at: \(fileURL.path)")
    }
    
    private func createTables() {
        let createCoursesTable = """
        CREATE TABLE IF NOT EXISTS Courses (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            imageName TEXT NOT NULL,
            subject TEXT NOT NULL
        );
        """
        
        let createMapMarkersTable = """
        CREATE TABLE IF NOT EXISTS MapMarkers (
            id TEXT PRIMARY KEY,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            title TEXT NOT NULL,
            description TEXT
        );
        """
        
        executeQuery(createCoursesTable)
        executeQuery(createMapMarkersTable)
    }
    
    private func executeQuery(_ query: String) {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                print("Error executing query: \(query), error: \(error)")
            }
        } else {
            let error = String(cString: sqlite3_errmsg(db))
            print("Error preparing query: \(query), error: \(error)")
        }
        sqlite3_finalize(statement)
    }
    
    private func insertInitialData() {
        clearAllData()
        insertCourses()
        insertMapMarkers()
    }
    
    private func clearAllData() {
        let deleteCourses = "DELETE FROM Courses;"
        let deleteMarkers = "DELETE FROM MapMarkers;"
        
        executeQuery(deleteCourses)
        executeQuery(deleteMarkers)
        print("Cleared all existing data")
    }
    
    private func insertCourses() {
        let courses = [
            ("1", "DISCRETE MATH", "Discrete mathematics", "discrete_math", "discrete_math"),
            ("2", "PROBABILITY THEORY", "Probability theory", "probability", "probability"),
            ("3", "CALCULUS", "Mathematical analysis", "calculus", "calculus"),
            ("4", "LINEAR ALGEBRA", "Linear algebra", "algebra", "algebra"),
            ("5", "PROGRAMMING", "Programming", "programming", "programming"),
            ("6", "PHYSICS", "Physics", "physics", "physics"),
            ("7", "CHEMISTRY", "Chemistry", "chemistry", "chemistry")
        ]
        
        let insertQuery = "INSERT OR REPLACE INTO Courses (id, name, description, imageName, subject) VALUES (?, ?, ?, ?, ?);"
        
        for course in courses {
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, course.0, -1, nil)
                sqlite3_bind_text(statement, 2, course.1, -1, nil)
                sqlite3_bind_text(statement, 3, course.2, -1, nil)
                sqlite3_bind_text(statement, 4, course.3, -1, nil)
                sqlite3_bind_text(statement, 5, course.4, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Successfully inserted course: \(course.1)")
                } else {
                    print("Error inserting course: \(course.1)")
                }
                sqlite3_finalize(statement)
            }
        }
    }
    
    private func insertMapMarkers() {
        let markers = [
            ("1", 55.703777, 37.528973, "MSU", "Leading university"),
            ("2", 55.670205, 37.482731, "MGIMO", "International relations"),
            ("3", 55.754588, 37.621590, "HSE", "Economics and social sciences"),
            ("4", 55.929723, 37.518611, "MIPT", "Technical university"),
            ("5", 55.800278, 37.708611, "MAI", "Aviation and cosmonautics"),
            ("6", 55.731154, 37.603090, "REU", "Economics and business"),
            ("7", 55.786667, 37.598611, "BMSTU", "Technical education")
        ]
        
        let insertQuery = "INSERT OR REPLACE INTO MapMarkers (id, latitude, longitude, title, description) VALUES (?, ?, ?, ?, ?);"
        
        for marker in markers {
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, marker.0, -1, nil)
                sqlite3_bind_double(statement, 2, marker.1)
                sqlite3_bind_double(statement, 3, marker.2)
                sqlite3_bind_text(statement, 4, marker.3, -1, nil)
                sqlite3_bind_text(statement, 5, marker.4, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Successfully inserted marker: \(marker.3)")
                } else {
                    print("Error inserting marker: \(marker.3)")
                }
                sqlite3_finalize(statement)
            }
        }
    }
    
    func getAllCourses() -> [CourseItem] {
        let englishCourses = [
            CourseItem(name: "DISCRETE MATH", description: "Discrete mathematics\n1st course", imageName: "discrete_math", subject: "discrete_math"),
            CourseItem(name: "PROBABILITY THEORY", description: "Probability theory\nand mathematical statistics", imageName: "probability", subject: "probability"),
            CourseItem(name: "CALCULUS", description: "Mathematical analysis\n1st course", imageName: "calculus", subject: "calculus"),
            CourseItem(name: "LINEAR ALGEBRA", description: "Linear algebra\n1st course", imageName: "algebra", subject: "algebra"),
            CourseItem(name: "PROGRAMMING", description: "Programming\n1st course", imageName: "programming", subject: "programming"),
            CourseItem(name: "PHYSICS", description: "Physics\n1st course", imageName: "physics", subject: "physics"),
            CourseItem(name: "CHEMISTRY", description: "Chemistry\n1st course", imageName: "chemistry", subject: "chemistry")
        ]
        
       
        let russianCourses = englishCourses.map { englishCourse -> CourseItem in
            let russianName: String
            let russianDescription: String
            
            switch englishCourse.name {
            case "DISCRETE MATH":
                russianName = "ДИСКРЕТНАЯ МАТЕМАТИКА"
                russianDescription = "Дискретная математика\n1 курс"
            case "PROBABILITY THEORY":
                russianName = "ТЕОРИЯ ВЕРОЯТНОСТЕЙ"
                russianDescription = "Теория вероятностей\nи математическая статистика"
            case "CALCULUS":
                russianName = "МАТЕМАТИЧЕСКИЙ АНАЛИЗ"
                russianDescription = "Математический анализ\n1 курс"
            case "LINEAR ALGEBRA":
                russianName = "ЛИНЕЙНАЯ АЛГЕБРА"
                russianDescription = "Линейная алгебра\n1 курс"
            case "PROGRAMMING":
                russianName = "ПРОГРАММИРОВАНИЕ"
                russianDescription = "Программирование\n1 курс"
            case "PHYSICS":
                russianName = "ФИЗИКА"
                russianDescription = "Физика\n1 курс"
            case "CHEMISTRY":
                russianName = "ХИМИЯ"
                russianDescription = "Химия\n1 курс"
            default:
                russianName = englishCourse.name
                russianDescription = englishCourse.description
            }
            
            return CourseItem(
                name: russianName,
                description: russianDescription,
                imageName: englishCourse.imageName,
                subject: englishCourse.subject
            )
        }
        
        return russianCourses
    }
    
    func getAllMapMarkers() -> [EducationalMapMarker] {
        print("=== GETTING MARKERS FROM DATABASE ===")
        
        let markers = [
            EducationalMapMarker(
                latitude: 55.7039,
                longitude: 37.5288,
                title: "МГУ им. Ломоносова",
                description: "Ведущий университет России с фундаментальным образованием. Здесь можно изучать математику, физику, химию и другие естественные науки на высшем уровне. Университет предлагает программы бакалавриата, магистратуры и аспирантуры."
            ),
            EducationalMapMarker(
                latitude: 55.6702,
                longitude: 37.4827,
                title: "МГИМО",
                description: "Ведущий вуз в области международных отношений и дипломатии. Студенты изучают иностранные языки, международное право, экономику и политику. Идеальное место для тех, кто хочет работать в посольствах, международных организациях или дипломатической службе."
            ),
            EducationalMapMarker(
                latitude: 55.7546,
                longitude: 37.6216,
                title: "НИУ ВШЭ",
                description: "Современный университет с сильными программами в области экономики, социальных наук и компьютерных технологий. Известен своими исследованиями в области data science, бизнес-аналитики и общественных наук. Активно сотрудничает с международными компаниями."
            ),
            EducationalMapMarker(
                latitude: 55.9297,
                longitude: 37.5186,
                title: "МФТИ",
                description: "Легендарный 'Физтех' - ведущий технический вуз России. Специализируется на подготовке ученых и инженеров в области физики, математики и компьютерных наук. Система обучения включает фундаментальную подготовку и практические исследования в научных лабораториях."
            ),
            EducationalMapMarker(
                latitude: 55.8003,
                longitude: 37.7086,
                title: "МАИ",
                description: "Московский авиационный институт готовит специалистов в области авиации, космонавтики и ракетостроения. Студенты участвуют в реальных проектах по созданию летательных аппаратов, спутников и космических систем. Тесное сотрудничество с предприятиями аэрокосмической отрасли."
            ),
            EducationalMapMarker(
                latitude: 55.7312,
                longitude: 37.6031,
                title: "РЭУ им. Плеханова",
                description: "Крупнейший экономический университет России. Предлагает программы в области экономики, менеджмента, маркетинга и финансов. Известен сильной бизнес-школой и программами по предпринимательству. Много международных партнерств с европейскими бизнес-школами."
            ),
            EducationalMapMarker(
                latitude: 55.7867,
                longitude: 37.5986,
                title: "МГТУ им. Баумана",
                description: "Старейший технический университет России с богатыми традициями. Готовит инженеров высшей квалификации в области машиностроения, робототехники, энергетики и IT. Известен проектным подходом к обучению и тесными связями с промышленными предприятиями."
            )
        ]
        
        print("Returning \(markers.count) markers:")
        markers.forEach { marker in
            print(" - \(marker.title): \(marker.latitude), \(marker.longitude)")
        }
        
        return markers
    }
}
