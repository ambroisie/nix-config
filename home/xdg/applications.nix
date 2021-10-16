{ config, lib }:
let
  genApp = app: schemes: lib.genAttrs schemes (_: [ app ]);
  genAppIf = cond: app: schemes: lib.optionalAttrs cond (genApp app schemes);
in
lib.my.recursiveMerge [
  # Firefox
  (genAppIf config.my.home.firefox.enable "firefox.desktop" [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
  ])
]
