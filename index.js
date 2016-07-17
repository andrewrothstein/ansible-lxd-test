var _ = require("lodash");
var lxd = require("node-lxd");
var client = lxd();

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
    console.log("booting container from image " + spec.image + " as " + spec.name);
})

client.containers(function(err, containers) {
    for (var i = 0; i < containers.length; i++) {
	let c = containers[i];
	console.log(c.name() + " : " + c.ipv4()); // containers are actual objects
    }
});

