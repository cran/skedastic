#' Count peaks in a data sequence
#'
#' This function computes the number of peaks in a double vector, with
#' peak defined as per \insertCite{Goldfeld65;textual}{skedastic}. The function
#' is used in the Goldfeld-Quandt nonparametric test for heteroskedasticity in
#' a linear model. \code{NA} and \code{NaN} values in the sequence are ignored.
#'
#' @param x A double vector.
#'
#' @return An integer value between \code{0} and \code{length(x) - 1}
#'    representing the number of peaks in the sequence.
#'
#' @references{\insertAllCited{}}
#' @export
#' @seealso \code{\link{goldfeld_quandt}}
#'
#' @examples
#' set.seed(9586)
#' countpeaks(stats::rnorm(20))
#' mtcars_lm <- lm(mpg ~ wt + qsec + am, data = mtcars)
#' countpeaks(mtcars_lm$residuals)
#'

countpeaks <- function(x) {
  x <- x[!is.na(x) & !is.nan(x)]
  if (!is.double(x)) stop("x must be a double. Consider using `as.double` with argument.")
  n <- length(x)
  if (n == 0L) {
    stop("There are no finite values in the sequence")
  } else if (n == 1L) {
    return(0L)
  }
  npeaks <- 0L
  peak <- x[1]
  for (i in 2:n) {
    if (x[i] >= peak) {
      npeaks <- npeaks + 1L
      peak <- x[i]
    }
  }
  return(npeaks)
}

#' Probability mass function of number of peaks in an i.i.d. random sequence
#'
#' This function computes \eqn{P(n,k)} as defined by
#' \insertCite{Goldfeld65;textual}{skedastic}, i.e. the probability that a
#' sequence of \eqn{n} independent and identically distributed random variables
#' contains exactly \eqn{k} peaks, with peaks also as defined by
#' \insertCite{Goldfeld65;textual}{skedastic}. The function is used in
#' \code{\link{ppeak}} to compute \eqn{p}-values for the Goldfeld-Quandt
#' nonparametric test for heteroskedasticity in a linear model.
#'
#' @param n A positive integer representing the number of observations in the
#' sequence.
#' @param k An integer or a sequence of integers strictly incrementing by 1,
#' with all values between 0 and \code{n - 1} inclusive. Represents the number
#' of peaks in the sequence.
#' @param usedata A logical. Should probability mass function values be
#' read from \code{\link{dpeakdat}} rather than computing them? This option
#' will save significantly on computation time if \eqn{n < 170} but is
#' currently only available for \eqn{n \leq 1000}.
#'
#' @return A double between 0 and 1 representing the probability of exactly
#' k peaks occurring in a sequence of \eqn{n} independent and identically
#' distributed continuous random variables. The double has a \code{names}
#' attribute with the values corresponding to the probabilities.
#' Computation time is very slow for
#' \eqn{n > 170} (if \code{usedata} is \code{FALSE}) and for \eqn{n > 1000}
#' regardless of \code{usedata} value.
#'
#' @references{\insertAllCited{}}
#' @export
#' @seealso \code{\link{ppeak}}, \code{\link{goldfeld_quandt}}
#'
#' @examples
#' dpeak(0:9, 10)
#' plot(0:9, dpeak(0:9, 10), type = "p", pch = 20, xlab = "Number of Peaks",
#'          ylab = "Probability")
#'
#' # This would be extremely slow if usedata were set to FALSE:
#' prob <- dpeak(0:199, 200, usedata = TRUE)
#' plot(0:199, prob, type = "l", xlab = "Number of Peaks", ylab = "Probability")
#'
#' # `dpeakdat` is a dataset containing probabilities generated from `dpeak`
#' utils::data(dpeakdat)
#' expval <- unlist(lapply(dpeakdat,
#'                  function(p) sum(p * 0:(length(p) - 1))))
#' plot(1:1000, expval[1:1000], type = "l", xlab = parse(text = "n"),
#'      ylab = "Expected Number of Peaks")

