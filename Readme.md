## Op5util

Are you using Op5? Perhaps you do most of your work from the command-line
and want to be able to do the most common Op5 tasks without logging in
to a web-gui?

Or you want to start monitoring the newly installed hosts with Op5
using your config management tool?

Those two use-cases were my biggest itches when I first started to use
saved curl commands to interact with the REST-api and soon op5util.rb
was born.

In its current version Op5util can check status of hosts, make a
summary of all monitored hosts health, add new hosts to be monitored,
add hosts to new hostgroups, schedule downtime and acknowledge alarms.

The design nowdays is reasonable modular so new functions can be easily
added if they are needed, pull requests are happily accepted.

I use op5util daily in a production environment, but it comes with no
warranties.

## Screenshots

A few usage example and the output from op5util.

#### Installing, adding a host, checking host status

The commands entered have been given a slightly different color to make them a little more visible.
The screenshot shows installation from gem-file, adding a host and showing status of that host in
both brief and long versions.

By setting the environment variable MONITOR to the hostname of the host running op5 as in this
example you don't need to use the flag ```--monitor=op5server``` on every op5util command.

The host is added as a member of the hostgroup linux_hosts with the op5util add command, and
that's where all the servicechecks are defined. There was a minute between the add and the status
command so the services could be checked in the meantime.

![Usage example](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/usage1_color.png)

The newly added host in normal web-gui.

![web-gui](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/host_op5.png)

And the same host in a listview with service stae as comparison with the terminal output.

![web-gui](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/host_op5_listview.png)

#### Summary of all hosts

You can use to op5util to get a quick look at the overall status directly from the
command line as well, both a aggregate view and a view status per host.

![network state summary](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/state_summary.png)

## Installation

Download the latest pkg/op5util-0.X.Y.gem from this repo and install using ```gem install op5util-0.0.3.gem```.

### Usage

There is no man-page, but the built in help text should do the job.

If you enter the command ```op5util help``` the top-level documentation is displayed.

``` text
NAME
    op5util - A small utility to perform common Op5 administration tasks from the command line

    About authentication, if you supply username/password as options, they will be used. If username/password
    options isn't supplied the environment variables OP5USER and OP5PASS will be used. If there are no
    environment variables set the file pointed to by --authfile or the default file ~/.op5pass will be read.
    The file format is a single line with username and password separated by a : (colon). The supplied
    credentials shoud be an account with administrative privileges.

    This application uses the REST-api described at https://your.op5.sever/api/help. Although TLS/SSL is
    used no verification of the certificate isdon as most Op5-servers have a self-signed certificate from
    the default install.

SYNOPSIS
    op5util [global options] command [command options] [arguments...]

VERSION
    0.0.2

GLOBAL OPTIONS
    -f, --authfile=authfile - Authfile containing "username:password" used to authenticate with Op5
                              server (default: ~/.op5pass)
    --help                  - Show this message
    -m, --monitor=monitor   - Hostname or IP-address of the Op5 monitor server, if not supplied
                              the environment variable MONITOR will be used (default: none)
    -p, --password=password - Password used to authenticate with the Op5 server (default: none)
    -u, --username=username - Username used to authenticate with the Op5 server (default: none)
    --version               - Display the program version

COMMANDS
    acknowledge    - Acknowledge outstanding alarms - use with care
    add            - Add a new host to be monitored by the Op5 server
    add_hostgroups - Add host to a new hostgroup(s)
    downtime       - Schedule downtime for a host
    help           - Shows a list of commands or help for one command
    status         - Show monitoring status, if no host is given a summary of all hosts/services is printed
```

#### Add host

To get information about a specific command, use ```op5util help add``` , two examples are included below.

``` text
NAME
    add - Add a new host to be monitored by the Op5 server

SYNOPSIS
    op5util [global options] add [command options] hostname.with-fqdn.to.add

DESCRIPTION
    The host is added using default values for max_check_attempts (3), notification_interval (0, aka notify
    once), notification_period (24x7), etc and using the default-host-template. For most off-the-shelf
    newly installed servers these values usually are sufficient and can be fine-tuned using the web-gui
    if so should be needed.

COMMAND OPTIONS
    -a, --alias=arg         - Alias for host, defaults to hostname with the fqdn removed if not entered
                              (default: none)
    -c, --contactgroups=arg - Contact groups for host, defaults to "support_group" (may be used more
                              than once, default: ["support-group"])
    -g, --hostgroups=arg    - Hostgroup(s) to which the new host will be added (may be used more than
                              once, default: none)
    -i, --ipaddr=arg        - IP-address of host, resolved through DNS if not supplied (default: none)
```

#### Schedule downtime

``` text
NAME
    downtime - Schedule downtime for a host

SYNOPSIS
    op5util [global options] downtime [command options] host

COMMAND OPTIONS
    -c, --comment=arg - Comment on reason for downtime downtime (default: Temporary downtime due
                        to system administration)
    -t, --time=arg    - Time period for downtime, in number of hours (default: 2)
```

## Roadmap, TODO

A lot remains, the roadmap ahead contains more automated pre-release tests, more documentation and
adding some more functions, but the current version of op5util is already useful to me in my
day-time job, perhaps it also could be useful to other Op5 administrators?

Please, give my repo a github star or drop me line if you find this utility useful. Feel
free to leave a bug-reports or feature requests as an issue in this repo.

/Niklas
