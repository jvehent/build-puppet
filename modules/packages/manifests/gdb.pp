# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class packages::gdb {
    case $::operatingsystem {
        CentOS: {
            package {
                "gdb":
                    ensure => "7.2-50.el6";
            }
        }

        default: {
            fail("cannot install on $::operatingsystem")
        }
    }
}
