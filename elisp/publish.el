(load "/root/scimax/init.el")
(let ((default-directory  "/root/scimax"))
  (normal-top-level-add-subdirs-to-load-path))

(setq org-ditaa-jar-path "/usr/share/ditaa/ditaa.jar")
(setq org-plantuml-jar-path
      (expand-file-name "/root/plantuml-1.2019.8/plantuml.jar"))

(require 'ox-ipynb)
(require 'ox-publish)

(defun ipynb-rise-metadata (orig-func &rest args)
  (let ((data (apply orig-func args)))
    ;; now add the desired rise metadata. this is the second element
    (push '(rise . (("autolaunch" . "true"))) (cdr (second data)))
    data))

;; (advice-add 'ox-ipynb-export-to-buffer-data :around #'ipynb-rise-metadata )

;; https://lists.gnu.org/archive/html/emacs-orgmode/2019-07/msg00060.html
(setq org-export-global-macros
      '(("div" . "@@html:<div class=\"timestamp\">[$1]</div>@@")))

(defun org-sitemap-custom-entry-format (entry style project)
  "Sitemap entry format that includes date."
  (let ((filename (org-publish-find-title entry project))
	(notebookname (concat (file-name-sans-extension entry) ".ipynb")) )
    (if (= (length filename) 0)
        (format "*%s*" entry)
      (format "{{{div(%s)}}} [[%s][%s]] [[%s][%s]]"
              (format-time-string "%Y-%m-%d"
				  (org-publish-find-date entry project))
	      (concat "https://mybinder.org/v2/gl/bhugueney%2Ftest-notebooks-org-publish/master?filepath=public/"
		      notebookname)
	      (concat filename " on mybinder") 
	      (concat "https://colab.research.google.com/github/bhugueney/test-notebooks-org-publish/blob/master/public/" notebookname)
              (concat filename " on google colaboratory") ))))

(defun publish-index-as-html-oterwise-ipynb (_plist filename pub-dir)
  (if (equal (file-name-nondirectory filename)  "index.org")
      (org-html-publish-to-html _plist filename pub-dir)   
    (ox-ipynb-publish-to-notebook _plist filename pub-dir)))

(defun common-prefix (str1 str2)
  (common-prefix-impl str1 str2 ""))
(defun common-prefix-impl (str1 str2 res)
  (if (or (= (length str1) 0) (= (length str2) 0) (not (= (aref str1 0) (aref str2 0))))
      res
    (common-prefix-impl (substring str1 1) (substring str2 1) (concat res (substring str1 0 1)))))

(defun copy-file-creating-dirs (filename dest)
  (unless (file-exists-p (file-name-directory dest)
			 (make-directory (file-name-directory dest) t)))
  (copy-file filename dest t))


(defun move-with-subdirs (notebook-path tangled-path publishing-dir)
  (let ((root-path (common-prefix notebook-path tangled-path)))
    (concat publishing-dir (string-remove-prefix root-path tangled-path))))

(defun tangle-publish-with-directories (_ filename pub-dir)
  "Tangle FILENAME and place the results in PUB-DIR."
  (unless (file-exists-p pub-dir)
    (make-directory pub-dir t))
  (setq pub-dir (file-name-as-directory pub-dir))
  (mapc (lambda (el) (copy-file el (move-with-subdirs filename el pub-dir) t)) (org-babel-tangle-file filename)))

(setq org-publish-project-alist
      '(("notebooks"
         :base-directory "./Notebooks/"
         :base-extension "org"
         :publishing-directory "./public/"
	 ;; :auto-index t
	 ;; :index-filename "index.org"
	 ;; :index-title "index"
	 :auto-sitemap t
	 :sitemap-filename "index.org"
	 :sitemap-format-entry org-sitemap-custom-entry-format
         :recursive t
         :publishing-function publish-index-as-html-oterwise-ipynb
         )
	("img"
         :base-directory "./Notebooks/img/"
         :base-extension "png\\|jpg\\|gif\\|svg"
         :publishing-directory "./public/img"
         :recursive t
         :publishing-function org-publish-attachment
         )
	;; ("python-src" ;; should distinguish hints and solutions ?
        ;;  :base-directory "./Notebooks"
        ;;  :base-extension "py"
        ;;  :publishing-directory "./public/"
        ;;  :recursive t
        ;;  :publishing-function org-publish-attachment
        ;;  )
	("tangles" ;; hints and solutions
         :base-directory "./Notebooks/"
         :publishing-directory "./public/"
         :recursive t
         :publishing-function tangle-publish-with-directories)
        ("all" :components ("notebooks" "img" "tangles"))))

(org-publish-all)
