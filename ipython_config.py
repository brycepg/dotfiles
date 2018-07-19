c.InteractiveShellApp.exec_lines = []
# ipython-autoimport - Automatically import modules
c.InteractiveShellApp.exec_lines.append(
    "try:\n    %load_ext ipython_autoimport\nexcept ImportError: pass")
# Automatically reload modules
c.InteractiveShellApp.exec_lines.append('%load_ext autoreload')
c.InteractiveShellApp.exec_lines.append('%autoreload 2')
c.TerminalInteractiveShell.editor = 'gvim'
