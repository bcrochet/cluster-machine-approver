FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/openshift/cluster-machine-appover
COPY . .
RUN make build

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/cluster-machine-appover/machine-approver /usr/bin/
COPY manifests /manifests
ENTRYPOINT ["/usr/bin/machine-approver"]
LABEL io.k8s.display-name="OpenShift cluster-machine-approver" \
      io.k8s.description="This is an OpenShift component for managing machine approval" \
      com.redhat.component="cluster-machine-approver" \
      maintainer="OpenShift Auth Team <aos-auth-team@redhat.com>" \
      name="openshift/ose-cluster-machine-approver" \
      version="v4.0.0" \
      io.openshift.tags="openshift" \
      io.openshift.release.operator=true
