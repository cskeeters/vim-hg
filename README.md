Plugin for accessing mercurial information

This plugin speeds up the process of using mercurial to discover the commit
that affected the current line in the current file.

The current directory in vim must be in the same mercurial root as the current
file when the plugin is run.

mappings
========

The following mapping is suggested:

    nmap <localleader>b <Plug>HgAnnotate

This opens a new buffer displaying log and diff information for the commit that added the current line in its current form.

    nmap <localleader>d <Plug>HgDiff

This is used to show a full diff of the revision number on the current line.  This would normally be used after running `<Plug>HgAnnotate`

credit
======

vim-hg (the vim plugin) was developed by Chad Skeeters <github.com/cskeeters>.
Distributed under Vim's |license|.
