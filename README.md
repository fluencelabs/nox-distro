# SIGTERM handling bug example

```shell
docker build -f bug.Dockerfile -t sidecar .

docker run --name sidecar sidecar
```

^C doesn't work, `docker stop` also doesn't work.

## Remove log/run and it works
```shell
rm -rf s6/root/etc/services.d/myprog/log
docker build -f bug.Dockerfile -t sidecar .

docker run --name sidecar sidecar
```

^C works, `docker stop` works
