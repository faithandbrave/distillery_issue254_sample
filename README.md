# distillery_issue254_sample

- [Two releases on same host are conflicting #254 - bitwalker/distillery](https://github.com/bitwalker/distillery/issues/254)

# structure
`admin_site` is control application for `app_server`. `app_server` deploy `app_server` using `deploy.sh`.


# 1st step : start admin site

```
$ cd admin_site
$ mix deps.get
$ npm install
$ ./node_modules/brunch/bin/brunch b -p
$ mix release
$ _build/dev/rel/admin_site/bin/admin_site start
```


# 2nd step : start deploy

Access to <http://localhost:4011/>, and push "Start Deploy" button.

The button executes `deploy.sh`.


# 3rd step : confirm error
Phoenix screen outputs follow:

```
      start deploy
.Running dependency resolution...
All dependencies up to date
Compiling 11 files (.ex)
Generated app_server app
...09 May 15:46:40 - info: compiling
09 May 15:46:41 - info: compiled 6 files into 2 files, copied 3 in 5.4 sec
Check your digested files at "priv/static"
[1m[36m==> Assembling release..[0m
[1m[36m==> Building release app_server:0.0.1 using environment prod[0m
[1m[36m==> Including ERTS 8.1 from /usr/local/Cellar/erlang/19.1/lib/erlang/erts-8.1[0m
[1m[36m==> Packaging release..[0m
.[1m[32m==> Release successfully built!
    You can run it in one of the following ways:
      Interactive: _build/prod/rel/app_server/bin/app_server console
      Foreground: _build/prod/rel/app_server/bin/app_server foreground
      Daemon: _build/prod/rel/app_server/bin/app_server start[0m
released
```

Last line is "released". However, `deploy.sh`'s follow lines are not output:

```
echo "old version stopped"
echo "new version started"
```

Javascript console outputs follow:

```
Failed to load resource: net::ERR_INCOMPLETE_CHUNKED_ENCODING
localhost/:1 Uncaught (in promise) TypeError: network error
```

And admin site is shutdown.


# 4th step : confirm app server release package
```
$ cd app_server
$ _build/prod/rel/app_server/bin/app_server describe
app_server-0.0.1

erts:        8.1
path:        /distillery_issue254_sample/app_server/_build/prod/rel/app_server/releases/0.0.1
sys.config:  /distillery_issue254_sample/app_server/_build/prod/rel/app_server/var/sys.config
vm.args:     /distillery_issue254_sample/app_server/_build/prod/rel/app_server/var/vm.args
name:        app_server@127.0.0.1
cookie:      fF7YQ;ZC2RO)4YVc5W7r5N$ve5CJZH$_:nq.^Mr}xm$0`,WDMgY22QPGOBAHd4(M
erl_opts:    none provided
run_erl_env: none provided

hooks:
No custom hooks found.

commands:
No custom commands found.
```

Hmm... The issue report describes "sys.config and vm_args are bad". But the small project seems good. However, admin site is shutdown...

