#!/usr/bin/env bash

source dokku-functions.sh
source .env

function happycows_urls {
  echo \
    https://proj-happycows-s23-6pm-1.dokku-12.cs.ucsb.edu \
    https://proj-happycows-s23-6pm-2.dokku-12.cs.ucsb.edu \
    https://proj-happycows-s23-6pm-3.dokku-12.cs.ucsb.edu \
    https://proj-happycows-s23-6pm-4.dokku-12.cs.ucsb.edu \
    https://happycows.dokku-00.cs.ucsb.edu \
    https://happycows-qa.dokku-00.cs.ucsb.edu 
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


