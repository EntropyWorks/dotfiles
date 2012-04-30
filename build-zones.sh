# Trying to auto generate my settings for all the different zones
# we have here at HPCS
if [ -s "${HOME}/.bash_cloud_secrets" ] ; then
  source "${HOME}/.bash_cloud_secrets"
  rm -f ${HOME}/.bash_openstack_zones
  echo "# This was generated with ~/dotfiles/build-zones.sh" > ${HOME}/.bash_openstack_zones
  for zone in rndb rndc rnde rndd st1 st2
  do
  cat <<EOF>> ${HOME}/.bash_openstack_zones
  ${zone}-1(){
    export OS_TENANT_NAME="${tenant_1}"
    export OS_USERNAME="${username_1}"
    export OS_PASSWORD="${password_1}"
    export OS_REGION_NAME="az-1.region-a.geo-1"
    export OS_AUTH_URL="${os_auth_url_2:-${os_auth_url_0}}"
    export CLOUD_PROMPT="${Green}${UGreen}${zone}${Color_Off}"
    CURRENT_RUBY="${ruby_rvm_0:-${rvm_${zone}}}"
    rvm ${ruby_rvm_0:-rvm_${zone}}
    CURRENT_PYTHON="${python_virtualenv_0:-${python_${zone}}}"
    source "${python_virtualenv_0:-${python_${zone}}}"
  }
  ${zone}-2(){
    export OS_TENANT_NAME="${tenant_1}"
    export OS_USERNAME="${username_2}"
    export OS_PASSWORD="${password_2}"
    export OS_REGION_NAME="az-2.region-a.geo-1"
    export OS_AUTH_URL="${os_auth_url_2:-${os_auth_url_0}}"
    export CLOUD_PROMPT="${Green}${UBlue}${zone}${Color_Off}"
    CURRENT_RUBY="${ruby_rvm_0:-${rvm${zone}}}"
    rvm "${ruby_rvm_0:-${rvm_${zone}-2}}"
    CURRENT_PYTHON="${python_virtualenv_0:-${python_${zone}}}"
    source "${python_virtualenv_0:-${python_${zone}}}"
  }
EOF
  done
else
  echo "You need to have a ${HOME}/.bash_cloud_secrets file"
fi
