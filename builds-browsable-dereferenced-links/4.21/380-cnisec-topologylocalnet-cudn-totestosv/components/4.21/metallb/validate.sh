#!/bin/bash -x
vrf=vrf100
oc project openshift-frr-k8s
oc get pods
# oc exec -n openshift-frr-k8s frr-k8s-d6qwk -c frr -- vtysh -c "show bgp vrf vrf100 neighbors 10.2.100.254"
#for pod in `oc get -n metallb-system pods -l component=speaker|awk '/speaker/{print $1}'`; do
echo "BGP State:"
for pod in `oc get pods |grep frr-k8s|grep -v statuscleaner |awk '{print $1}'`; do
  echo $pod
  # oc exec $pod -c frr -- vtysh -c "show bgp vrf vrf100 neighbors"
  # oc exec $pod -c frr -- vtysh -c "show bgp vrf vrf100 ipv4"
  oc exec $pod -c frr -- vtysh -c "show bgp summary"
#  oc exec -n metallb-system $pod -c frr -- vtysh -c "show bgp neigh"
#  oc exec -n metallb-system $pod -c frr -- vtysh -c "show bgp ipv4"
done

