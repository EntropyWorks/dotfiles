# Trying to auto generate my settings for all the different zones
# we have here at HPCS
AVALABILITY_ZONES=$(grep _knife ~/.cloud_secrets |grep -v \"\" | cut -d "_" -f 1)

#
if [ -s "${HOME}/.cloud_secrets" ] ; then
  source "${HOME}/.cloud_secrets"
  rm -f ${HOME}/.bash_rnd_zones
  echo "# This was generated with ~/dotfiles/build-zones.sh" > ${HOME}/.bash_rnd_zones
  echo "# the private varables are sourced from ~/.cloud_secrets " >> ${HOME}/.bash_rnd_zones
  echo "# " >> ${HOME}/.bash_rnd_zones
  echo "source \${HOME}/.cloud_secrets" >> ${HOME}/.bash_rnd_zones
  echo "export NOVA_VERSION=1.1" >> ${HOME}/.bash_rnd_zones

cat <<EOF>> ${HOME}/.bash_rnd_zones
check-knife(){
  if [ -z "\${1}" ] ; then
    echo "- No zone passed as parameter-"
  else
    knife_block="\$${1}_knife"
    readlink ~/.chef/knife.rb | grep knife-\${knife_block}
    if [ \$? -eq 1 ]   ; then
      \${1}-knife 
    fi
  fi
}
EOF

for zone in $* ${AVALABILITY_ZONES}
do
echo "Setting up ${zone}"
cat <<EOF>> ${HOME}/.bash_rnd_zones
# ${zone} change knife.rb
${zone}-knife(){
  export CURRENT_KNIFE_ENV="\$${zone}_knife"
  export CURRENT_RUBY="\$${zone}_rvm"
  rvm use \${CURRENT_RUBY}
  knife block use \${CURRENT_KNIFE_ENV}
}
# Items shared in ${zone}
shared-${zone}(){
  #
  export OS_TENANT_NAME="\$${zone}_tenant"
  export OS_USERNAME="\$${zone}_username"
  export OS_PASSWORD="\$${zone}_password"
  export OS_AUTH_URL="\$${zone}_auth_url"
  # 
  export NOVA_USERNAME="\$${zone}_username"
  export NOVA_API_KEY="\$${zone}_password"
  export NOVA_PROJECT_ID="\$${zone}_tenant"
  export NOVA_URL="\$${zone}_auth_url"
  #
  export HP_ACCOUNT="\$${zone}_tenant_id"
  export HP_SECRET="\$${zone}_api_secret"
  export HP_AUTH="\$${zone}_auth_url"
  #
  export CURRENT_RUBY="\$${zone}_rvm"
  export CURRENT_PYTHON="\$${zone}_python"
  # Setup python 
  source \${CURRENT_PYTHON}
  # Setup knife
  readlink ~/.chef/knife.rb | grep "knife-\$${zone}_knife"
  if [ \$? -eq 1 ]   ; then
    ${zone}-knife 
  fi
  #check-knife \$${zone}_knife
  # Setup ruby 
  rvm use \${CURRENT_RUBY}
}
# ${zone}-1 settings 
${zone}-1(){
  shared-${zone}

  export HP_AVL_ZONE="az1"
  export OS_REGION_NAME="\$${zone}_region_name_1"

  export AWS_ACCESS_KEY_ID="\$${zone}_api_1"
  export AWS_SECRET_ACCESS_KEY="\$${zone}_api_secret"
  export AWS_ACCESS_KEY=\$AWS_ACCESS_KEY_ID
  export AWS_SECRET_KEY=\$AWS_SECRET_ACCESS_KEY

  export CLOUD_PROMPT="\${UGreen}${zone}-1\${Color_Off}"
}
# ${zone}-2 settings 
${zone}-2(){
  shared-${zone}

  export HP_AVL_ZONE="az2"
  export OS_REGION_NAME="\$${zone}_region_name_2"

  export AWS_ACCESS_KEY="\$${zone}_api_2"
  export AWS_SECRET_ACCESS_KEY="\$${zone}_api_secret"
  export AWS_ACCESS_KEY=\$AWS_ACCESS_KEY_ID
  export AWS_SECRET_KEY=\$AWS_SECRET_ACCESS_KEY

  export CLOUD_PROMPT="\${UBlue}${zone}-2\${Color_Off}"
}
# ${zone}-3 settings 
${zone}-3(){
  shared-${zone}

  export HP_AVL_ZONE="az3"
  export OS_REGION_NAME="\$${zone}_region_name_3"

  export AWS_ACCESS_KEY="\$${zone}_api_3"
  export AWS_SECRET_ACCESS_KEY="\$${zone}_api_secret"
  export AWS_ACCESS_KEY=\$AWS_ACCESS_KEY_ID
  export AWS_SECRET_KEY=\$AWS_SECRET_ACCESS_KEY

  export CLOUD_PROMPT="\${URed}${zone}-3\${Color_Off}"
}
EOF
  done
else
  echo "You need to have a ${HOME}/.cloud_secrets file"
fi
