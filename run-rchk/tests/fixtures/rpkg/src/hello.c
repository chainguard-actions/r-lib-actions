#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP C_hello(SEXP n) {
  int len = asInteger(n);
  if (len < 0) len = 0;
  SEXP out = PROTECT(allocVector(INTSXP, len));
  for (int i = 0; i < len; i++) INTEGER(out)[i] = i;
  UNPROTECT(1);
  return out;
}

static const R_CallMethodDef CallEntries[] = {
  {"C_hello", (DL_FUNC) &C_hello, 1},
  {NULL, NULL, 0}
};

void R_init_rchktest(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
