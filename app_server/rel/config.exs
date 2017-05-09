use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"fF7YQ;ZC2RO)4YVc5W7r5N$ve5CJZH$_:nq.^Mr}xm$0`,WDMgY22QPGOBAHd4(M"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"fF7YQ;ZC2RO)4YVc5W7r5N$ve5CJZH$_:nq.^Mr}xm$0`,WDMgY22QPGOBAHd4(M"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :app_server do
  set version: current_version(:app_server)
  set overlays: [
    {:copy, "priv", "priv"}
  ]
end
