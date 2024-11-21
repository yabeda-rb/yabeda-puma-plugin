Navigate to experiments directory:
```sh
cd experiments
```

Setup environment
```sh
docker-compose run app bundle

docker-compose up grafana promethes app
```

To run stress-test:

```sh
docker-compose run k6
```

Navagate to grafana http://localhost:3000 to "Puma experimental" dashboard.

See results:

![Results](docs/puma-requests_wait_time.png)

