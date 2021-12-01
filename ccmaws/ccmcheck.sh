#!/bin/bash
set -E
gcount=0

filecheck() {
f1="$@"

if [[ -f $f1 ]]
then
	((gcount+=1))
else
	echo "File does not exist $f1"
	exit
fi

}

filesecret() {

kfs=`kubectl create secret generic aws-secret --from-file=aws.conf=/etc/kubernetes/aws.conf --from-file=config=$HOME/.kube/config --from-file=AWS_ACCESS_KEY_ID=$HOME/access_id --from-file=AWS_SECRET_ACCESS_KEY=$HOME/secret_id -n kube-system`
skfs="$?"

kfsac1=`kubectl create secret generic aws-access-1 --from-file=AWS_ACCESS_KEY_ID=$HOME/access_id -n kube-system`
skfsac1s="$?"
ssmstat aws-access-1 $skfsac1s
kfsac2=`kubectl create secret generic aws-access-2 --from-file=AWS_SECRET_ACCESS_KEY=$HOME/secret_id -n kube-system`
skfsac2s="$?"
ssmstat aws-access-2 $skfsac2s

}

ssmstat() {

ssmstat1="$@"

if [[ $2 -eq 0 ]]
then
	echo "$1 create successful"
else
	echo "$1 create failed"
fi
}

filecheck /etc/kubernetes/aws.conf
filecheck $HOME/.kube/config
filecheck $HOME/access_id 
filecheck $HOME/secret_id

if [[ $gcount -eq 4 ]]
then
	echo "All the files required to create the aws-secret are present"
	filesecret 
else
	echo "Insufficent files to create aws-secret exiting"
fi
