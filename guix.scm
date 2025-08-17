(use-modules
 (guix build-system copy)
 (guix gexp)
 (guix git-download)
 (guix packages)
 ((guix licenses) #:prefix licenses:)
 ((gnu packages dns) #:select (openresolv))
 ((gnu packages linux) #:select (util-linux)))

(package
  (name "openvpn-dhcp-option-handler")
  (version "git")
  (source (let ((dir (dirname (current-filename))))
            (local-file dir #:recursive? #t #:select? (git-predicate dir))))
  (build-system copy-build-system)
  (inputs (list openresolv util-linux))
  (arguments
   '(#:install-plan '(("resolvconf-handler.sh" "bin/"))
     #:phases
     (modify-phases %standard-phases
       (add-before 'install 'patch-resolvconf
         (lambda* (#:key inputs #:allow-other-keys)
           (substitute* "resolvconf-handler.sh"
             (("/bin/getopt|/sbin/resolvconf" path)
              (search-input-file inputs path))))))))
  (home-page "https://github.com/sirikid/openvpn-dhcp-option-handler")
  (synopsis "Script to handle DHCP options pushed from OpenVPN server")
  (description #f)
  (license licenses:asl2.0))
