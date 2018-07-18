#!/usr/bin/env python

import sys
import json
import urllib2
import optparse
import base64
import ssl

##############################################
if __name__=='__main__':
##############################################
    OptionParser = optparse.OptionParser
    parser = OptionParser()
    parser.add_option(
        '--hostname',
        type   = 'string',
        dest   = 'hostname',
        help   = 'Remote ILO hostname/IP addres'
    )
    parser.add_option(
        '--privilouser',
        type   = 'string',
        dest   = 'privilouser',
        help   = 'Privileged ILO username'
    )
    parser.add_option(
        '--privilopass',
        type = 'string',
        dest = 'privilopass',
        help = 'Privileged ILO password'
    )
    parser.add_option( 
        '--username',
        type    = 'string',
        dest    = 'username',
        help    = 'Username for new ILO account'
    )
    parser.add_option( 
        '--password',
        type    = 'string',
        dest    = 'password',
        help    = 'Password for new ILO account'
    )
    parser.add_option( 
        '--acctdesc',
        type    = 'string',
        dest    = 'acctdesc',
        help    = 'Description for new ILO account'
    )
    parser.add_option( 
        '--RemoteConsolePriv',
        dest    = 'RemoteConsolePriv',
        action  = 'store_true',
        help    = 'Privilege: RemoteConsolePriv',
        default = False
    )
    parser.add_option( 
        '--iLOConfigPriv',
        dest    = 'iLOConfigPriv',
        action  = 'store_true',
        help    = 'Privilege: iLOConfigPriv',
        default = False
    )
    parser.add_option( 
        '--VirtualMediaPriv',
        dest    = 'VirtualMediaPriv',
        action  = 'store_true',
        help    = 'Privilege: VirtualMediaPriv',
        default = False
    )
    parser.add_option( 
        '--UserConfigPriv',
        dest    = 'UserConfigPriv',
        action  = 'store_true',
        help    = 'Privilege: UserConfigPriv',
        default = False
    )
    parser.add_option( 
        '--VirtualPowerAndResetPriv',
        dest    = 'VirtualPowerAndResetPriv',
        action  = 'store_true',
        help    = 'Privilege: VirtualPowerAndResetPriv',
        default = False
    )
    
    (options, args) = parser.parse_args()

    req_options = [
        'hostname',
        'privilouser',
        'privilopass',
        'username',
        'password',
        'acctdesc',
    ]

    for req in req_options:
        if options.__dict__[req] is None:
            print "Missing required cmdlint arg: --%s" % req
            sys.exit()

    url  = 'https://%s/rest/v1/AccountService/Accounts' % options.hostname
    base64string = base64.b64encode('%s:%s' % (options.privilouser, options.privilopass))

    # Fetch the list of existing ILO users
    req = urllib2.Request(url)
    req.add_header("Authorization", "Basic %s" % base64string)
    gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1) 
    response = urllib2.urlopen(req, context=gcontext)
    json_string = response.read()
    myds = json.loads(str(json_string))

    existing_users = []
    for item in myds['Items']:
        existing_users.append(item['UserName'])
    print "User list for host: %s" % options.hostname
    print existing_users
    if options.username in existing_users:
        print "User: %s already exists on host: %s" % (options.username, options.hostname)
        sys.exit()

    # Python's boolean data types allow us to correctly build our JSON
    # from this data structure.
    body = {}
    body['Oem'] = {}
    body['Oem']['Hp'] = {}
    body['UserName'] = options.username
    body['Password'] = options.password
    body['Oem']['Hp']['LoginName'] = options.acctdesc
    body['Oem']['Hp']['Privileges'] = {
        'RemoteConsolePriv'        : options.RemoteConsolePriv,
        'iLOConfigPriv'            : options.iLOConfigPriv,
        'VirtualMediaPriv'         : options.VirtualMediaPriv,
        'UserConfigPriv'           : options.UserConfigPriv,
        'VirtualPowerAndResetPriv' : options.VirtualPowerAndResetPriv,
    }

    data = json.dumps(body)

    req = urllib2.Request(url, data, {'Content-Type': 'application/json'})
    req.add_header("Authorization", "Basic %s" % base64string)
    gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1) 
    f = urllib2.urlopen(req, context=gcontext)
    response = f.read()
    f.close()

    print response

# add_ilo_user_via_rest.py --hostname={HOSTNAME} --privilouser={PRIVILOUSER} --privilopass={PRIVILOPASS} --username={NEWILOUSER} --password={NEWILOPASS} --acctdesc={NEWILODESC}
