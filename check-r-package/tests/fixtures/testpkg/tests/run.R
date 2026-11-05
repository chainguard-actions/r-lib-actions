library(testpkg)
stopifnot(identical(hello("R"), "Hello, R!"))
cat("testpkg tests passed\n")
