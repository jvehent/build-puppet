# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class config inherits config::base {
    $org = "servo"

    $puppet_notif_email = "releng-shared@mozilla.com"
    $puppet_server_reports = "tagmail,http"
    $puppet_server_reporturl = "http://foreman.pvt.build.mozilla.org:3001/"
    $puppet_server_facturl = "http://foreman.pvt.build.mozilla.org:3000/"

    $builder_username = "servobld"

    $puppet_servers = [
        "servo-puppet1.srv.servo.releng.use1.mozilla.com",
    ]
    $puppet_server = $puppet_servers[0]
    $data_servers = $puppet_servers
    $data_server = $puppet_server

    $distinguished_puppetmaster = $puppet_server
    $puppet_again_repo = "https://hg.mozilla.org/build/puppet/"
    $puppetmaster_upstream_rsync_source = 'rsync://puppetagain.pub.build.mozilla.org/data/'
    $puppetmaster_extsyncs = {
        'moco_ldap' => {
            'moco_ldap_uri' => 'ldap://ldap.db.scl3.mozilla.com/',
            'moco_ldap_root' => 'dc=mozilla',
            'moco_ldap_dn' => secret('moco_ldap_dn'),
            'moco_ldap_pass' => secret('moco_ldap_pass'),
        }
    }

    $puppetmaster_extsyncs = {
        'slavealloc' => {
            'slavealloc_api_url' => 'http://slavealloc.pvt.build.mozilla.org/api/',
        },
        'moco_ldap' => {
            'moco_ldap_uri' => 'ldap://ldap.db.scl3.mozilla.com/',
            'moco_ldap_root' => 'dc=mozilla',
            'moco_ldap_dn' => secret('moco_ldap_dn'),
            'moco_ldap_pass' => secret('moco_ldap_pass'),
            'users_in_groups' => {
                'ldap_admin_users' => ['releng', 'relops', 'vpn_servo',
                    'netops', 'team_dcops', 'team_opsec', 'team_moc', 'team_infra', 'team_storage'],
            },
        }
    }

    $nrpe_allowed_hosts = "127.0.0.1,10.26.75.30"
    $ntp_server = "time.mozilla.org"
    $enable_mig_agent = true
    $admin_users = hiera('ldap_admin_users',
                         # backup to ensure access in case the sync fails:
                         ['arr', 'dmitchell', 'jwatkins'])
    }

    $buildbot_mail_to = "release@mozilla.com"
    $bors_servo_repo_owner = "mozilla"
    $bors_servo_repo = "servo"
    $bors_servo_reviewers = [
        'aydinkim',
        'brson',
        'burg',
        'eric93',
        'glennw',
        'ILyoan',
        'jdm',
        'kmcallister',
        'larsbergstrom',
        'metajack',
        'mbrubeck',
        'Ms2ger',
        'pcwalton',
        'SimonSapin',
        'sfowler',
        'tkuehn',
        'yichoi',
        'zwarich',
    ]
    $bors_servo_builders = ["linux","mac"]
    $bors_servo_buildbot_url = "http://servo-buildbot.pub.build.mozilla.org"

    $xcode_version = $::macosx_productversion_major ? {
        10.7 => "4.6.2-cmdline",
        default => undef
    }
}

