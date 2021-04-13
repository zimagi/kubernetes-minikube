# 
## TLDR
```shell
minikube start --vm=true
minikube addons enable ingress
kubectl get pods -n kube-system
echo $(minikube ip) example.com | sudo tee -a /etc/hosts
curl http://example.com
```

## Prerequisites
You must have an Ingress controller to satisfy an Ingress. Only creating an Ingress resource has no effect.

You may need to deploy an Ingress controller such as ingress-nginx. You can choose from a number of Ingress controllers.

Ideally, all Ingress controllers should fit the reference specification. In reality, the various Ingress controllers operate slightly differently.

### Software requirements
- [minikube](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-minikube/)

## Minikube environment
minikube is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

All you need is Docker (or similarly compatible) container or a Virtual Machine environment, and Kubernetes is a single command away: 

```shell
minikube start --vm=true
```

### Enable Nginx-Ingress contoller
To enable the NGINX Ingress controller, run the following command:
```shell
minikube addons enable ingress
```

Verify that the NGINX Ingress controller is running
```shell
kubectl get pods -n kube-system
```

### Teardown environment
```shell
minikube delete --purge=true
```

## Ingress object
You can find below ingress template. You have to add host name to your `/etc/hosts` file to reach the instance from local you can get mnikube's ip address with this command: `minikube ip` 
```shell
echo $(minikube ip) example.com | sudo tee -a /etc/hosts
curl http://example.com
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  rules:
    - host: example.com
      http:
        patihs:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: svc
                port:
                  number: 80
```

Each HTTP rule contains the following information:
- An optional host. In this example, no host is specified, so the rule applies to all inbound HTTP traffic through the IP address specified. If a host is provided (for example, foo.bar.com), the rules apply to that host.
- A list of paths (for example, `/testpath`), each of which has an associated backend defined with a `service.name` and a `service.port.name` or `service.port.number`. Both the host and path must match the content of an incoming request before the load balancer directs traffic to the referenced Service.
- A backend is a combination of Service and port names as described in the Service doc or a custom resource backend by way of a CRD. HTTP (and HTTPS) requests to the Ingress that matches the host and path of the rule are sent to the listed backend.

You can find more information about PathTypes [here](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)