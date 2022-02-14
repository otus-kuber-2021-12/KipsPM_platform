local kube = import "kube.libsonnet";

{
    catalogue_dep: kube.Deployment("paymentservice") {
    spec+: {
      template+: {
          metadata: {
                    labels: {
                        app: "paymentservice",
                    },
                },
        spec+: {
          containers_+: {
            payment_service: kube.Container("paymentservice") {
              image: "gcr.io/google-samples/microservices-demo/paymentservice:v0.3.5",
              resources: { requests: { cpu: "100m", memory: "100Mi" } },
              env: [{name: "PORT", value: "50051"},{name: "DISABLE_PROFILER", value: "1"},],
              ports: [{containerPort: 50051}],
              securityContext: {
                readOnlyRootFilesystem: true,
                runAsNonRoot: true,
                runAsUser: 10001,
              },
              readinessProbe: {
                  initialDelaySeconds: 20,
                  periodSeconds: 15,
                  exec: {
                      command: [
                          "/bin/grpc_health_probe",
                          "-addr=:50051",
                      ],
                  },
              },
              livenessProbe: {
                  initialDelaySeconds: 20,
                  periodSeconds: 15,
                  exec: {
                      command: [
                          "/bin/grpc_health_probe",
                          "-addr=:50051",
                      ],
                  },
              },
  }}}}}},

  "paymentsrv_servjce": kube.Service("paymentservice") {
        metadata+: {
            name: "paymentservice", 
        },
        spec: {
            ports: [
                {
                    port: 50051,
                    targetPort: 50051,
                },
            ],
            selector: {
                app: "paymentservice",
            },
        },
    },

  payment_dep: kube.Deployment("shippingservice") {
    spec+: {
      template+: {
                    metadata: {
                    labels: {
                        app: "shippingservice",
                    },
                },
        spec+: {
          containers_+: {
            shipping_service: kube.Container("shippingservice") {
              image: "gcr.io/google-samples/microservices-demo/shippingservice:v0.3.5",
              resources: { requests: { cpu: "100m", memory: "100Mi" } },
              env: [{name: "PORT", value: "50051"},{name: "DISABLE_PROFILER", value: "1"}],
              ports: [{containerPort: 50051}],
              securityContext: {
                readOnlyRootFilesystem: true,
                runAsNonRoot: true,
                runAsUser: 10001,
              },
              readinessProbe: {
                  initialDelaySeconds: 20,
                  periodSeconds: 15,
                  exec: {
                      command: [
                          "/bin/grpc_health_probe",
                          "-addr=:50051",
                      ],
                  },
              },
              livenessProbe: {
                  initialDelaySeconds: 20,
                  periodSeconds: 15,
                  exec: {
                      command: [
                          "/bin/grpc_health_probe",
                          "-addr=:50051",
                      ],
                  },
              },
  }}}}}},

    "shipping_servjce": kube.Service("shippingservice") {
        metadata+: {
            name: "shippingservice", 
        },
        spec: {
            ports: [
                {
                    port: 50051,
                    targetPort: 50051,
                },
            ],
            selector: {
                app: "shippingservice",
            },
        },
    },

}
