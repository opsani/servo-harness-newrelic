import os
import subprocess
os.environ["PYTHONPATH"] = os.getcwd()
subprocess.run(["/servo/adjust.d/main","--info"])
subprocess.run(["/servo/measure","--info"])
