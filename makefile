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
LIB = $(LIB_DIR)/libcaesar.so

# Sources
MAIN_SRC = $(SRC_DIR)/main.cpp
ENCODER_SRC = $(SRC_DIR)/encoder.cpp
DECODER_SRC = $(SRC_DIR)/decoder.cpp

# Objects
MAIN_OBJ = $(OBJ_DIR)/main.o
ENCODER_OBJ = $(OBJ_DIR)/encoder.o
DECODER_OBJ = $(OBJ_DIR)/decoder.o

# Build all
all: setup $(LIB) $(TARGET)

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

# Step 4: Compile main
$(MAIN_OBJ): $(MAIN_SRC)
	$(CXX) $(CXXFLAGS) -I$(INC_DIR) -c $< -o $@

$(TARGET): $(MAIN_OBJ) $(LIB)
	$(CXX) $< -o $@ -L$(LIB_DIR) -lcaesar -ldl

# Clean all build files
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR)

