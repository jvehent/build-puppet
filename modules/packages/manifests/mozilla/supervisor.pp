# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class packages::mozilla::supervisor {
    case $::operatingsystem {
        CentOS: {
            package {
                "supervisor":
                    ensure => "3.0-0.10.a12.el6";
            }
        }

        default: {
            fail("cannot install on $::operatingsystem")
        }
    }
}
