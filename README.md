## **This script disables, deletes and archieves multiple local CentOS/RHEL system users.**

### Follow the following procedure to run script.

1. Download file to local system.
2. Move file to /usr/local/bin
```
sudo mv /path/to/your/download/disable-local-user.sh/ /usr/local/bin

```
3. Change script permissions

```
sudo chmod /usr/local/bin

```
4. Run script with sudo.

### ***Usage information***
#### disable-local-user.sh [-drav] USER [USERNAME]...
##### Options:

-d	Deletes user account.

-r	Removes home directory.

-a	Archievs the home directory.

-v	Verbose mode.
