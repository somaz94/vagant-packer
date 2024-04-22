#!/bin/bash

function _base_show_usage() {
  echo ""
  echo -e "Usage: somazenv.sh <command> [arg]\n"
  echo -e "Commands:"
  echo -e "  status    Outputs status of VM Server"
  echo -e "  start     Create trainning VM Server and Start up"
  echo -e "  stop      Halt all trainning VM server and [force] option is will force stop"
  echo -e "  rebuild   Rebuild all trainning VM server"
  echo -e "  revert    [somaz] or [somazpc] Revert trainning VM server"
  echo -e "  snapshot  Create snapshot current state"
  echo -e "\n"
  exit 0
} 

function _vm_stop_status() {

  echo "Check VM Status...."
  virsh_status=$(virsh list --name | grep somazpc)

  if [ -n "$virsh_status" ]; then
    echo "Some vm is running. It will stop all vm"
    for vm_name in `virsh list --name | grep somazpc`; do virsh destroy $vm_name; done
    vagrant halt -f 

  else
    echo "Complete All vm is stoped." 
  fi
 
}  

function _win10_reattach_inf() {

  win10_mac=$(virsh domiflist win10 | grep virbr1 | awk '{print $5}')
  virsh detach-interface win10 bridge --mac $win10_mac
  virsh attach-interface win10 bridge virbr1

}

function _build_vm() {

  _vm_stop_status

  is_service_network=$(virsh net-list | grep service | awk '{print $1}')

  if [ "$is_service_network" != "service" ]; then   

    echo "service netowrk will create"
    virsh net-define net-service.xml
    virsh net-start service
    vagrant up
  elif [ $f_name = "somazpc-run" ]; then
    for vm_name in `virsh list --name --all | grep $f_name`; do virsh start $vm_name; done
  else
    vagrant up
  fi

  if [ $win10_state != "running" ]; then
    virsh start win10
  fi

}

function _rebuild_vm() {

  _vm_stop_status
  vagrant destroy -f
  _build_vm

  if [ $win10_state = "running" ]; then
  _win10_reattach_inf
  fi

}

function _revert_vm() {

  if [ $# -lt 1 ] || [ $1 != "somaz" ] && [ $1 != "somazpc" ]; then
    _base_show_usage
    exit 1
  fi

  _vm_stop_status

  echo "All VM will revert to $1 installed status. it need take about 30min."

  for vm_name in `virsh list --name --all | grep $f_name`
  do
    virsh snapshot-revert $vm_name --snapshotname $vm_name-$1
  done;

  for vm_name in `virsh list --name --all | grep $f_name`; do virsh start $vm_name; done

  result="revert complete"
}

function _stop_vm() {

  if [ $# != 0 ] && [ $1 != "force" ]; then
    _base_show_usage
    exit 1
  elif [ $# != 0 ] && [ $1 = "force" ]; then
    for vm_name in `virsh list --name | grep somazpc`; do virsh destroy $vm_name; done
    vagrant halt -f 
  else
    vagrant halt 
  fi

}

function _status_vm() {

  virsh list --all

}

command=$1
arg=$2
running_vm_list=$(virsh list --name | grep somazpc)
win10_state=$(virsh domstate win10)
f_name=${PWD##*/}

if [ "$command" = "" ]; then
  _base_show_usage
  exit 0

else
    case "$command" in
            "status")
                       _status_vm ;;
            "start")
                       _build_vm ;;
            "rebuild")
                      _rebuild_vm ;;
            "revert")
                      _revert_vm $arg;;
            "stop")
                      _stop_vm $arg;;
            *)
                      _base_show_usage
                      exit 1
                      ;;
    esac
fi

echo $result
