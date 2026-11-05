rcmdcheck <- function(path = ".", args = character(), build_args = character(),
                      error_on = "never", check_dir = NULL, ...) {
  log <- Sys.getenv("FAKE_RCMDCHECK_LOG", "rcmdcheck-log.txt")
  lines <- c(
    paste0("args=", paste(args, collapse = ",")),
    paste0("build_args=", paste(build_args, collapse = ",")),
    paste0("error_on=", error_on),
    paste0("check_dir=", if (is.null(check_dir)) "NULL" else check_dir),
    paste0("cran_incoming=", Sys.getenv("_R_CHECK_CRAN_INCOMING_"))
  )
  writeLines(lines, log)
  cat(lines, sep = "\n")
  if (!is.null(check_dir)) dir.create(check_dir, showWarnings = FALSE, recursive = TRUE)
  result <- Sys.getenv("FAKE_RCMDCHECK_RESULT", "ok")
  if (result != "ok") {
    err_levels <- c(never = 4, error = 3, warning = 2, note = 1)
    res_levels <- c(error = 3, warning = 2, note = 1)
    if (res_levels[[result]] >= err_levels[[error_on]]) {
      stop("R CMD check found ", result, "s")
    }
  }
  invisible(lines)
}
