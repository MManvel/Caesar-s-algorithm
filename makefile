# Compiler & flags
CXX = g++
CXXFLAGS = -Wall -std=c++11 -fPIC

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib
INC_DIR = inc

# Files
TARGET = $(BIN_DIR)/main_app

# Dynamic library
LIB = $(LIB_DIR)/libcaesar.so

# Static library for unit_test
STATIC_LIB = $(LIB_DIR)/libunit_test.a

# Sources
MAIN_SRC = $(SRC_DIR)/main.cpp
ENCODER_SRC = $(SRC_DIR)/encoder.cpp
DECODER_SRC = $(SRC_DIR)/decoder.cpp
UNIT_TEST_SRC = $(SRC_DIR)/unit_test.cpp

# Objects
MAIN_OBJ = $(OBJ_DIR)/main.o
ENCODER_OBJ = $(OBJ_DIR)/encoder.o
DECODER_OBJ = $(OBJ_DIR)/decoder.o
UNIT_TEST_OBJ = $(OBJ_DIR)/unit_test.o

# Build all
all: setup $(LIB) $(STATIC_LIB) $(TARGET)

# Step 1: Create folders
setup:
	mkdir -p $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR)

# Step 2: Compile encoder & decoder
$(ENCODER_OBJ): $(ENCODER_SRC)
	$(CXX) $(CXXFLAGS) -I$(INC_DIR) -c $< -o $@

$(DECODER_OBJ): $(DECODER_SRC)
	$(CXX) $(CXXFLAGS) -I$(INC_DIR) -c $< -o $@

# Step 3: Create shared library
$(LIB): $(ENCODER_OBJ) $(DECODER_OBJ)
	$(CXX) -shared -o $@ $^

# Step 4: Compile unit_test object
$(UNIT_TEST_OBJ): $(UNIT_TEST_SRC)
	$(CXX) $(CXXFLAGS) -I$(INC_DIR) -c $< -o $@

# Step 5: Create static library for unit_test
$(STATIC_LIB): $(UNIT_TEST_OBJ)
	ar rcs $@ $^

# Step 6: Compile main
$(MAIN_OBJ): $(MAIN_SRC)
	$(CXX) $(CXXFLAGS) -I$(INC_DIR) -c $< -o $@

# Step 7: Link executable with static unit_test lib and dynamic caesar lib
$(TARGET): $(MAIN_OBJ) $(STATIC_LIB) $(LIB)
	$(CXX) $^ -o $@ -L$(LIB_DIR) -lunit_test -lcaesar -ldl

# Clean all build files
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR)

