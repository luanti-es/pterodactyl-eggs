#!/bin/sh
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DESCRIPTION
#   Entrypoint for Luanti Pterodactyl Yolk (5.6.0 and above)
#
# AUTHORS
#   OrugA <oruga@luanti.es>
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Be rude with errors
set -e;

im_exiting_now() {
  echo "Received $1 signal ... gracefully exiting now";
  exit 0;
};

# According rubenwardy, Luanti accepts SIGINT to gracefully stop the server
trap "im_exiting_now INT" INT;
#trap "im_exiting_now TERM" TERM;

echo "[entrypoint] Starting Luanti Pterodactyl Yolk";
echo "[entrypoint] ";

# The following variables are already present thanks to the Wings controller,
# according the source code, located at:
# https://github.com/pterodactyl/wings/blob/ae6c62905bd1dcffd3d73c571efba2d53667317a/server/server.go#L148
echo "[entrypoint] Wings environment variables";
echo "[entrypoint] - TZ ................: '${TZ}'";
echo "[entrypoint] - STARTUP ...........: '${STARTUP}'";
echo "[entrypoint] - SERVER_MEMORY .....: '${SERVER_MEMORY}'";
echo "[entrypoint] - SERVER_IP .........: '${SERVER_IP}'";
echo "[entrypoint] - SERVER_PORT .......: '${SERVER_PORT}'";
echo "[entrypoint] ";

# The following variables are already present thanks to the Egg definition:
echo "[entrypoint] Egg environment variables";
echo "[entrypoint] - SERVER_ADMIN_NAME .....: '${SERVER_ADMIN_NAME}'";
echo "[entrypoint] - SERVER_NAME ...........: '${SERVER_NAME}'";
echo "[entrypoint] - SERVER_DESC ...........: '${SERVER_DESC}'";
echo "[entrypoint] - SERVER_DOMAIN .........: '${SERVER_DOMAIN}'";
echo "[entrypoint] - SERVER_URL ............: '${SERVER_URL}'";
echo "[entrypoint] - SERVER_ANNOUNCE .......: '${SERVER_ANNOUNCE}'";
echo "[entrypoint] - SERVER_LIST_URL .......: '${SERVER_LIST_URL}'";
echo "[entrypoint] - SERVER_MOTD ...........: '${SERVER_MOTD}'";
echo "[entrypoint] - SERVER_MAX_USERS ......: '${SERVER_MAX_USERS}'";
echo "[entrypoint] - SERVER_PASSWORD .......: '<redacted>'";
echo "[entrypoint] - WORLD_NAME ............: '${WORLD_NAME}'";
echo "[entrypoint] - DEFAULT_GAME ..........: '${DEFAULT_GAME}'";
echo "[entrypoint] - MINETEST_GAME_PATH ....: '${MINETEST_GAME_PATH}'";
echo "[entrypoint] ";

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`;
echo "[entrypoint] Modified startup string:";
echo "[entrypoint] - MODIFIED_STARTUP ..: '${MODIFIED_STARTUP}'";
echo "[entrypoint] ";

# Run the Server
echo "[entrypoint] Executing the startup sentence ...";
${MODIFIED_STARTUP};
echo "[entrypoint] ";
echo "[entrypoint] Execution is finished, exiting now ...";
echo "[entrypoint] ";
