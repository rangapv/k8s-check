#!/bin/bash
set -E

ccmimage() {
ccmrbac=`kubectl apply -f https://gist.githubusercontent.com/rangapv/57d979f384ba29b7527353ebaf00dbe2/raw/0b2aec8bf018ee9d4bb72798be22e79a9f8a3846/ccm-rbac.yaml`
ccmrbacs="$?"
ssmstat ccmrbac $ccmrbacs
#ccmi=`kubectl apply -f https://gist.githubusercontent.com/rangapv/19c52b5a602bd01233cfeb069e08ebf3/raw/58f16f1e574aac84b54ca6b92ab11a086fe55373/ccm-aws.yaml`
ccmi=`kubectl apply -f https://gist.githubusercontent.com/rangapv/262c2bb9598e44115d5335413bc8475d/raw/b49d667629910db19fde7ce2a374f537815e6fd0/ccm-aws-debug.yaml`
ccmis="$?"
ssmstat ccmimage $ccmis

}

ssmstat() {

ssmstat1="$@"

if [[ $2 -eq 0 ]]
then
	echo "$1 Cloud Container Pull successful"
else
	echo "$1 Cloud container Pull failed"
fi
}

sts=`kubectl describe secret aws-secret -n kube-system`
stss="$?"

if [[ $stss -eq 0 ]]
then
	echo "aws-secret present"
	ccmimage
else
	echo "aws-secret not-present"
fi
