#!/bin/bash

source .env
source teams.sh

declare -A TEAM_TO_DOKKU
declare -A DOKKU_TO_TEAM

for ((i = ((${#TEAMS[@]} - 1)); i >= 0; i--)); do
    team=${TEAMS["$i"]}
    dokku=${DOKKUS["$i"]}
    TEAM_TO_DOKKU[$team]=$dokku
    DOKKU_TO_TEAM[$dokku]=$team
done

declare -A TEAM_TO_APP

for t in ${COURSES_TEAMS}; do TEAM_TO_APP[$t]=courses; done
for t in ${HAPPYCOWS_TEAMS}; do TEAM_TO_APP[$t]=happycows; done
for t in ${ORGANIC_TEAMS}; do TEAM_TO_APP[$t]=organic; done
for t in ${GAUCHORIDE_TEAMS}; do TEAM_TO_APP[$t]=gauchoride; done

COURSES_DOKKUS=""
HAPPYCOWS_DOKKUS=""
ORGANIC_DOKKUS=""
GAUCHORIDE_DOKKUS=""

for team in ${COURSES_TEAMS}; do COURSES_DOKKUS="${COURSES_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done
for team in ${HAPPYCOWS_TEAMS}; do HAPPYCOWS_DOKKUS="${HAPPYCOWS_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done
for team in ${ORGANIC_TEAMS}; do ORGANIC_DOKKUS="${ORGANIC_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done
for team in ${GAUCHORIDE_TEAMS}; do GAUCHORIDE_DOKKUS="${GAUCHORIDE_DOKKUS} ${TEAM_TO_DOKKU[$team]}"; done


# Set up APP_URL_TO_* mappings

declare -A APP_URL_TO_CLIENT_ID
declare -A APP_URL_TO_CLIENT_SECRET
declare -A APP_URL_TO_UCSB_API_KEY
declare -A APP_URL_TO_GITHUB_URL
declare -A APP_URL_TO_ADMIN_EMAILS

echo "courses..."

for d in ${COURSES_DOKKUS}; do
    prod_url="https://courses.dokku-${d}.cs.ucsb.edu"
    qa_url="https://courses-qa.dokku-${d}.cs.ucsb.edu"
    team=${DOKKU_TO_TEAM[$d]}
    for url in $prod_url $qa_url ; do
        APP_URL_TO_CLIENT_ID[$url]=${PROJ_TO_CLIENT_ID[courses]}
        APP_URL_TO_CLIENT_SECRET[$url]=${PROJ_TO_CLIENT_SECRET[courses]}
        APP_URL_TO_UCSB_API_KEY[$url]=${PROJ_TO_UCSB_API_KEY[courses]}
        APP_URL_TO_GITHUB_URL[$url]=https://github.com/ucsb-cs156-${QXX}/proj-courses-${team}
        APP_URL_TO_MONGO_URI[$url]=${TEAM_TO_MONGO_URI[$team]}
    done
    APP_URL_TO_ADMIN_EMAILS[$prod_url]="${ALL_STAFF_EMAILS},${TEAM_TO_ADMIN_EMAILS[$team]}"
    APP_URL_TO_ADMIN_EMAILS[$qa_url]="${ALL_STAFF_EMAILS},${ALL_STUDENT_EMAILS}"
done





