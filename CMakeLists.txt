CMAKE_MINIMUM_REQUIRED( VERSION 3.5 )

PROJECT( dwg_rep )
set(CMAKE_CXX_STANDARD 17)
#Настройка Warning-ов
add_definitions()
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}") #Только для C
#Предопределения
add_definitions()

include_directories(src)
include_directories(djinni)
include_directories(include)

file(GLOB_RECURSE DWG_SOURES src/*.cpp src/*.c djinni/*.cpp)

add_library(${PROJECT_NAME} STATIC ${DWG_SOURES})

add_executable(load_dwg examples/load_dwg.c)
target_link_libraries(load_dwg ${PROJECT_NAME})


add_executable(dwg2dxf programs/dwg2dxf.c)
target_link_libraries(dwg2dxf ${PROJECT_NAME})