title: linux-cron
date: 2014-10-12 21:25:49
tags: [crontab, study]
---

crontab -l  : To display the existing cron jobs created. Before creating cron job, we can use this command to check whether it is already created or not
crontab - r :  Remove user's cron jobs. All cron jobs will be removed.
crontab -e : Edit user's cron job, you can create a new cron job using this command. This command will open the default editor of your system, for me it's vi, if you prefer other editors such as vim. You can use export EDITOR=vim command.
crontab -u : Specify the user of the cron job

Ok, now we start to create a new cron job using crontab -e, this will open an editor, you can type the cron job into the editor. The syntax for the cron job is 

````
* * * * * command to be executed
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)
````

<!-- more -->

The first five fields specify the time of the scheduled running job, the * means that for each cycle of the time field (For example, the * on hour means each hour, the * on day means each day, if * appears on both hour and day field, it means every hour of every day). If we want to specify a particular time, we should put a number on relative time field. For example, if we want to run a cron job at 7:30 am every day, we should specify the cron job as

````
30 7 * * * command to be executed
````

Now if we want to run a cron job every 5 minutes, what should we do? On some systems we can use the following method:

````
*/5 * * * * command to be executed
````

If we want to run a job every 10 minutes

````
*/10 * * * * command to be executed
````

All right, we are going to add the commands to be run now. The commands can be any executable scripts, programs or commands. For my case, I need to run a php script, so I need to find the php executable which is used to parse and run my php script. The path for the installed php executable on CentOS is /usr/bin/php, so the command to be executed is /usr/bin/php, we can pass the php file to be processed to this php command, suppose my php file is located at /var/www/html/rank.php., we should put this behind the /usr/bin/php. So the complete cron job is:

````
*/5 * * * * /usr/bin/php /var/www/html/rank.php 
````

Finished? Maybe not. Since our php script may echo some data or some error messages out, by default, these output will be sent to our admin email. If we don't want to receive the output with our email, instead we want them to be logged into a log file, we can add following command : >/var/www/html/rank.log 2>&1

So the complete command should be :

````
*/5 * * * * /usr/bin/php /var/www/html/rank.php >/var/www/html/rank.log 2>&1
````

Now save and quit the editor. The cron job is created, after 5 minutes you will find a log file is created in /var/www/html directory. This means your cron job is running. 

[http://www.pixelstech.net/article/index.php?id=1339424625](http://www.pixelstech.net/article/index.php?id=1339424625)


