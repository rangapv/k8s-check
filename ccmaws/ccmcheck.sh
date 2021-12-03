#!/bin/bash
set -E
gcount=0

filecheck() {
f1=("$@")
tf="$#"

for f in "${f1[@]}" 
do
if [[ -f $f ]]
then
	((gcount+=1))
else
	echo "File does not exist $f"
	exit
fi
done
}

filesecret() {

kfs=`kubectl create secret generic aws-secret --from-file=aws.conf=/etc/kubernetes/aws.conf --from-file=config=$HOME/.kube/config -n kube-system`
skfs="$?"

echo "Pls input Access key ID for aws"
read access1
echo "Pls input Secret key ID for aws"
read access2

kfsac1=`kubectl create secret generic aws-access-1 --from-literal=AWS_ACCESS_KEY_ID=$access1 -n kube-system`
skfsac1s="$?"
ssmstat aws-access-1-create $skfsac1s
kfsac2=`kubectl create secret generic aws-access-2 --from-literal=AWS_SECRET_ACCESS_KEY=$access2 -n kube-system`
skfsac2s="$?"
ssmstat aws-access-2-create $skfsac2s

}


filesecretdel() {


kfsd=`kubectl delete secret aws-secret -n kube-system`
kfsds="$?"
ssmstat aws-secret-delete $kfsds
kfsac1d=`kubectl delete secret aws-access-1 -n kube-system`
kfsac1ds="$?"
ssmstat aws-access-1-delete $kfsac1ds
kfsac2d=`kubectl delete secret aws-access-2 -n kube-system`
kfsac2ds="$?"
ssmstat aws-access-2-delete $kfsac2ds

}

ssmstat() {

ssmstat1="$@"

if [[ $2 -eq 0 ]]
then
	echo "$1 successful"
else
	echo "$1 failed"
fi
}


if [[ "$1" = "-d" ]]
then
	filesecretdel
	exit
else
	filecheck /etc/kubernetes/aws.conf $HOME/.kube/config
fi

if [[ $gcount -eq $tf ]]
then
	echo "All the files required to create the aws-secret are present"
	filesecret 
else
	echo "Insufficent files to create aws-secret exiting"
fi
