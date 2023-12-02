// reference: https://ww2.mathworks.cn/help/matlab/matlab_external/standalone-example.html

#include "mex.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* check for proper number of arguments */
    if(nrhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","One inputs required.");
    }
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","One output required.");
    }

    /* make sure the first input argument is type double */
    if(!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0])) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble","Input matrix must be type Double.");
    }

    double* inMatrix = mxGetPr(prhs[0]);

    int M = mxGetM(prhs[0]);           // row num
    int N = mxGetN(prhs[0]);           // col num

    const int BLOCK_SIZE = 25;
    plhs[0] = mxCreateDoubleMatrix((mwSize)M, (mwSize)N, mxREAL);
    double* outMatrix = mxGetPr(plhs[0]);
    for (int i = 0; i < M; i++){
        for (int j = 0; j < N; j++){
            outMatrix[i * N + j] = 255;
        }
    }

    for (int i = 0; i < M - BLOCK_SIZE; i++) {
        for (int j = 0; j < N; j++) {
            int occur_times = 0;                            // 出现次数
            for (int a = i; a < i + BLOCK_SIZE; a++) {
                for (int b = j; b < j + BLOCK_SIZE; b++) {
                    if (inMatrix[a * N + b] <= inMatrix[(i + (BLOCK_SIZE) / 2) * N + j + (BLOCK_SIZE) / 2]) {
                        occur_times++;
                    }
                }
            }
            outMatrix[(i + BLOCK_SIZE / 2) * N + j + BLOCK_SIZE / 2] = (255.0 * occur_times / (BLOCK_SIZE * BLOCK_SIZE));
        }
    }
}