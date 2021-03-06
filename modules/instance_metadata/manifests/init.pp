# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class instance_metadata {
    case $::fqdn {
        /.*\.releng\.(use1|usw2)\.mozilla\.com$/: {
            # AWS machines should fetch instance metadata and dump it in /etc/instance_metadata.json
            include packages::mozilla::py27_mercurial
            $python = $::packages::mozilla::python27::python

            file {
                "/usr/local/bin/instance_metadata.py":
                    owner  => "root",
                    mode   => 0755,
                    source => "puppet:///modules/instance_metadata/instance_metadata.py";
            }

            # Run this from exec so that we get it at least once when puppet runs the first time.
            exec {
                "get_instance_metadata":
                    require => File["/usr/local/bin/instance_metadata.py"],
                    creates => "/etc/instance_metadata.json",
                    user    => "root",
                    command => "$python /usr/local/bin/instance_metadata.py -o /etc/instance_metadata.json";
            }

            # On Ubuntu systems, run from init.d on boot, but on CentOS, run in
            # runner (https://bugzilla.mozilla.org/show_bug.cgi?id=1052581 will
            # make these match)
            case $::operatingsystem {
                Ubuntu: {
                    file {
                        "/etc/init.d/instance_metadata":
                            require => File["/usr/local/bin/instance_metadata.py"],
                            content => template("instance_metadata/instance_metadata.initd.erb"),
                            mode    => 0755,
                            owner   => "root",
                            notify  => Service["instance_metadata"];
                    }
                    service {
                        "instance_metadata":
                            require => [
                                File["/etc/init.d/instance_metadata"],
                                File["/usr/local/bin/instance_metadata.py"],
                            ],
                            hasstatus => false,
                            enable    => true;
                    }
                }
                CentOS: {
                    runner::task {
                        "00-instance_metadata":
                            require => File["/usr/local/bin/instance_metadata.py"],
                            content => template("${module_name}/runner_task.sh.erb");
                    }

                    # temporary, to uninstall the init task
                    file {
                        "/etc/init.d/instance_metadata":
                            ensure => absent,
                            notify => Service["instance_metadata"];
                    }
                    service {
                        "instance_metadata":
                            enable => false;
                    }
                }
                default: {
                    fail("instance_metadata is not supported on $::operatingsystem")
                }
            }
        }
        default: {
            # Non-AWS machines should have empty metadata
            file {
                "/etc/instance_metadata.json":
                    owner   => root,
                    mode    => 0644,
                    content => "{}";
            }
        }
    }
}
