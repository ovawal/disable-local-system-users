## **This script disables, deletes and archieves multiple local CentOS/RHEL system users.**

### Follow the following procedure to run script.

1. Download file to local system.
2. Move file to /usr/local/bin
```
sudo mv /path/to/your/download/disable-local-user.sh/ /usr/local/bin

```
3. Change script permissions

```
sudo chmod 755 usr/local/bin

```
4. Run script with sudo.

### ***Usage information***
#### sudo disable-local-user.sh [-drav] USER [USERNAME]...
##### Options:

-d	deletes user account.

-r	removes home directory.

-a	archievs the home directory.

-v	verbose mode.
