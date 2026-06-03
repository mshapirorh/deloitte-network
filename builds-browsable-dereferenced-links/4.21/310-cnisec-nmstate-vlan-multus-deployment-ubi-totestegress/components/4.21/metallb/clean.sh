#!/bin/bash
# BEWARE: This is crude, hacky, unsafe, and was written in anger.
# It almost definitely isn't the right way to clean things.
# It destroys the CRDs first, preventing the running operator from repairing anything. 
# It then proceeds to clean up the operator and the metallb objects.
# Todo: Clean the FRR stuff in the openshift-frr-k8s namespace too, not just metallb-system.
# (Or do the civilized thing, throw this in the bin, and write graceful, by-the-manual operator removal)
# If it makes your eyes want to bleed
# DO NOT channel anger at author
# DO NOT channel anger into /dev/null
# DO channel anger into writing a better version. 

# Delete stuff outside operators first, as you need the crds to work for this to work:
for x in `oc get crd| awk '/metallb/{print "crd/"$1}'`; do
  echo "oc delete ${x} -n openshift-operators"
  oc delete ${x} -n openshift-operators
done
oc delete metallb -n metallb-system metallb
oc delete ipaddresspool,bgppeer,bgpadvertisement,l2advertisement,bfdprofile,community --all -n metallb-system

oc delete subscription metallb-operator -n openshift-operators
# Find the install plan:
installplan=`oc get installplan -n openshift-operators|awk '/metallb-operator/{print $1}'`
# Delete it:
oc delete installplan -n openshift-operators "${installplan}"

oc project openshift-operators
echo "Leftovers:"
for x in `oc get all 2>/dev/null| awk '/metallb/{print $1}'`; do
  echo "oc delete ${x} -n openshift-operators"
  oc delete ${x} -n openshift-operators
done
for x in `oc get csvs| awk '/metallb/{print "csvs/"$1}'`; do
  echo "oc delete ${x} -n openshift-operators"
  oc delete ${x} -n openshift-operators
done


