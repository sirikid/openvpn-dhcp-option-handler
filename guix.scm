(use-modules
 (guix packages)
 (guix gexp)
 (guix git-download)
 (guix build-system copy)
 ((gnu packages dns) #:select (openresolv)))

(package
  (name "openvpn-dhcp-option-handler")
  (version "git")
  (source (let ((dir (dirname (current-filename))))
            (local-file dir #:recursive? #t #:select? (git-predicate dir))))
  (build-system copy-build-system)
  (inputs (list openresolv))
  (arguments
   '(#:install-plan '(("resolvconf-handler.sh" "bin/"))
     #:phases
     (modify-phases %standard-phases
       (add-before 'install 'patch-resolvconf
         (lambda* (#:key inputs #:allow-other-keys)
           (substitute* "resolvconf-handler.sh"
             (("/sbin/resolvconf" path)
              (string-append (assoc-ref inputs "openresolv") path))))))))
  (home-page #f)
  (synopsis #f)
  (description #f)
  (license #f))
