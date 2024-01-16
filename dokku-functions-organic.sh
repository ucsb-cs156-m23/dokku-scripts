#!/usr/bin/env bash

source dokku-functions.sh
source .env

function organic_urls {
  echo \
    https://organic.dokku-05.cs.ucsb.edu \
    https://organic.dokku-06.cs.ucsb.edu \
    https://organic.dokku-07.cs.ucsb.edu \
    https://organic.dokku-08.cs.ucsb.edu \
    https://organic-qa.dokku-05.cs.ucsb.edu \
    https://organic-qa.dokku-06.cs.ucsb.edu \
    https://organic-qa.dokku-07.cs.ucsb.edu \
    https://organic-qa.dokku-08.cs.ucsb.edu 
}

function https_all_organic {
   https_all `organic_urls`
}

function db_all_organic {
   db_all `organic_urls`
}

function google_oauth_all_organic {
   google_oauth_all `organic_urls`
}

function git_sync_main_all_organic {
   git_sync_main_all `organic_urls`
}

function ps_rebuild_all_organic {
   ps_rebuild_all `organic_urls`
}

function github_logins_all_organic {
   github_logins_all `organic_urls`
}

