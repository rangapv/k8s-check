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

kfs=`kubectl create secret generic aws-secret --from-file=aws.conf=/etc/kubernetes/aws.conf --from-file=config=$HOME/.kube/config --from-file=AWS_ACCESS_KEY_ID=$HOME/access_id --from-file=AWS_SECRET_ACCESS_KEY=$HOME/secret_id -n kube-system`
skfs="$?"

kfsac1=`kubectl create secret generic aws-access-1 --from-file=AWS_ACCESS_KEY_ID=$HOME/access_id -n kube-system`
skfsac1s="$?"
ssmstat aws-access-1 $skfsac1s
kfsac2=`kubectl create secret generic aws-access-2 --from-file=AWS_SECRET_ACCESS_KEY=$HOME/secret_id -n kube-system`
skfsac2s="$?"
ssmstat aws-access-2 $skfsac2s

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
	echo "$1 create successful"
else
	echo "$1 create failed"
fi
}


if [[ "$1" = "-d" ]]
then
	filesecretdel
	exit
fi




filecheck /etc/kubernetes/aws.conf $HOME/.kube/config $HOME/access_id $HOME/secret_id 

if [[ $gcount -eq $tf ]]
then
	echo "All the files required to create the aws-secret are present"
	filesecret 
else
	echo "Insufficent files to create aws-secret exiting"
fi
