#!/usr/bin/env bash

source SAMPLE.env # so that at least everything has a default value and the script doesn't fail
source .env        # so that things will have a correct value

function git_sync {
    # Example:
    # git_sync dokku-01.cs.ucsb.edu proj-gauchoride-qa https://github.com/ucsb-cs156-s23/proj-gauchoride-s23-5pm-1 xy-new-feature
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    app=${2} # e.g. proj-gauchoride-qa
    url=${3} # e.g. https://github.com/ucsb-cs156-s23/proj-gauchoride-s23-5pm-1
    branch=${4} # xy-new-feature
    
    ssh $host dokku git:sync $app $url $branch
}

function list_apps {
    # Example:
    # list_apps dokku-01.cs.ucsb.edu 
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    
    RESULT=`ssh $host dokku apps:list | grep -v "=====> My Apps"`
    echo $RESULT
}

function matching_apps {
    # Example:
    # matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-01.cs.ucsb.edu
    regex=${2} # e.g. "^jpa03-.*$"

    RESULT=`ssh $host dokku apps:list | grep -v "=====> My Apps" | grep $regex`
    echo $RESULT

}

function unlink_and_destroy_db {
    # Example:
    # unlink_and_destroy_db dokku-05.cs.ucsb.edu proj-courses-s23-7pm-3
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    app=${2} # e.g. proj-courses-s23-7pm-3
    
    db=${2}-db 

    ssh $host dokku ps:stop $app
    ssh $host dokku postgres:unlink ${db} ${app}
    ssh $host dokku postgres:destroy ${db} --force
}

function destroy {
    # Example:
    # unlink_and_destroy_db dokku-05.cs.ucsb.edu proj-courses-s23-7pm-3
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    app=${2} # e.g. proj-courses-s23-7pm-3
    
    unlink_and_destroy_db $host $app
    ssh $host dokku apps:destroy $app --force
}

function destroy_matching_apps {
    # Example:
    # destroy_matching_apps dokku-01.cs.ucsb.edu "^jpa03-.*$"
    host=${1} # e.g. dokku-05.cs.ucsb.edu
    regex=${2} # e.g. "^proj-courses-s23-.*$"
    
    for app in $(matching_apps $host $regex); do
        destroy $host $app
    done
}

function all_dokku_nums {
    echo "00 01 02 03 04 05 06 07 08 09 10 11 12"
}


function destroy_matching_apps_all_hosts {
    # Example:
    # destroy_all_matching_apps "^team02-.*$"
     regex=${1} # e.g. "^team02-.*$"
    
    for d in `all_dokku_nums`; do
        destroy_matching_apps dokku-${d}.cs.ucsb.edu $regex
    done
}

function matching_apps_all_hosts {
    # Example:
    # destroy_all_matching_apps "^team02-.*$"
     regex=${1} # e.g. "^team02-.*$"
    
    ALL_HOSTS=""
    for d in `all_dokku_nums`; do
        ALL_HOSTS="${ALL_HOSTS} "`matching_apps dokku-${d}.cs.ucsb.edu $regex`
    done
    echo ${ALL_HOSTS}
}

function all_hosts_do {
    # Example:
    # all_hosts_do dokku apps:list
    for d in `all_dokku_nums`; do
        ssh dokku-${d}.cs.ucsb.edu $@
    done
}


function url_to_host {
  url=${1}
  # remove all chars up to first . from arg, that should be the host
  host=`echo $url  | sed 's/[^\.]*\.//'`
  echo $host
} 

function url_to_app {
 url=${1}
 # remove all chars after first ., then all chars up to //
 host=`echo $url  | sed 's/\..*//' | sed 's/.*\/\///'`
 echo $host

}

function apps_create_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Creating dokku app for ${url}..."
    ssh $host "dokku apps:create $app; dokku config:set --no-restart $app PRODUCTION=true"
  done
}

function https_all {
  all=$@
  for i in ${all} ; do 
    host=`url_to_host $i`
    app=`url_to_app $i`
    echo "Setting up https for ${i}..."
    ssh $host dokku "letsencrypt:set $app email phtcon@ucsb.edu;  dokku letsencrypt:enable $app"
  done
}

function db_all {
  all=$@
  for i in ${all} ; do 
    host=`url_to_host $i`
    app=`url_to_app $i`
    echo "Setting up db for ${i}..."
    ssh $host dokku postgres:create ${app}-db
    ssh $host dokku postgres:link ${app}-db ${app}
    RESULT=`ssh $host dokku config:show ${app} | egrep "^DATABASE_URL"`
    if [ "$RESULT" == "" ]; then
        RESULT=`ssh $host dokku config:show ${app} | egrep "^DOKKU_POSTGRES_.*_URL"`
    fi
    PASSWORD=`echo "$RESULT" |  awk -F[:@] '{print $4}'`
    DATABASE=`echo "$RESULT" |  awk -F[/] '{print $4}'`

    IP=`dokku postgres:info ${app}-db | grep "Internal ip:"`
    IP=`echo ${IP/Internal ip: /} | tr -d '[:space:]'`
    URL="jdbc:postgresql://${IP}:5432/${DATABASE}"
    ssh $host "dokku config:set --no-restart ${app} JDBC_DATABASE_URL=${URL} ; \
               dokku config:set --no-restart ${app} JDBC_DATABASE_USERNAME=postgres ; \
               dokku config:set --no-restart ${app} JDBC_DATABASE_PASSWORD=${PASSWORD} ; \
               dokku config:set --no-restart ${app} PRODUCTION=true "
    ssh $host dokku config:show ${app}
  done
}

function google_oauth_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Setting up google oauth for ${url}... host=${host} app=${app}"

    GOOGLE_CLIENT_ID=${APP_URL_TO_CLIENT_ID[$url]}
    GOOGLE_CLIENT_SECRET=${APP_URL_TO_CLIENT_SECRET[$url]}

    ssh $host " \
      dokku config:set --no-restart ${app} GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID} ;\
      dokku config:set --no-restart ${app} GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET} ;\
      dokku config:show ${app} \
    "
  done
}

function admin_emails_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Setting up admin_emails for ${url}... host=${host} app=${app}"
    ssh $host dokku config:set --no-restart ${app} ADMIN_EMAILS=${APP_URL_TO_ADMIN_EMAILS[$url]}
  done
}

function git_sync_main_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Performing git sync on main branch for ${url}... host=${host} app=${app}"

    GITHUB_URL=${APP_URL_TO_GITHUB_URL[$url]}
    echo "GITHUB_URL=$GITHUB_URL"

    ssh $host dokku git:sync ${app} ${GITHUB_URL} main
      
  done
}

function ps_rebuild_all {
  all=$@
  for url in ${all} ; do 
    host=`url_to_host $url`
    app=`url_to_app $url`
    echo "Performing ps:rebuild for ${url}... host=${host} app=${app}"
    ssh $host dokku ps:rebuild ${app} 
  done
}



function full_app_create_all {
   all=$@
   echo "full_app_create_all underway for:"
   for url in $all; do 
     echo "  $url"
   done
   apps_create_all $all
   https_all $all
   db_all $all
   google_oauth_all $all
   admin_emails_all $all
   git_sync_main_all $all
   ps_rebuild_all $all
   echo "full_app_create_all done for:"
   for url in $all; do 
     echo "  $url"
   done
}
