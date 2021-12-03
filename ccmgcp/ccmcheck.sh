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

kfs=`kubectl create secret generic gce-secret --from-file=gce.conf=/etc/kubernetes/gce.conf --from-file=config=$HOME/.kube/config -n kube-system`
skfs="$?"
ssmstat gce-secret-create $skfs

}


filesecretdel() {


kfsd=`kubectl delete secret gce-secret -n kube-system`
kfsds="$?"
ssmstat gce-secret-delete $kfsds

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
	filecheck /etc/kubernetes/gce.conf $HOME/.kube/config
fi

if [[ $gcount -eq $tf ]]
then
	echo "All the files required to create the gce-secret are present"
	filesecret 
else
	echo "Insufficent files to create gce-secret exiting"
fi
