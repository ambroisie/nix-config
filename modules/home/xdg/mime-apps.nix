{ config, lib, ... }:
let
  cfg = config.my.home.xdg.mime-apps;
  app = cfg.applications;

  strOrStrList = with lib.types; coercedTo str lib.singleton (listOf str);
  mkMimeAppOption = kind: lib.mkOption {
    description = "Application to associate as ${kind}";
    default = null;
    type = lib.types.nullOr strOrStrList;
  };
in
{
  options.my.home.xdg.mime-apps = with lib; {
    enable = my.mkDisableOption "XDG MIME Applications configuration";

    applications = lib.mapAttrsRecursive (_: mkMimeAppOption) {
      archive = "archive manager";
      browser = "internet browser";
      calendar = "calendar";
      editor = "text editor";
      fileManager = "file manager";
      mail = "mail client";
      media = {
        audio = "audio player";
        document = {
          comic = "comic book reader";
          ebook = "ebook reader";
          pdf = "PDF reader";
        };
        image = {
          bitmap = "bitmap image viewer";
          vector = "vector image viewer";
          editor = "image editor";
        };
        video = "video player";
      };
      office = {
        database = "database management program";
        formula = "formula editor";
        graphics = "graphics editor";
        presentation = "presentation editor";
        spreadsheet = "spreadsheet editor";
        text = "word processor";
      };
      terminal = "terminal";
      torrent = "bittorrent client";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = lib.filterAttrs (_: apps: apps != null) {
          "application/epub+zip" = app.media.document.ebook;
          "application/gzip" = app.archive;
          "application/json" = app.editor;
          "application/ld+json" = app.editor;
          "application/mxf " = app.media.video;
          "application/ogg" = app.media.audio;
          "application/pdf" = app.media.document.pdf;
          "application/rss+xml" = app.editor;
          "application/smil+xml " = app.media.video;
          "application/vnd.amazon.ebook" = app.media.document.ebook;
          "application/vnd.apple.mpegurl " = app.media.video;
          "application/vnd.comicbook+zip" = app.media.document.comic;
          "application/vnd.comicbook-rar" = app.media.document.comic;
          "application/vnd.mozilla.xul+xml" = app.browser;
          "application/vnd.ms-excel" = app.office.spreadsheet;
          "application/vnd.ms-powerpoint" = app.office.presentation;
          "application/vnd.ms-word" = app.office.text;
          "application/vnd.oasis.opendocument.database" = app.office.database;
          "application/vnd.oasis.opendocument.formula" = app.office.formula;
          "application/vnd.oasis.opendocument.graphics" = app.office.graphics;
          "application/vnd.oasis.opendocument.graphics-template" = app.office.graphics;
          "application/vnd.oasis.opendocument.presentation" = app.office.presentation;
          "application/vnd.oasis.opendocument.presentation-template" = app.office.presentation;
          "application/vnd.oasis.opendocument.spreadsheet" = app.office.spreadsheet;
          "application/vnd.oasis.opendocument.spreadsheet-template" = app.office.spreadsheet;
          "application/vnd.oasis.opendocument.text" = app.office.text;
          "application/vnd.oasis.opendocument.text-master" = app.office.text;
          "application/vnd.oasis.opendocument.text-template" = app.office.text;
          "application/vnd.oasis.opendocument.text-web" = app.office.text;
          "application/vnd.openxmlformats-officedocument.presentationml.presentation" = app.office.presentation;
          "application/vnd.openxmlformats-officedocument.presentationml.template" = app.office.presentation;
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = app.office.spreadsheet;
          "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = app.office.spreadsheet;
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = app.office.text;
          "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = app.office.text;
          "application/vnd.rar" = app.archive;
          "application/vnd.stardivision.calc" = app.office.spreadsheet;
          "application/vnd.stardivision.draw" = app.office.graphics;
          "application/vnd.stardivision.impress" = app.office.presentation;
          "application/vnd.stardivision.math" = app.office.formula;
          "application/vnd.stardivision.writer" = app.office.text;
          "application/vnd.sun.xml.base" = app.office.database;
          "application/vnd.sun.xml.calc" = app.office.spreadsheet;
          "application/vnd.sun.xml.calc.template" = app.office.spreadsheet;
          "application/vnd.sun.xml.draw" = app.office.graphics;
          "application/vnd.sun.xml.draw.template" = app.office.graphics;
          "application/vnd.sun.xml.impress" = app.office.presentation;
          "application/vnd.sun.xml.impress.template" = app.office.presentation;
          "application/vnd.sun.xml.math" = app.office.formula;
          "application/vnd.sun.xml.writer" = app.office.text;
          "application/vnd.sun.xml.writer.global" = app.office.text;
          "application/vnd.sun.xml.writer.template" = app.office.text;
          "application/vnd.wordperfect" = app.office.text;
          "application/x-7z-compressed" = app.archive;
          "application/x-arj" = app.archive;
          "application/x-bittorrent" = app.torrent;
          "application/x-bzip" = app.archive;
          "application/x-bzip-compressed-tar" = app.archive;
          "application/x-bzip2" = app.archive;
          "application/x-cb7" = app.media.document.comic;
          "application/x-cbr" = app.media.document.comic;
          "application/x-cbt" = app.media.document.comic;
          "application/x-cbz" = app.media.document.comic;
          "application/x-compress" = app.archive;
          "application/x-compressed-tar" = app.archive;
          "application/x-csh" = app.editor;
          "application/x-cue" = app.media.audio;
          "application/x-directory" = app.fileManager;
          "application/x-extension-htm" = app.browser;
          "application/x-extension-html" = app.browser;
          "application/x-extension-ics" = app.calendar;
          "application/x-extension-m4a" = app.media.audio;
          "application/x-extension-mp4" = app.media.video;
          "application/x-extension-shtml" = app.browser;
          "application/x-extension-xht" = app.browser;
          "application/x-extension-xhtml" = app.browser;
          "application/x-fictionbook" = app.media.document.ebook;
          "application/x-fictionbook+xml" = app.media.document.ebook;
          "application/x-flac" = app.media.audio;
          "application/x-gzip" = app.archive;
          "application/x-lha" = app.archive;
          "application/x-lhz" = app.archive;
          "application/x-lzop" = app.archive;
          "application/x-matroska" = app.media.video;
          "application/x-netshow-channel" = app.media.video;
          "application/x-quicktime-media-link" = app.media.video;
          "application/x-quicktimeplayer" = app.media.video;
          "application/x-rar" = app.archive;
          "application/x-sh" = app.editor;
          "application/x-shellscript" = app.editor;
          "application/x-shorten " = app.media.audio;
          "application/x-smil" = app.media.video;
          "application/x-tar" = app.archive;
          "application/x-tarz" = app.archive;
          "application/x-wine-extension-ini" = app.editor;
          "application/x-zip-compressed" = app.archive;
          "application/x-zoo" = app.archive;
          "application/xhtml+xml" = app.browser;
          "application/xml" = app.editor;
          "application/zip" = app.archive;
          "audio/*" = app.media.video;
          "image/*" = app.media.image.bitmap;
          "image/svg+xml" = app.media.image.vector;
          "image/x-compressed-xcf" = app.media.image.editor;
          "image/x-fits" = app.media.image.editor;
          "image/x-psd" = app.media.image.editor;
          "image/x-xcf" = app.media.image.editor;
          "inode/directory" = app.fileManager;
          "message/rfc822" = app.mail;
          "text/*" = app.editor;
          "text/calendar" = app.calendar;
          "text/html" = app.browser;
          "text/plain" = app.editor;
          "video/*" = app.media.video;
          "x-scheme-handler/about" = app.browser;
          "x-scheme-handler/chrome" = app.browser;
          "x-scheme-handler/file" = app.fileManager;
          "x-scheme-handler/ftp" = app.browser;
          "x-scheme-handler/http" = app.browser;
          "x-scheme-handler/https" = app.browser;
          "x-scheme-handler/mailto" = app.mail;
          "x-scheme-handler/mid" = app.mail;
          "x-scheme-handler/terminal" = app.terminal;
          "x-scheme-handler/unknown" = app.browser;
          "x-scheme-handler/webcal" = app.calendar;
          "x-scheme-handler/webcals" = app.calendar;
          "x-www-browser" = app.browser;
        };
      };
    };
  };
}
