{ pkgs, emacs, callPackage }:
let
  stdenv = pkgs.stdenv;
  # Function to build package.el packages.
  buildEmacsPackage = import ../applications/editors/emacs-modes/package-el {
    inherit stdenv;
    inherit emacs;
  };
in rec {
  inherit (builtins) hasAttr getAttr;
  inherit (pkgs.lib) versionOlder getVersion;
  inherit (pkgs) fetchurl;

  generatedPackages = (import ./emacs-packages-generated.nix {
    inherit buildEmacsPackage;
    inherit fetchurl;
    inherit otherPackages;
  });

  # Merge generated and manual packages, then update older versions etc.
  allPackages = pkgs.lib.mapAttrs (name: value:
    let
      generatedVersion = if (hasAttr name generatedPackages)
        then
          getVersion (getAttr name generatedPackages)
        else
          null;
      otherVersion = getVersion value;
    in
      if (generatedVersion != null &&
          versionOlder otherVersion generatedVersion)
        then
          getAttr name generatedPackages
        else
          value) (generatedPackages // otherPackages);

  # Legacy emacs packages, not yet built via package.el or newer
  # version
  otherPackages = {
    autoComplete = callPackage ../applications/editors/emacs-modes/auto-complete { };
    bbdb = callPackage ../applications/editors/emacs-modes/bbdb { texinfo = pkgs.texinfo5; };
    cedet = callPackage ../applications/editors/emacs-modes/cedet { python = pkgs.python; };
    calfw = callPackage ../applications/editors/emacs-modes/calfw { };
    coffee = callPackage ../applications/editors/emacs-modes/coffee { };
    colorTheme = callPackage ../applications/editors/emacs-modes/color-theme { };
    cua = callPackage ../applications/editors/emacs-modes/cua { };
    # ecb = callPackage ../applications/editors/emacs-modes/ecb { };
    jabber = callPackage ../applications/editors/emacs-modes/jabber { };
    emacsClangCompleteAsync = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };
    emacsSessionManagement = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };
    emacsw3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { texinfo = pkgs.texinfo5; };
    emms = callPackage ../applications/editors/emacs-modes/emms { texinfo = pkgs.texinfo5; };
    ess = callPackage ../applications/editors/emacs-modes/ess { };
    flymakeCursor = callPackage ../applications/editors/emacs-modes/flymake-cursor { };
    gh = callPackage ../applications/editors/emacs-modes/gh { };
    graphvizDot = callPackage ../applications/editors/emacs-modes/graphviz-dot { };
    gist = callPackage ../applications/editors/emacs-modes/gist { };
    jade = callPackage ../applications/editors/emacs-modes/jade { };
    jdee = callPackage ../applications/editors/emacs-modes/jdee {
      # Requires Emacs 23, for `avl-tree'.
    };
    js2 = callPackage ../applications/editors/emacs-modes/js2 { };
    stratego = callPackage ../applications/editors/emacs-modes/stratego { };
    haskellMode = callPackage ../applications/editors/emacs-modes/haskell { };
    ocamlMode = callPackage ../applications/editors/emacs-modes/ocaml { };
    tuaregMode = callPackage ../applications/editors/emacs-modes/tuareg { };
    hol_light_mode = callPackage ../applications/editors/emacs-modes/hol_light { };
    htmlize = callPackage ../applications/editors/emacs-modes/htmlize { };
    logito = callPackage ../applications/editors/emacs-modes/logito { };
    loremIpsum = callPackage ../applications/editors/emacs-modes/lorem-ipsum { };
    magit = callPackage ../applications/editors/emacs-modes/magit { texinfo = pkgs.texinfo5; };
    maudeMode = callPackage ../applications/editors/emacs-modes/maude { };
    notmuch = callPackage ../applications/networking/mailreaders/notmuch { };
    org = (callPackage ../applications/editors/emacs-modes/org { texinfo = pkgs.texinfo5; });
    org2blog = callPackage ../applications/editors/emacs-modes/org2blog { };
    pcache = callPackage ../applications/editors/emacs-modes/pcache { };
    phpMode = callPackage ../applications/editors/emacs-modes/php { };
    prologMode = callPackage ../applications/editors/emacs-modes/prolog { };
    proofgeneral = callPackage ../applications/editors/emacs-modes/proofgeneral {
      texLive = pkgs.texLiveAggregationFun {
        paths = [ pkgs.texLive pkgs.texLiveCMSuper ];
      };
    };
    quack = callPackage ../applications/editors/emacs-modes/quack { };
    rectMark = callPackage ../applications/editors/emacs-modes/rect-mark { };
    remember = callPackage ../applications/editors/emacs-modes/remember { };
    rudel = callPackage ../applications/editors/emacs-modes/rudel { };
    scalaMode = callPackage ../applications/editors/emacs-modes/scala-mode { };
    sunriseCommander = callPackage ../applications/editors/emacs-modes/sunrise-commander { };
    xmlRpc = callPackage ../applications/editors/emacs-modes/xml-rpc { };
  };
}
