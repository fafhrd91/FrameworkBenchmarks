#!/bin/bash
export BOOST_ROOT=/usr/local
export BOOST_INC=${BOOST_ROOT}/include
export BOOST_LIB=${BOOST_ROOT}/lib

export WT_ROOT=${IROOT}/wt
export WT_LIB=${WT_ROOT}/lib
export WT_INC=${WT_ROOT}/include

export LD_LIBRARY_PATH="${BOOST_LIB}:${WT_LIB}:${LD_LIBRARY_PATH}"

sed -i 's|INSERT_DB_HOST_HERE|'"${DBHOST}"'|g' benchmark.cpp

g++-4.8 -O3 -DNDEBUG -DBENCHMARK_USE_POSTGRES -std=c++0x -L${BOOST_LIB} -I${BOOST_INC} -L${WT_LIB} -I${WT_INC} -o benchmark_postgres.wt benchmark.cpp -lwt -lwthttp -lwtdbo -lwtdbopostgres -lboost_thread

./benchmark_postgres.wt -c wt_config.xml -t ${MAX_THREADS} --docroot . --http-address 0.0.0.0 --http-port 8080 --accesslog=- --no-compression &