#!bin/sh
#git pull

cd app_server
MIX_ENV=prod mix clean
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix compile

# npm progress bar is face of slowly
npm set progress=false
npm install --no-optional
./node_modules/brunch/bin/brunch b -p
MIX_ENV=prod mix phoenix.digest

MIX_ENV=prod mix release --env=prod
echo "released"
_build/prod/rel/app_server/bin/app_server stop
echo "old version stopped"
PORT=4000 _build/prod/rel/app_server/bin/app_server start
echo "new version started"
