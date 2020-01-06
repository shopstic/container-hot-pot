# Container Hot Pot

A large collection of ingredients for various aspects of a modern containerized infrastructure. 

## License

[Apache 2.0 license](./LICENSE.txt)

## Notable highlights:

### fdb-cluster

Kubernetes-native and cloud-native Docker image for FoundationDB, with auto detection of AWS availability zones for `three_data_hall` replication.

### fdb-tools

Dockerized [FdbTop](https://github.com/Doxense/foundationdb-dotnet-client/tree/master/FdbTop) for real time monitoring of a FoundationDB cluster.

### fdb-prometheus-exporter

Exports FoundationDB status as Prometheus metrics

### k8s-tools

A complete collection of all necessary tools to deal with Kubernetes on a day-to-day basis.

### prometheus-jmx-exporter

An essential sidecar for any JVM container, which exports JMX metrics as Prometheus metrics

### prometheus-config-reloader

A patch of [prometheus-operator](https://github.com/coreos/prometheus-operator) config-reloader image to reduce the watch interval to just 5 seconds.

### kind-dind

Kubernetes-in-Docker, which enables a state-of-the-art CI/CD pipeline where every commit can run in its own Kubernetes cluster environment.