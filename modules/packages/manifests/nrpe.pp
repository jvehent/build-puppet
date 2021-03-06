# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class packages::nrpe {
    case $::operatingsystem {
        Ubuntu: {
            package {
                "nagios-nrpe-server":
                    ensure => latest,
                    install_options => [ '--no-install-recommends' ];
                "nagios-nrpe-plugin":
                    ensure => latest,
                    install_options => [ '--no-install-recommends' ];
                # This is a temporary solution to removing nagios3 from
                # a time before --no-install-recommends was available
                # see bug 1006891
                "nagios3":
                    ensure => absent;
            }
        }
        CentOS: {
            package {
                "nrpe":
                    ensure => latest;
                "nagios-plugins-nrpe":
                    ensure => latest;
                "nagios-plugins-all":
                    ensure => latest;
            }
        }
        Darwin: {
            packages::pkgdmg {
                # this DMG contains both nrpe and the plugins, and creates
                # the user/group, but does not install the service.
                nrpe:
                    version => "2.14-moz1";
            }
        }

        default: {
            fail("cannot install on $::operatingsystem")
        }
    }
}
