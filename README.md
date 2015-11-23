# debify kibana

Normally kibana is distributed as a download, so it's not that easy to
set it up in an automated fashion.

By leveraging [pkgr](https://github.com/crohr/pkgr/)  and some bash creating
and installable Debian + upstar package takes no less than 15s.

Once it's done you can push it to your own APT repo or simply host it on S3
(or equivalent) and simplify kibana installation in your own environment.

# Dependencies

- curl, tar, mv
- pkgr (and whatever pkgr requires)


# How to

`KIBANA_VERSION=4.2.0 ./debify.sh` (4.2.1 is the default)


# TODO

- add `.pkgr.yml` to remove dependencies
- add a way of configuring kibana, atm it uses defaults

### License

GPL
