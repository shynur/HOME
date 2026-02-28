#! /bin/bash

if [ $# != 1 ]; then
    echo "Usage: $0 <C++ compiler>"
    return 1
fi

CXX=$1

for ((cppstd=26+30; cppstd>=11; cppstd-=3)); do
    if $CXX -E -std=c++$cppstd <(echo 'int i;') &>/dev/null; then
        echo $cppstd
        exit
    fi
done

exit 1
