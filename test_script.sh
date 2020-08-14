#!/bin/bash

declare LOOPS=$1
declare BIT=$2
declare SCIPY=1
declare NUMBA=4
declare CUPY=6


# Test Scipy
for (( n=1; n<=${SCIPY}; n++ ))
do
	echo -e "**************************************************"
	echo -e "Test gtc_fall_scipy_v${n}.py ${BIT} ${LOOPS}"
	echo -e "**************************************************"
	nsys profile --sample=none --trace=cuda,nvtx --stats=true python3 gtc_fall_scipy_v${n}.py ${BIT} ${LOOPS}
	echo -e
done

# Test Numba
for (( n=1; n<=${NUMBA}; n++ ))
do
	echo -e "**************************************************"
	echo -e "Test gtc_fall_numpy_v${n}.py ${BIT} ${LOOPS}"
	echo -e "**************************************************"
	nsys profile --sample=none --trace=cuda,nvtx --stats=true python3 gtc_fall_numba_v${n}.py ${BIT} ${LOOPS}
	echo -e
done

# Build fatbins for CuPy testing
nvcc --fatbin -std=c++11 --use_fast_math \
	--generate-code arch=compute_35,code=sm_35 \
	--generate-code arch=compute_35,code=sm_37 \
	--generate-code arch=compute_50,code=sm_50 \
	--generate-code arch=compute_50,code=sm_52 \
	--generate-code arch=compute_53,code=sm_53 \
	--generate-code arch=compute_60,code=sm_60 \
	--generate-code arch=compute_61,code=sm_61 \
	--generate-code arch=compute_62,code=sm_62 \
	--generate-code arch=compute_70,code=sm_70 \
	--generate-code arch=compute_72,code=sm_72 \
	--generate-code arch=compute_75,code=[sm_75,compute_75] \
	_lombscargle.cu -odir .

nvcc --fatbin -std=c++11 --use_fast_math \
	--generate-code arch=compute_35,code=sm_35 \
	--generate-code arch=compute_35,code=sm_37 \
	--generate-code arch=compute_50,code=sm_50 \
	--generate-code arch=compute_50,code=sm_52 \
	--generate-code arch=compute_53,code=sm_53 \
	--generate-code arch=compute_60,code=sm_60 \
	--generate-code arch=compute_61,code=sm_61 \
	--generate-code arch=compute_62,code=sm_62 \
	--generate-code arch=compute_70,code=sm_70 \
	--generate-code arch=compute_72,code=sm_72 \
	--generate-code arch=compute_75,code=[sm_75,compute_75] \
	_lombscargle_lb.cu -odir .

# Test CuPy
for (( n=1; n<=${CUPY}; n++ ))
do
	echo -e "**************************************************"
	echo -e "Test gtc_fall_cupy_v${n}.py ${BIT} ${LOOPS}"
	echo -e "**************************************************"
	nsys profile --sample=none --trace=cuda,nvtx --stats=true python3 gtc_fall_cupy_v${n}.py ${BIT} ${LOOPS}
	echo -e
done
