# users

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with users](#setup)
    * [Beginning with users](#beginning-with-users)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Simple modern port of the existing module mthibaut-users.
Handles in pretty much the simplest possible way, an abstraction layer
for creating users, and ssh_authorized_keys.

The module allows you to speficy users from hiera or a provided hash.

## Setup

Configure your users in hiera.

```
users_default:
    dhewy:
        ensure: present
        uid: 5001
        gid: users
        groups:
            - devops
        comment: Dave Heward
        managehome: true
        shell: /bin/bash
        ssh_authorized_keys:
            somedevice:
                type: 'ssh-rsa'
                key: 'somekey'
```

Invoke users module in site.pp manifest

```
site.pp:

node default{
    users{ 'users_default': }
}
```

### Beginning with users

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module.

## Usage

Invoke users module in site.pp manifest

```
site.pp:

node default{
    users{ 'users_default': }
}
```

Using pre lookup, perhaps for local modding first.

```
$my_users = lookup({
    'name' => "users_all",
    'merge' => {
        'strategy' => 'hash'
    }
})

users{'my_users':
    user_hash => $my_users
}
```

## Reference

#####`user_hash`
Pass a user hash to the module, either pre-looked up hiera or custom hash.

## Limitations/TODO

Fairly nasty .delete('ssh_authorized_keys') assumes you have an ssh_authorized_key block for each user.

## Development

Contributions welcome. Open a PR if you have some ideas/feature requests.
