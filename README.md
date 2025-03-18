This is another shell script to update your dynamic dual stack IPv6 and IPv4 to DuckDNS.org. <br />
The script uses bash and curl.

Simply chmod the script and execute it. <br />
$ chmod 777 DuckDNS46.sh <br />
$ ./DuckDNS46.sh <br />
<br />
or $ sh DuckDNS46.sh <br />
<br />
You can set your crontab to run this script too. Example: <br />
$ crontab -e <br />
*/5 * * * * /home/razif/DuckDNS46.sh >/dev/null 2>&1 <br />
<br />
(the crontab will run the script every 5 minute) <br />
<br />
It won't request update to DuckDNS.org if no changes detected on either IP.
