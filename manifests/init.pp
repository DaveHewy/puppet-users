# Class: users
# ===========================
#
# Simple modern port of the existing module mthibaut-users.
# Handles in pretty much the simplest possible way, an abstraction layer
# for creating users in a generic, unified hiera or provided hash.
#
# Parameters
# ----------
#
# user_hash = 'undef' (Default)
#   Force the function to use provided hash instead of hiera lookup.
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class users{ 'users_all': }
#
# Where users_all is a hiera lookup block looking something like the below.
# users_all:
  # dhewy:
  #   ensure: present
  #   uid: 5001
  #   gid: users
  #   groups:
  #    - devops
  #   comment: Dave Heward
  #   managehome: true
  #   shell: /bin/bash
  #   ssh_authorized_keys:
  #    somedevice:
  #      type: 'ssh-rsa'
  #      key: 'somekey'

# Authors
# -------
#
# David Heward <dave@dhewy.co.uk>
#
define users(
  $user_hash = undef
){

  if $user_hash {
    $_hash = $user_hash
  } else {
    # Assume the name by default is the call to the resource
    $_hash = lookup({
        'name' => "users_${name}",
        'merge' => {
            'strategy' => 'hash'
        }
    })
  }

  # Test we have some users.
  if $_hash{
      # Create me all my users.
      $_hash.each |$user, $value| {
          # Check we aren't already managing this user, with this module.
          if(!defined(Users[$user])) {
              user { $user:
                  * => $value.delete('ssh_authorized_keys') # Local removal of the ssh_authorized_key block.
              }
          }
          # Now lets handle that pesky authorized key.
          # We could/should construct a new hash?
          if($value['ssh_authorized_keys']){
              $_ssh_keys = $value['ssh_authorized_keys']
              # Keys are a hash?
              if(is_hash($_ssh_keys)){
                  $_ssh_keys.each |$name, $key| {
                      # Check we haven't already put this key down.
                      if(!defined(Users["${user}-${name}"])) {
                          # Put down the ssh_authorized_keys for the user
                          ssh_authorized_key {"${user}-${name}":
                              user => $user,
                              *    => $key
                          }
                      }
                  }
              } else {
                  notify {"User ssh key data for ${user} must be in hash form": }
              }
          }
      }
  } else {
      notify{"No data resource for '${name}' title '${title}'": }
  }
}
