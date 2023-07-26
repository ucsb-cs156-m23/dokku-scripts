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

function https_all_happycows {
   https_all `happycows_urls`
}



