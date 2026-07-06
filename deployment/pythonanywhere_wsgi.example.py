import os
import sys

from dotenv import load_dotenv


project_home = "/home/<pythonanywhere_username>/maple-life-docs"
if project_home not in sys.path:
    sys.path.insert(0, project_home)

os.chdir(project_home)
load_dotenv(os.path.join(project_home, ".env"))
os.environ.setdefault("FLASK_ENV", "production")

from run import app as application
