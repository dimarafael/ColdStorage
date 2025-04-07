cmake_minimum_required(VERSION 3.16)

project(ColdStorage VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appColdStorage
    main.cpp
)

qt_add_qml_module(appColdStorage
    URI ColdStorage
    VERSION 1.0
    RESOURCES
        img/logo.png
        img/gear.svg
    QML_FILES
        Main.qml
    SOURCES apiclient.h apiclient.cpp
    SOURCES storageplaces.h storageplaces.cpp
    QML_FILES StoragePlaceDelegate.qml
    SOURCES shelves.h shelves.cpp
    RESOURCES db.sql
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appColdStorage PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appColdStorage
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appColdStorage
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appColdStorage
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