dpeak <- function(k, n, usedata = FALSE) {

  if (!all.equal(as.integer(k), k)) stop("vector k must consist only of integer values")

  if (usedata) {
    utils::data(dpeakdat)
    if (n > length(dpeakdat)) stop("Probabilities for this n value are not stored in dpeakdat")
    return(dpeakdat[[n]][k + 1])
  } else {
    if (length(k) == 1 || all(diff(k) == 1)) {
      maxk <- max(k, na.rm = TRUE)
      if (maxk >= n) {
        stop("Support for no. of peaks consists of integers from 0 to n - 1")
      }
      if (n > 170) {
        if (!requireNamespace("gmp", quietly = TRUE) ||
            !requireNamespace("Rmpfr", quietly = TRUE)) {
          stop(
            "Packages \"gmp\" and \"Rmpfr\" must be installed to use this function for n > 170.",
            call. = FALSE
          )
        }
        N <- Rmpfr::mpfrArray(0, precBits = 53, dim = c(n, maxk + 1))
        factorial_denom <- gmp::factorialZ(n)
      } else {
        N <- matrix(data = 0, nrow = n, ncol = maxk + 1) # k can be 0
        factorial_denom <- factorial(n)
      }
      N[1, 1] <- 1
      if (n > 1) {
        for (i in 2:n) {
          N[i, 1] <- (i - 1) * N[i - 1, 1]
          if (maxk >= 1) {
            for (j in 2:(maxk + 1)) {
              N[i, j] <- (i - 1) * N[i - 1, j] + N[i - 1, j - 1]
            }
          }
        }
      }
      probs <- as.double(N[n, k + 1] / factorial_denom)
      names(probs) <- as.character(k)
      return(probs)
    } else {
      message("Procedure is slower for non-sequential k due to recursion")
      dpeak_inner <- function(l, m = n) {
        if (l >= m) {
          stop("Support for no. of peaks consists of integers from 0 to n - 1")
        }
        if (m > 170) {
          if (!requireNamespace("gmp", quietly = TRUE) ||
              !requireNamespace("Rmpfr", quietly = TRUE)) {
            stop(
              "Packages \"gmp\" and \"Rmpfr\" must be installed to use this function for n > 170.",
              call. = FALSE
            )
          }
          N <- Rmpfr::mpfrArray(0, precBits = 53, dim = c(m, l + 1))
          factorial_denom <- gmp::factorialZ(m)
        } else {
          N <- matrix(data = 0, nrow = m, ncol = l + 1)
          factorial_denom <- factorial(m)
        }
        N[1, 1] <- 1
        if (m > 1) {
          for (i in 2:m) {
            N[i, 1] <- (i - 1) * N[i - 1, 1]
            if (l >= 1) {
              for (j in 2:(l + 1)) {
                N[i, j] <- (i - 1) * N[i - 1, j] + N[i - 1, j - 1]
              }
            }
          }
        }
        return(as.double(N[m, l + 1] / factorial_denom))
      }
      probs <- Vectorize(dpeak_inner, USE.NAMES = FALSE)(l = k)
      names(probs) <- as.character(k)
      return(probs)
    }
  }
}

#' Cumulative distribution function of number of peaks in an i.i.d. random sequence
#'
#' This function computes \eqn{\sum_{k} P(n,k)}, i.e. the probability that a
#' sequence of \eqn{n} independent and identically distributed random variables
#' contains \eqn{\ge k} \eqn{(\le k)} peaks, with peaks as defined in
#' \insertCite{Goldfeld65;textual}{skedastic}. The function may be used to
#' compute \eqn{p}-values for the Goldfeld-Quandt nonparametric test for
#' heteroskedasticity in a linear model. Computation time is very slow for
#' \eqn{n > 170} if \code{usedata} is set to \code{FALSE}.
#'
#' @param n A positive integer representing the number of observations in the
#'    sequence.
#' @param k An integer or a sequence of integers strictly incrementing by 1,
#'    with all values between 0 and \code{n - 1} inclusive. Represents the
#'    number of peaks in the sequence.
#' @param lower.tail A logical. Should lower tailed cumulative probability be
#'    calculated? Defaults to \code{FALSE} due to function being designed
#'    primarily for calculating \eqn{p}-values for the peaks test, which is
#'    by default an upper-tailed test. Note that both upper and lower tailed
#'    cumulative probabilities are computed inclusive of \code{k}.
#' @param usedata A logical. Should probability mass function values be
#'    read from \code{\link{dpeakdat}} rather than computing them from
#'    \code{\link{dpeak}}? This option will save significantly on
#'    computation time if \eqn{n < 170} but is currently only available
#'    for \eqn{n \le 1000}.
#'
#' @return A double between 0 and 1 representing the probability of at least
#'    (at most) k peaks occurring in a sequence of \eqn{n} independent and
#'    identically distributed continuous random variables. The double has a
#'    \code{names} attribute with the values corresponding to the
#'    probabilities.
#'
#' @references{\insertAllCited{}}
#' @export
#' @seealso \code{\link{dpeak}}, \code{\link{goldfeld_quandt}}
#'
#' @examples
#' # For an independent sample of size 250, the probability of at least 10
#' # peaks is 0.02650008
#' ppeak(k = 10, n = 250, lower.tail = FALSE, usedata = TRUE)
#' # For an independent sample of size 10, the probability of at most 2 peaks
#' # is 0.7060615
#' ppeak(k = 2, n = 10, lower.tail = TRUE, usedata = FALSE)
#'

ppeak <- function(k, n, lower.tail = FALSE, usedata = TRUE) {

  if (usedata) {
    utils::data(dpeakdat)
    maxn_indata <- length(dpeakdat)
  }
  ppeak_up <- function(n, j) {
    if (j >= n) {
      stop("`k` must be less than `n`")
    } else if (j == 0) {
      return(1)
    } else {
      if (usedata && n <= maxn_indata) {
        return(sum(dpeakdat[[n]][(j + 1):(n)]))
      } else {
        return(sum(dpeak(k = j:(n - 1), n)))
      }
    }
  }

  ppeak_lo <- function(n, j) {
    if (j >= n) {
      stop("`k` must be less than `n`")
    } else {
      if (usedata && n <= maxn_indata) {
        return(sum(dpeakdat[[n]][1:(j + 1)]))
      } else {
        return(sum(dpeak(k = 0:j, n)))
      }
    }
  }

  if (lower.tail) {
    vapply(k, ppeak_lo, FUN.VALUE = NA_real_, n = n)
  } else {
    vapply(k, ppeak_up, FUN.VALUE = NA_real_, n = n)
  }
}
