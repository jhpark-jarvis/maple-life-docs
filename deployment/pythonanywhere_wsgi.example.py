import os
import sys


project_home = "/home/<pythonanywhere_username>/maple-life-docs"
if project_home not in sys.path:
    sys.path.insert(0, project_home)

os.environ.setdefault("FLASK_ENV", "production")

from run import app as application
