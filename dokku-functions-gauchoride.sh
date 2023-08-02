#!/usr/bin/env bash

source dokku-functions.sh
source .env

function gauchoride_urls {
  echo \
    https://proj-gauchoride-s23-5pm-1.dokku-12.cs.ucsb.edu \
    https://proj-gauchoride-s23-5pm-2.dokku-12.cs.ucsb.edu \
    https://proj-gauchoride-s23-5pm-3.dokku-12.cs.ucsb.edu \
    https://proj-gauchoride-s23-5pm-4.dokku-12.cs.ucsb.edu \
    https://gauchoride.dokku-00.cs.ucsb.edu \
    https://gauchoride-qa.dokku-00.cs.ucsb.edu 
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

function https_all_gauchoride {
   https_all `gauchoride_urls`
}

function db_all_gauchoride {
   db_all `gauchoride_urls`
}

function google_oauth_all_gauchoride {
   google_oauth_all `gauchoride_urls`
}

function git_sync_main_all_gauchoride {
   git_sync_main_all `gauchoride_urls`
}

function ps_rebuild_all_gauchoride {
   ps_rebuild_all `gauchoride_urls`
}

function admin_emails_all_gauchoride {
   admin_emails_all `gauchoride_urls`
}


