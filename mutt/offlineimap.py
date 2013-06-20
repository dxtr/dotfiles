import os, subprocess, json

json_data = None

def get_account_info(account):
    global json_data
    args = ["gpg", "--use-agent", "--quiet", "--batch", "-d",
            "%s/.mutt/passwd.gpg" % (os.path.expanduser("~"))]
    retval = {"username": "", "password": ""}

    try:
        if json_data is None:
            data = subprocess.check_output(args).strip()
            json_data = json.loads(data)
        if account in json_data:
            retval = json_data[account]
    except ValueError:
        pass
    except subprocess.CalledProcessError:
        pass

    return retval

