(load "/root/scimax/init.el")
(let ((default-directory  "/root/scimax"))
  (normal-top-level-add-subdirs-to-load-path))
(require 'ox-ipynb)
(require 'ox-publish)

;; https://lists.gnu.org/archive/html/emacs-orgmode/2019-07/msg00060.html
(setq org-export-global-macros
      '(("div" . "@@html:<div class=\"timestamp\">[$1]</div>@@")))

(defun org-sitemap-custom-entry-format (entry style project)
  "Sitemap entry format that includes date."
  (let ((filename (org-publish-find-title entry project))
	(notebookname (file-name-sans-extension entry) ".ipynb"))
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
    (ox-ipynb-publish-to-notebook _plist filename pub-dir))
  )

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
	("python-src" ;; should distinguish hints and solutions ?
         :base-directory "./Notebooks"
         :base-extension "py"
         :publishing-directory "./public/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("all" :components ("notebooks" "img" "python-src"))))

(org-publish-all)
