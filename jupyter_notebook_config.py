from jupyter_core.paths import jupyter_data_dir
import os

c = get_config()

# Set a password if PASSWORD is set
if 'PASSWORD' in os.environ:
    from IPython.lib import passwd
    c.NotebookApp.password = passwd(os.environ['PASSWORD'])
    #del os.environ['PASSWORD']