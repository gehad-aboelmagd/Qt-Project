cmake_minimum_required(VERSION 3.16)

project(Infotainment VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)

set(CMAKE_AUTORCC ON)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appInfotainment
    main.cpp
    resources.qrc
)

qt_add_qml_module(appInfotainment
    URI Infotainment
    QML_FILES
        Main.qml
        QML_FILES HomeScreen.qml
        RESOURCES resources.qrc
        QML_FILES pages/SettingsPage.qml
        QML_FILES pages/NavigationPage.qml
        QML_FILES pages/MusicPage.qml
        QML_FILES pages/PhonePage.qml
        QML_FILES pages/DashboardPage.qml
        QML_FILES
        QML_FILES Theme.js
        SOURCES
        SOURCES PageNavigator.h
        QML_FILES pages/WeatherPage.qml
        QML_FILES
        QML_FILES
        QML_FILES
        QML_FILES
        QML_FILES WeatherService.js
        RESOURCES
        RESOURCES
        RESOURCES
        SOURCES MediaService.h MediaService.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appInfotainment PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appInfotainment
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appInfotainment
    PRIVATE Qt6::Quick
    Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appInfotainment
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
