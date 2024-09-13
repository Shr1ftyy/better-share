# CMake generated Testfile for 
# Source directory: /home/clu/Downloads/libgit2/tests/libgit2
# Build directory: /home/clu/Downloads/libgit2/build/tests/libgit2
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(offline "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-xonline")
set_tests_properties(offline PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;67;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(invasive "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sfilter::stream::bigfile" "-sodb::largefiles" "-siterator::workdir::filesystem_gunk" "-srepo::init" "-srepo::init::at_filesystem_root" "-sonline::clone::connect_timeout_default")
set_tests_properties(invasive PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;68;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(online "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline" "-xonline::customcert")
set_tests_properties(online PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;69;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(online_customcert "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::customcert")
set_tests_properties(online_customcert PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;70;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(gitdaemon "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::push")
set_tests_properties(gitdaemon PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;71;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(gitdaemon_namespace "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::clone::namespace")
set_tests_properties(gitdaemon_namespace PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;72;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(gitdaemon_sha256 "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::clone::sha256")
set_tests_properties(gitdaemon_sha256 PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;73;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(ssh "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::push" "-sonline::clone::ssh_cert" "-sonline::clone::ssh_with_paths" "-sonline::clone::path_whitespace_ssh" "-sonline::clone::ssh_auth_methods")
set_tests_properties(ssh PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;74;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(proxy "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::clone::proxy")
set_tests_properties(proxy PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;75;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(auth_clone "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::clone::cred")
set_tests_properties(auth_clone PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;76;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
add_test(auth_clone_and_push "/home/clu/Downloads/libgit2/build/libgit2_tests" "-v" "-sonline::clone::push" "-sonline::push")
set_tests_properties(auth_clone_and_push PROPERTIES  _BACKTRACE_TRIPLES "/home/clu/Downloads/libgit2/cmake/AddClarTest.cmake;5;add_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;77;add_clar_test;/home/clu/Downloads/libgit2/tests/libgit2/CMakeLists.txt;0;")
