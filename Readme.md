## Op5util

I got bored logging into the web-gui to administer op5 as most of my other
work was done on the command line, hence op5util.

Op5util can check status of osts, get a summary over the overall network
health, add new hosts to be monitored, add hosts to new hostgroups,
schedule downtime and acknowledge alarms.

The current versions is a re-write to make it more modular.

I use it daily in production, but I take no responsibility for what it may
cause if you run it.


## Screenshots

Nevermind the bundle exec part in the screenshots, that's just before it's been packaged as a gem, if you install the gem you will just run the command op5util without the bundle exec part.

#### Network Summary

![Network summary](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/status.png)

#### Summary of all hosts

![Summary of all hosts](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/host_list_status.png)

#### Summary of host

![Summary of host](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/status_short.png)

#### Detailed status of host

![Detailed status of host](https://raw.githubusercontent.com/np422/Op5util/master/screenshots/host_full_status.png)

## Installation

Download the pkg/op5util-0.0.2.gem and install using ```gem install op5util-0.0.2.gem```.

### Usage

``` text
NAME
    op5util - A small utility to perform common Op5 administration tasks from the command line

    About authentication, if you supply username/password as options, they will be used. If username/password options isn't supplied the environment variables OP5USER and
    OP5PASS will be used. If there are no environment variables set the file pointed to by --authfile or the default file ~/.op5pass will be read. The file format is a single
    line with username and password separated by a : (colon). The supplied credentials shoud be an account with administrative privileges.

    This application uses the REST-api described at https://your.op5.sever/api/help. Although TLS/SSL is used no verification of the certificate isdon as most Op5-servers have
    a self-signed certificate.

SYNOPSIS
    op5util [global options] command [command options] [arguments...]

VERSION
    0.0.2

GLOBAL OPTIONS
    -f, --authfile=authfile - Authfile containing "username:password" used to authenticate with Op5 server (default: ~/.op5pass)
    --help                  - Show this message
    -m, --monitor=monitor   - Hostname or IP-address of the Op5 monitor server, if not supplied the environment variable MONITOR will be used (default: none)
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

``` text
NAME
    add - Add a new host to be monitored by the Op5 server

SYNOPSIS
    op5util [global options] add [command options] hostname.with-fqdn.to.add

DESCRIPTION
    The host is added using default values for max_check_attempts (3), notification_interval (0, aka notify once), notification_period (24x7), etc and using the
    default-host-template. For most off-the-shelf newly installed servers these values usually are sufficient and can be fine-tuned using the web-gui if so should be needed.

COMMAND OPTIONS
    -a, --alias=arg         - Alias for host, defaults to hostname with the fqdn removed if not entered. (default: none)
    -c, --contactgroups=arg - Contact groups for host, defaults to "support_group" (may be used more than once, default: ["support-group"])
    -g, --hostgroups=arg    - Hostgroup(s) to which the new host will be added (may be used more than once, default: none)
    -i, --ipaddr=arg        - IP-address of host, resolved through DNS if not supplied (default: none)
```

#### Schedule downtime

``` text
NAME
    downtime - Schedule downtime for a host

SYNOPSIS
    op5util [global options] downtime [command options] host

COMMAND OPTIONS
    -c, --comment=arg - Comment on reason for downtime downtime (default: Temporary downtime due to system administration)
    -t, --time=arg    - Time period for downtime, in number of hours (default: 2)
```

## TODO

A lot, but this is something that could perhaps be useful to other Op5 Administrators, please feel free to use it.
