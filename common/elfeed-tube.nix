{ lib
, fetchFromGitHub
, emacs
, emacsPackages
}:

emacsPackages.trivialBuild {
  pname = "elfeed-tube";
  version = "unstable-2022-06-27";

  src = fetchFromGitHub {
    owner = "karthink";
    repo = "elfeed-tube";
    rev = "0aa3cd3c4a5a4ce071f07db03db4b64d6518abb6";
    sha256 = "sha256-1B8rGHgfDZ9CmEerTcyjceEmBYO7a7VY0a0fh0HRfiI=";
  };

  buildInputs = [ emacs ];

  packageRequires = with emacsPackages; [
    aio
    elfeed
    mpv
  ];

  meta = with lib; {
    description = "Youtube integration for Elfeed, the feed reader for Emacs";
    homepage = "https://github.com/karthink/elfeed-tube";
    license = licenses.unlicense;
    inherit (emacs.meta) platforms;
  };
}
