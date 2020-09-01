# Test-notebooks-org-publish

Notebooks are good for interactive learning, text files are good for collaborative editing → Notebooks are generated for text files


[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gl/bhugueney%2Ftest-notebooks-org-publish/master?filepath=public)

the gitlab repository is mirrored on github to allow Google colaboratory execution (and Azure ?), but files (i.e. hints and solutions) are note available on Google Colab ☹.

One can do `!git clone https://github.com/bhugueney/test-notebooks-org-publish.git` to get the files (but in subdirectories) but [they won't load anyway !](https://github.com/googlecolab/colabtools/issues/42)…
So on google colab, you can only do `!cat test-notebooks-org-publish/public/hints/exo_1-1.py` instead ☹.

# TODO
- create config files https://mybinder.readthedocs.io/en/latest/config_files.html
- Decide how to generate [URL for appmode for the Notebooks that should be app (quiz ?)](https://github.com/oschuett/appmode#description).

e.g. https://mybinder.org/v2/gh/bhugueney/test-notebooks-org-publish/master?urlpath=%2Fapps%2Fpublic%2Ftest-qcm.ipynb

https://mybinder.org/v2/gl/bhugueney%2Ftest-notebooks-org-publish/master?urlpath=%2Fapps%2Fpublic%2Ftest-qcm.ipynb

could have a sitemap entry function that would [search](http://wikemacs.org/wiki/Emacs_Lisp_Cookbook#Searching) for a string in the org file or better : a [property](https://orgmode.org/manual/Properties-and-Columns.html#Properties-and-columns).

# Also
https://mybinder.readthedocs.io/en/latest/howto/gh-actions-badges.html
