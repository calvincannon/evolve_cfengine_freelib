### Introduction

This is a work in progress. It should be considered beta quality. Efl_update.cf
is an alternative the CFEngine Community's stock update.cf.

### Features

* Reduces sever load when updating the inputs directory.
* Starts or restarts CFEngine daemons as required.
* More transparent that cf_promises_validated mechanism.
* Promises inputs permissions.
* Uses redundant policy servers with network load balancing.

On the server, Cf-manifext reads masterfiles and builds a file, default name
efl_manifest.txt, that contains file names and their hashes. Elf_update.cf
downloads the manifest file and reads it comparing its contents with existing
inputs.  If any files differ or are missing the agent promises to download
them from the policy server.

### Short server setup

* Install efl_update.cf to masterfiles/.
* Install cf-manifest to modules/.
* Allow agent access to modules via access serer promises.
* Add a commands promise in your policy to run cf-manifest on policy servers.
* Change exec_command in executor control body to call efl_update.cf instead of
update.cf.

### Notes

* Only .txt, .tmp, .json and .cf inputs files are considered. If you wish to
change this you'll have to edit cf-manifest and efl_update.cf.
* WARNING, This affects how inputs are updated. If something goes wrong you
may have to update inputs on all clients by hand. Test very, very carefully.

### Server setup using Evolve free promise library

* Install evolve_freelib.cf to lib/ in masterfiles and put in inputs in
promises.cf.
* Install return_index.pl to modules/.
* Plus the short setup above, except building your own command promise.
* Copy efl_data/bundle_params/ to masterfiles.
* Call the bundle efl_main from your policy via method or bundlesequence with
the parameter ${sys.workdir}/inputs/efl_data/bundle_params/efl_main.txt.
Example from stock promises.cf:

```
bundle agent main
{
 methods:

  any::

   "INIT MSG" usebundle => init_msg,
                comment => "Just a pre-defined policy bundled with the package",
                 handle => "main_methods_any_init_msg";

   "EFL Main"
      usebundle => efl_main( "${sys.workdir}/inputs/efl_data/bundle_params/efl_main.txt" ),
      comment   => "Run email main looper bundle",
      handle    => "main_methods_andy_elf_main";
}
```

### Redundant policy servers

Efl_update reads the file ${sys.workdir}/efl_policy_servers.dat. This file is
in the format of one hostname or IP address per line, comments using '#' are
permitted. Each host is read into a list which is shuffled deterministically,
on each agent host.  The list is used in copy_from bodies. If the file does
not exist then the CFEngine standard file ${sys.workdir}/policy_server.dat} is
used.

Efl_policy_servers.dat can be created any you wish, but a template files
promise, with empty as a default, is recommended. Template example:

```
# Redundant policy servers
[%CFEngine !dmz_example_com %]
vega.example.com
sirius.example.com

[%CFEngine dmz_example_com %]
pluto.dmz.example.com
oort.dmz.example.com
```

* TODO Redundant servers in normal agent runs. Make efl_update.cf an input to
use the config bundle.

* TODO How to make servers redundant.
