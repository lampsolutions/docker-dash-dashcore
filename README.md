# Docker Dashcore Node for Coin DASH

Setups the Blockchain Explorer [@dashevo/dashcore-node v3.0.6](https://www.npmjs.com/package/@dashevo/dashcore-node) with the extensions [@dashevo/insight-ui](https://www.npmjs.com/package/@dashevo/insight-ui) and [@dashevo/insight-api](https://www.npmjs.com/package/@dashevo/insight-api).
Base image used is phusion/baseimage based on Ubuntu 18.04.

## Exposed and used services

* http://container:3000/insight/
* http://container:3000/insight-api/

## License
Code released under [the MIT license](https://github.com/lampsolutions/docker-dash-dashcore/blob/master/LICENSE).