# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/clu/Downloads/libgit2

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/clu/Downloads/libgit2/build

# Include any dependencies generated for this target.
include tests/headertest/CMakeFiles/headertest.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tests/headertest/CMakeFiles/headertest.dir/compiler_depend.make

# Include the progress variables for this target.
include tests/headertest/CMakeFiles/headertest.dir/progress.make

# Include the compile flags for this target's objects.
include tests/headertest/CMakeFiles/headertest.dir/flags.make

tests/headertest/CMakeFiles/headertest.dir/headertest.c.o: tests/headertest/CMakeFiles/headertest.dir/flags.make
tests/headertest/CMakeFiles/headertest.dir/headertest.c.o: ../tests/headertest/headertest.c
tests/headertest/CMakeFiles/headertest.dir/headertest.c.o: tests/headertest/CMakeFiles/headertest.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/clu/Downloads/libgit2/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object tests/headertest/CMakeFiles/headertest.dir/headertest.c.o"
	cd /home/clu/Downloads/libgit2/build/tests/headertest && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT tests/headertest/CMakeFiles/headertest.dir/headertest.c.o -MF CMakeFiles/headertest.dir/headertest.c.o.d -o CMakeFiles/headertest.dir/headertest.c.o -c /home/clu/Downloads/libgit2/tests/headertest/headertest.c

tests/headertest/CMakeFiles/headertest.dir/headertest.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/headertest.dir/headertest.c.i"
	cd /home/clu/Downloads/libgit2/build/tests/headertest && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/clu/Downloads/libgit2/tests/headertest/headertest.c > CMakeFiles/headertest.dir/headertest.c.i

tests/headertest/CMakeFiles/headertest.dir/headertest.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/headertest.dir/headertest.c.s"
	cd /home/clu/Downloads/libgit2/build/tests/headertest && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/clu/Downloads/libgit2/tests/headertest/headertest.c -o CMakeFiles/headertest.dir/headertest.c.s

# Object files for target headertest
headertest_OBJECTS = \
"CMakeFiles/headertest.dir/headertest.c.o"

# External object files for target headertest
headertest_EXTERNAL_OBJECTS =

tests/headertest/headertest: tests/headertest/CMakeFiles/headertest.dir/headertest.c.o
tests/headertest/headertest: tests/headertest/CMakeFiles/headertest.dir/build.make
tests/headertest/headertest: tests/headertest/CMakeFiles/headertest.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/clu/Downloads/libgit2/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable headertest"
	cd /home/clu/Downloads/libgit2/build/tests/headertest && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/headertest.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/headertest/CMakeFiles/headertest.dir/build: tests/headertest/headertest
.PHONY : tests/headertest/CMakeFiles/headertest.dir/build

tests/headertest/CMakeFiles/headertest.dir/clean:
	cd /home/clu/Downloads/libgit2/build/tests/headertest && $(CMAKE_COMMAND) -P CMakeFiles/headertest.dir/cmake_clean.cmake
.PHONY : tests/headertest/CMakeFiles/headertest.dir/clean

tests/headertest/CMakeFiles/headertest.dir/depend:
	cd /home/clu/Downloads/libgit2/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/clu/Downloads/libgit2 /home/clu/Downloads/libgit2/tests/headertest /home/clu/Downloads/libgit2/build /home/clu/Downloads/libgit2/build/tests/headertest /home/clu/Downloads/libgit2/build/tests/headertest/CMakeFiles/headertest.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/headertest/CMakeFiles/headertest.dir/depend
