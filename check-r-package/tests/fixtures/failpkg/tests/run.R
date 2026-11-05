library(failpkg)
if (add(1, 1) != 3) stop("intentional test failure: add(1, 1) is not 3")
