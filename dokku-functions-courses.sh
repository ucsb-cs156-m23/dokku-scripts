#!/usr/bin/env bash

source dokku-functions.sh


function courses_urls {
  echo \
    https://courses-qa.dokku-01.cs.ucsb.edu \
    https://courses-qa.dokku-02.cs.ucsb.edu \
    https://courses-qa.dokku-03.cs.ucsb.edu \
    https://courses-qa.dokku-04.cs.ucsb.edu \
    https://courses.dokku-01.cs.ucsb.edu \
    https://courses.dokku-02.cs.ucsb.edu \
    https://courses.dokku-03.cs.ucsb.edu \
    https://courses.dokku-04.cs.ucsb.edu 
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

function https_all_courses {
   https_all `courses_urls`
}

function db_all_courses {
   db_all `courses_urls`
}

function google_oauth_all_courses {
   google_oauth_all `courses_urls`
}

function git_sync_main_all_courses {
   git_sync_main_all `courses_urls`
}

function ps_rebuild_all_courses {
   ps_rebuild_all `courses_urls`
}

function admin_emails_all_courses {
   admin_emails_all `courses_urls`
}


function full_app_create_all_courses {
 full_app_create_with_mongo_and_ucsb_api_key_all `courses_urls`
}
