export TF_VAR_do_token=REPLACE_ME_WITH_YOUR_DIGITALOCEAN_TOKEN
export TF_VAR_pvt_key=$HOME/.ssh/id_rsa-tf
export TF_VAR_pub_key=${TF_VAR_pvt_key}.pub
export TF_VAR_ssh_fingerprint=`ssh-keygen -E md5 -lf ${TF_VAR_pub_key} | awk '{print $2}' | sed 's/^MD5://g'`
alias tf=terraform
