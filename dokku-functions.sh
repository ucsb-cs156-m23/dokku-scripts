#!/usr/bin/env bash

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