# chef-icinga

[![Build Status](https://travis-ci.org/cmur2/chef-icinga.png)](https://travis-ci.org/cmur2/chef-icinga)

## Description

Installs Icinga, the nagios-plugins and icinga-web (the new web interface) from source on recent Debian (and Ubuntu) platforms including Apache2 and MySQL server components.
Configuration is done via Icingas object definition files for which this cookbook provides a basic set monitoring localhost using default attribute declarations.

## Usage

Using `node["icinga"]` you are able to specify nearly anything possible with Icinga object definitions including hosts, hostgroups, services, servicegroups, contacts, contactgroups, timeperiods and commands. All of these can either be declared directly e.g. as `node["icinga"]["hosts"]` or as a template using `node["icinga"]["template"]["hosts"]` which automatically adds a "register 0" directive.

The structure remains the same for all declarations. On the top level (e.g. `node["icinga"]["hosts"]`) there is always an array containing object hashes like so:

	"icinga": {
		"hosts": [
			{
				"host_name": "foo"
			},
			{
				"host_name": "bar"
			}
		]
	}

All object hash properties are directly converted into directives without any magic involved (except for templates where an "register 0" directive is always added to the definition), so the hosts.cfg might look like:

	define host {
		host_name	foo
	}
	define host {
		host_name	bar
	}

## Requirements

### Platform

It should work on all Debian based OSes.

## Recipes

### default

This effectively combines the recipes source, plugins and web-source and starts all daemons afterwards.

### source

Downloads and installs Icinga from sourceforge in the version specified in 	`node["icinga"]["version"]` (tested with 1.8.x, needs `node["icinga"]["checksum"]` to avoid redownloads) to */usr/local/icinga*, configures Icinga and generates all object definitions from attributes. Afterwards ido2db and the needed MySQL tables are seeded using the *icinga* user.

### plugins

Downloads and installs the nagios-plugins from sourceforge in the version specified in `node["nagios_plugins"]["version"]` (needs `node["nagios_plugins"]["checksum"]` to avoid redownloads).

### web-source

Downloads and installs icinga-web from sourceforge in the version specified in 	`node["icinga"]["web"]["version"]` (tested with 1.8.x, needs `node["icinga"]["web"]["checksum"]` to avoid redownloads), sets up a basic Apache configutation and actives PHP and than seeds the needed MySQL tables using the *icinga-web* user.

## License

chef-icinga is licensed under the Apache License, Version 2.0. See LICENSE for more information.
