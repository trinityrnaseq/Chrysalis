cmake_minimum_required (VERSION 3.9)
find_program(CMAKE_C_COMPILER NAMES $ENV{CC} gcc PATHS ENV PATH NO_DEFAULT_PATH})
find_program(CMAKE_CXX_COMPILER NAMES $ENV{CXX} g++ PATHS ENV PATH NO_DEFAULT_PATH})

project (Inchworm)

enable_language(CXX)

# Trinity requires a 64-bit platform (64-bit integers/pointers for k-mer encoding and large memory use).
# This replaces the former -m64 flag, which is x86-only and breaks aarch64/arm64 builds.
if(NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
    message(FATAL_ERROR "Chrysalis requires a 64-bit build (CMAKE_SIZEOF_VOID_P=${CMAKE_SIZEOF_VOID_P}); 32-bit platforms are not supported.")
endif()

set(default_build_type "Release")

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "${Red}No build type specified so building in RELEASE mode.${ColourReset}")
    set(CMAKE_BUILD_TYPE "${default_build_type}")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe -W -Wall -Wpedantic -pthread")

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2  -DNDEBUG ")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lm -ldl ")

# Portable OpenMP flags: a bare -fopenmp is rejected by Apple clang, which needs libomp
find_package(OpenMP REQUIRED COMPONENTS CXX)
link_libraries(OpenMP::OpenMP_CXX)

MESSAGE(STATUS "system: ${CMAKE_SYSTEM_NAME}")
if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lrt")
elseif (${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libstdc++")
endif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")


include_directories( BEFORE "${CMAKE_SOURCE_DIR}" )


############
## Chrysalis 
############

set(Chrysalis_SOURCES aligns/KmerAlignCore.cc
                      analysis/AACodons.cc
                      analysis/Chrysalis.cc
                      analysis/DNAVector.cc
                      analysis/TranscriptomeGraph.cc
                      base/ErrorHandling.cc
                      base/FileParser.cc
                      base/StringUtil.cc
                      util/mutil.cc )

add_executable(Chrysalis ${Chrysalis_SOURCES})
install(TARGETS Chrysalis DESTINATION bin)


#################
## GraphFromFasta
#################

set(GraphFromFasta_SOURCES aligns/KmerAlignCore.cc
                           analysis/AACodons.cc
                           analysis/DNAVector.cc
                           analysis/DeBruijnGraph.cc
                           analysis/GraphFromFasta.cc
                           analysis/KmerTable.cc
                           analysis/NonRedKmerTable.cc
                           analysis/sequenceUtil.cc
                           analysis/stacktrace.cc
                           base/ErrorHandling.cc
                           base/FileParser.cc
                           base/StringUtil.cc
                           util/mutil.cc )

add_executable(GraphFromFasta ${GraphFromFasta_SOURCES})
install(TARGETS GraphFromFasta DESTINATION bin)


################
## QuantifyGraph
################

set(QuantifyGraph_SOURCES aligns/KmerAlignCore.cc
                          analysis/AACodons.cc
                          analysis/DNAVector.cc
                          analysis/KmerTable.cc
                          analysis/NonRedKmerTable.cc
                          analysis/QuantifyGraph.cc
                          base/ErrorHandling.cc
                          base/FileParser.cc
                          base/StringUtil.cc
                          analysis/sequenceUtil.cc
                          analysis/stacktrace.cc
                          util/mutil.cc )

add_executable(QuantifyGraph ${QuantifyGraph_SOURCES})
install(TARGETS QuantifyGraph DESTINATION bin)

#####################
## ReadsToTranscripts
#####################


set(ReadsToTranscripts_SOURCES analysis/AACodons.cc
                               analysis/DNAVector.cc
                               analysis/NonRedKmerTable.cc
                               analysis/ReadsToTranscripts.cc
                               analysis/sequenceUtil.cc
                               analysis/stacktrace.cc
                               base/ErrorHandling.cc
                               base/FileParser.cc
                               base/StringUtil.cc
                               util/mutil.cc )

add_executable(ReadsToTranscripts ${ReadsToTranscripts_SOURCES})
install(TARGETS ReadsToTranscripts DESTINATION bin)


#####################
## BubbleUpClustering
#####################

set(BubbleUpClustering_SOURCES aligns/KmerAlignCore.cc
                               analysis/AACodons.cc
                               analysis/BubbleUpClustering.cc
                               analysis/DNAVector.cc
                               analysis/DeBruijnGraph.cc
                               analysis/KmerTable.cc
                               analysis/NonRedKmerTable.cc
                               analysis/sequenceUtil.cc
                               analysis/stacktrace.cc
                               base/ErrorHandling.cc
                               base/FileParser.cc
                               base/StringUtil.cc
                               util/mutil.cc )

add_executable(BubbleUpClustering ${BubbleUpClustering_SOURCES})
install(TARGETS BubbleUpClustering DESTINATION bin)


#########################
## CreateIwormFastaBundle
#########################

set(CreateIwormFastaBundle_SOURCES analysis/AACodons.cc
                                   analysis/CreateIwormFastaBundle.cc
                                   analysis/DNAVector.cc
                                   base/ErrorHandling.cc
                                   base/FileParser.cc
                                   base/StringUtil.cc
                                   util/mutil.cc )

add_executable(CreateIwormFastaBundle ${CreateIwormFastaBundle_SOURCES})
install(TARGETS CreateIwormFastaBundle DESTINATION bin)

