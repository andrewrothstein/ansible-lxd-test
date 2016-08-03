var _ = require("lodash");
var lxd = require("node-lxd");
var Promise = require("promise");
var fs = require("fs");

let container_specs = [
    {
	image: "ubuntu/trusty/amd64",
	name: "ubuntu-trusty-amd64"
    },
    {
	image: "ubuntu/xenial/amd64",
	name: "ubuntu-xenial-amd64"
    },
    {
	image: "fedora/23/amd64",
	name: "fedora-23-amd64"
    },
    {
	image: "centos/7/amd64",
	name: "centos-7-amd64"
    }
];

_.each(container_specs, function(spec) {
    console.log("not booting container from image " + spec.image + " as " + spec.name);
});

function listContainers(client) {
    return new Promise(function(resolve, reject) {
	client.containers(function(err, containers) {
	    if (err != null) return reject(err);
	    resolve(containers);
	})
    });
}

function hostsSection(cd) {
    return _.map(cd.done(), function(c){ return c.ipv});
}



function main(args) {
    var client = lxd();
    cd = listContainers(client).then(function(containers) {
	return _.map(containers, function(c) {
	    return { name : c.name(), ipv4 : c.ipv4() };
	});
    });
    let hostssection = hostsSection(cd);
    console.log(hostssection);
}

main(["arg1"]);
