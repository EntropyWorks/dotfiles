# Trying to auto generate my settings for all the different zones
# we have here at HPCS
AVALABILITY_ZONES="rnda rndb rndc rnde rndd st1 st2"
#
if [ -s "${HOME}/.cloud_secrets" ] ; then
  source "${HOME}/.cloud_secrets"
  rm -f ${HOME}/.bash_rnd_zones
  echo "# This was generated with ~/dotfiles/build-zones.sh" > ${HOME}/.bash_rnd_zones
  echo "# the private varables are sourced from ~/.cloud_secrets " >> ${HOME}/.bash_rnd_zones
  echo "# " >> ${HOME}/.bash_rnd_zones
  for zone in $* ${AVALABILITY_ZONES}
  do
  cat <<EOF>> ${HOME}/.bash_rnd_zones
  ${zone}-knife(){
    export CURRENT_KNIFE_ENV="\$${zone}_knife"
    knife block use \${CURRENT_KNIFE_ENV}
  }
  ${zone}-1(){
    # ${zone}-1 settings 
    export OS_TENANT_NAME="\$${zone}_tenant"
    export OS_USERNAME="\$${zone}_username"
    export OS_PASSWORD="\$${zone}_password"
    export OS_REGION_NAME="\$${zone}_region_name_1"
    export OS_AUTH_URL="\$${zone}_auth_url"
    export CLOUD_PROMPT="\${UGreen}${zone}-1\${Color_Off}"
    export CURRENT_RUBY="\$${zone}_rvm"
    rvm \${CURRENT_RUBY}
    export CURRENT_PYTHON="\$${zone}_python"
    source \${CURRENT_PYTHON}
    ${zone}-knife 
  }
  ${zone}-2(){
    export OS_TENANT_NAME="\$${zone}_tenant"
    export OS_USERNAME="\$${zone}_username"
    export OS_PASSWORD="\$${zone}_password"
    export OS_REGION_NAME="\$${zone}_region_name_2"
    export OS_AUTH_URL="\$${zone}_auth_url"
    export CLOUD_PROMPT="\${UBlue}${zone}-2\${Color_Off}"
    export CURRENT_RUBY="\$${zone}_rvm"
    rvm \${CURRENT_RUBY}
    export CURRENT_PYTHON="\$${zone}_python"
    source \${CURRENT_PYTHON}
    ${zone}-knife 
  }
  ${zone}-3(){
    # ${zone}-1 settings 
    export OS_TENANT_NAME="\$${zone}_tenant"
    export OS_USERNAME="\$${zone}_username"
    export OS_PASSWORD="\$${zone}_password"
    export OS_REGION_NAME="\$${zone}_region_name_3"
    export OS_AUTH_URL="\$${zone}_auth_url"
    export CLOUD_PROMPT="\${URed}${zone}-3\${Color_Off}"
    export CURRENT_RUBY="\$${zone}_rvm"
    rvm \${CURRENT_RUBY}
    export CURRENT_PYTHON="\$${zone}_python"
    source \${CURRENT_PYTHON}
    ${zone}-knife 
  }
EOF
  done
else
  echo "You need to have a ${HOME}/.cloud_secrets file"
fi
