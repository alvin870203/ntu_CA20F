// See LICENSE for license details.

#include "dataset.h"
#include "util.h"
#include <stddef.h>
// #define BLOCKSIZE 8
#pragma GCC optimize ("unroll-loops")

void matmul(const size_t coreid, const size_t ncores, const size_t lda,  const data_t A[], const data_t B[], data_t C[])
{
  size_t i, j, k;
  size_t ib, jb, kb;
  size_t block = lda / ncores;
  size_t start = block * coreid;
  #pragma omp parallel for
  for (i = 0; i < lda; i++) {
    for (j = start; j < (start+block); j++) {
      data_t sum = 0;
      for (k = 0; k < lda; k++)
        sum += A[j*lda + k] * B[k*lda + i];
      C[i + j*lda] = sum;
    }
  }

//  for (i = 0; i < lda; i++) {
//    for (j = 0; j < lda; j++)
//      C[i + j*lda] = 0;
//  }

//  for (i = 0; i < lda; i+=BLOCKSIZE) {
//    for (j = start; j < (start+block); j+=BLOCKSIZE) {
//      for (k = 0; k < lda; k+=BLOCKSIZE) {
//        for (ib = i; ib < i+BLOCKSIZE; ++ib) {
//	    for (jb = j; jb < j+BLOCKSIZE; ++jb) {
//            data_t cij = C[ib + jb*lda];
//	      for (kb = k; kb < k+BLOCKSIZE; kb++)
//              cij += A[jb*lda + kb] * B[kb*lda + ib];
//	      C[i + j*lda] += cij;
//	    }
//        }
//      }
//    }
//  }

  // barrier(4); // TA demo
}
