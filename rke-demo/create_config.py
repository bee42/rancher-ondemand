#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

"""Helper-Script to generate cluster.yml for RKE

"""

import os
import json
import subprocess
from string import Template


def main():

    # get SSH-Key-Path for injection in template
    ssh_key_path=os.environ['TF_VAR_pvt_key']

    #get IPs from terraform-output for injection in template
    tf_output= subprocess.Popen("terraform output -json", shell=True, stdout=subprocess.PIPE).stdout.read()
    ips = json.loads(tf_output)
    cluster_ips = ips['public_ips']['value']

    # Substitute vars in rke-cluster-template 
    filein = open("cluster.template")
    src = Template(filein.read())
    d = {'server0':cluster_ips[0],'server1':cluster_ips[1],'server2':cluster_ips[2],'ssh_key_path':ssh_key_path}
    result = src.substitute(d)

    # Write cluster.yml
    text_file = open("cluster.yml", "w")
    text_file.write(result)
    text_file.close()

if __name__ == '__main__':
    main()

