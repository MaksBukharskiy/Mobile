<<<<<<< HEAD
# ReverseEducation

Мобильное приложение для образовательных курсов и интерактивной карты учебных заведений Москвы.

## Функциональность

- 📚 Просмотр образовательных курсов
- 🧪 Прохождение тестов по предметам  
- 🗺️ Интерактивная карта с образовательными учреждениями
- 🔐 Система входа и регистрации
- 💾 Локальное хранение данных в SQLite

## Технологии

- SwiftUI
- SQLite3
- Яндекс Карты API
- MapKit

## База данных

База данных реализована в файле: `DatabaseManager.swift`

Файл содержит:
- Создание таблиц для курсов и маркеров карты
- Вставку начальных данных
- Методы для получения данных из БД

## Структура проекта

- `ReverseEducation/ReverseEducationApp.swift` - Точка входа приложения
- `ReverseEducation/ContentView.swift` - Основные экраны приложения
- `ReverseEducation/SceneDelegate.swift` - Сцены и жизненный цикл
- `ReverseEducation/Info.plist` - Настройки приложения
- `DatabaseManager.swift` - Работа с базой данных SQLite
- `Models.swift` - Модели данных
- `CoursesScreen.swift` - Экран с курсами
- `YandexWebMapView.swift` - Интеграция с Яндекс Картами через WebView
- `YandexMapView.swift` - Интеграция с Яндекс Картами (нативная)
- `SimpleMapView.swift` - Пример простого MapKit экрана

## Установка

1. Клонируйте репозиторий
2. Откройте `ReverseEducation.xcodeproj` в Xcode
3. Выберите схему `ReverseEducation` и запустите на симуляторе или устройстве
=======
# Mobile
>>>>>>> 68b032e3fda163fb53540f660e4944df7a536459
