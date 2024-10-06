import XCTest

// Делаем очистку текстовых полей в автоматических тестах интерфейса
extension XCUIElement { // Расширение класса XCUIElement
    func clearText() { // Метод для очистки текста в элементе
        guard let currentValue = self.value as? String, !currentValue.isEmpty else { return } // Получаем текущее значение; если пустое — выходим из метода
        self.tap() // Активируем текстовое поле нажатием на него
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count) // Создаем строку, содержащую символы клавиши удаления, количество которых равно длине текста
        self.typeText(deleteString) // Вводим строку удалений, чтобы стереть существующий текст
    }
}

class NetologyUITests: XCTestCase {
    let username = "username"
    let password = "123456"
    let newUsername = "newUsername"
    
    func testLogin() throws {
        let app = XCUIApplication()
        app.launch() // Запускаем приложение

        let loginTextField = app.textFields["login"] // Ищем текстовое поле для ввода логина по его метке "login"
        loginTextField.tap() // Нажимаем на текстовое поле, чтобы сделать его активным
        loginTextField.typeText(username) // Вводим имя пользователя в текстовое поле

        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)

        let loginButton = app.buttons["login"]
        XCTAssertTrue(loginButton.isEnabled) // Проверяем, что кнопка активна (включена)
        loginButton.tap()

        let predicate = NSPredicate(format: "label CONTAINS[c] %@", username) // Создаем предикат для поиска элемента текста, содержащего имя пользователя (независимо от регистра)
        let text = app.staticTexts.containing(predicate) // Находим статический текст, соответствующий предикату
        XCTAssertNotNil(text) // Проверяем, что текст найден и не является nil

        let fullScreenshot = XCUIScreen.main.screenshot() // Делаем скриншот экрана приложения
        let screenshot = XCTAttachment(screenshot: fullScreenshot) // Создаем прикрепление со скриншотом
        screenshot.lifetime = .keepAlways // Устанавливаем время хранения прикрепления как "всегда"
        add(screenshot) // Добавляем скриншот в отчет о тесте
    }
    
    func testLoginButtonDisabledAfterClearingUsername() {
        let app = XCUIApplication()
        app.launch()
            
        // Ввод логина
        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText(username)
            
        // Ввод пароля
        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)
            
        // Очистка поля логина
        loginTextField.clearText()
            
        // Проверка, что кнопка логина неактивна после очистки логина
        let loginButton = app.buttons["login"]
        XCTAssertFalse(loginButton.isEnabled)
        
        // Делаем скриншот экрана приложения
        let fullScreenshot = XCUIScreen.main.screenshot()
        let screenshot = XCTAttachment(screenshot: fullScreenshot)
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
        
    func testSecondLogin() throws {
        let app = XCUIApplication()
        app.launch()

        // Ввод логина
        let loginTextField = app.textFields["login"]
        loginTextField.tap()
        loginTextField.typeText(username)

        // Ввод пароля
        let passwordTextField = app.textFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)

        // Нажатие на кнопку Вход
        let loginButton = app.buttons["login"]
        XCTAssertTrue(loginButton.isEnabled)
        loginButton.tap()

        // Возврат к экрану входа
        let backButtion = app.buttons["Login"]
        backButtion.tap()

        // Ввод нового логина
        loginTextField.tap()
        loginTextField.typeText(newUsername)

        // Проверяем, что логин на экране Profile совпадает с логином, который пользователь ввёл второй раз
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", newUsername)
        let text = app.staticTexts.containing(predicate)
        XCTAssertNotNil(text)
        
        // Делаем скриншот экрана приложения
        let fullScreenshot = XCUIScreen.main.screenshot()
        let screenshot = XCTAttachment(screenshot: fullScreenshot)
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}
