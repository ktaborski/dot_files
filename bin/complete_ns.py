#!/usr/bin/env python
import yaml
import os
import sys
import subprocess

CACHE_FILE = os.path.expanduser("~/.ns_cache.yaml")
KUBECONFIG = os.path.expanduser("~/.kube/config")
KUBECONFIG_DATA = {}

def get_context():
    return KUBECONFIG_DATA['current-context']

def update():
    data = {}
    for context in KUBECONFIG_DATA['contexts']:
        print(context)
        context_name = context['name']
        if context_name == 'minikube':
            continue
        try:
            ns = subprocess.check_output(['timeout', '15', 'kubectl', '--context', context_name, 'get', 'ns', '-o', 'name']).decode().split('\n')
            data[context_name] = [x.replace('namespace/', '') for x in ns if x]
        except subprocess.CalledProcessError as err:
            print(f"failed to update {context}, {err}")
            data[context_name] = []
            continue
    print(f"updating {CACHE_FILE}")
    with open(CACHE_FILE, 'w') as outfile:
        yaml.dump(data, outfile, default_flow_style=False)

def complete():
    with open(CACHE_FILE, "r") as f:
        cache_data = yaml.safe_load(f)
    print(" ".join(cache_data[get_context()]))

with open(KUBECONFIG, "r") as stream:
    KUBECONFIG_DATA = yaml.safe_load(stream)

if len(sys.argv) > 1 and sys.argv[1] == 'update':
    update()
else:
    complete()