import os, subprocess, json

def get_account_info(account):
	args = ["gpg", "--use-agent", "--quiet", "--batch", "-d",
			"%s/.mutt/passwd.gpg" % (os.path.expanduser("~"))]
	retval = {"username": "", "password": ""}

	try:
		data = subprocess.check_output(args).strip()
		json_data = json.loads(data)
		if account.lower() in json_data:
			retval = json_data[account.lower()]
	except ValueError:
		pass
	except subprocess.CalledProcessError:
		pass

	return retval

