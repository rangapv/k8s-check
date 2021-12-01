#!/bin/bash
set -E

ccmimage() {

ccmi=`kubectl apply -f https://gist.githubusercontent.com/rangapv/19c52b5a602bd01233cfeb069e08ebf3/raw/58f16f1e574aac84b54ca6b92ab11a086fe55373/ccm-aws.yaml`
ccmis="$?"
if [[ $ccmis -eq 0 ]]
then
	echo "CCM Cloud Container Pull successful"
else
	echo "CCM Cloud container Pull failed"
fi

}

sts=`kubectl describe secret aws-secret -n kube-system`
stss="$?"

if [[ $stss -eq 0 ]]
then
	echo "aws-secret present"
	ccmimage
else
	echo "aws=secret not-present"
fi
