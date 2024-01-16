#!/usr/bin/env bash

source dokku-functions.sh
source .env

function happycows_urls {
  echo \
    https://happycows.dokku-01.cs.ucsb.edu \
    https://happycows.dokku-02.cs.ucsb.edu \
    https://happycows.dokku-03.cs.ucsb.edu \
    https://happycows.dokku-04.cs.ucsb.edu \
    https://happycows-qa.dokku-01.cs.ucsb.edu \
    https://happycows-qa.dokku-02.cs.ucsb.edu \
    https://happycows-qa.dokku-03.cs.ucsb.edu \
    https://happycows-qa.dokku-04.cs.ucsb.edu 
}

function https_all_happycows {
   https_all `happycows_urls`
}

function db_all_happycows {
   db_all `happycows_urls`
}

function google_oauth_all_happycows {
   google_oauth_all `happycows_urls`
}

function git_sync_main_all_happycows {
   git_sync_main_all `happycows_urls`
}

function ps_rebuild_all_happycows {
   ps_rebuild_all `happycows_urls`
}

function admin_emails_all_happycows {
   admin_emails_all `happycows_urls`
}

