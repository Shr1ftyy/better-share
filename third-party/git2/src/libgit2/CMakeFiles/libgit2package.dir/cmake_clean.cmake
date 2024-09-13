file(REMOVE_RECURSE
  "../../libgit2.pdb"
  "../../libgit2.so"
  "../../libgit2.so.1.8"
  "../../libgit2.so.1.8.2"
)

# Per-language clean rules from dependency scanning.
foreach(lang C)
  include(CMakeFiles/libgit2package.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
