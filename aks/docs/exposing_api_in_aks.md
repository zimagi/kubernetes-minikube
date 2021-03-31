# Exposing API

There are 2 solution provided by Microsoft to expose a kubernetes service from kubernetes' point of view:
- **LoadBalancer**: standard way to expose a service to the internet. In Azure, this will spin up an Azure Load Balancer (L4) that gives us a single public IP address that forwards all traffic to your service.
- **Ingress**: is not actually a type of service but acts as a smart router or entry point into your cluster. We can do several things with an Ingress, and there are many types of Ingress controllers with varying capabilities (Istio, Contour, Traefik, NGINX). ngress is more useful if you want to expose multiple services under the same IP address, and these services all use the same L7 protocol. You only pay for one load balancer price.

## Application Gateway Ingress Controller

The Application Gateway Ingress Controller (AGIC) is a Kubernetes application, which makes it possible for Azure Kubernetes Service (AKS) customers to leverage Azure's native Application Gateway L7 load-balancer to expose cloud software to the Internet. AGIC monitors the Kubernetes cluster it is hosted on and continuously updates an Application Gateway, so that selected services are exposed to the Internet.

The Ingress Controller runs in its own pod on the customer’s AKS. AGIC monitors a subset of Kubernetes Resources for changes. The state of the AKS cluster is translated to Application Gateway specific configuration and applied to the Azure Resource Manager (ARM).

![agic](/aks/docs/images/expose_api/agic.png)

## Benefit of using AGIC

AGIC helps eliminate the need to have another load balancer/public IP in front of the AKS cluster and avoids multiple hops in your datapath before requests reach the AKS cluster. Application Gateway talks to pods using their private IP directly and does not require NodePort or KubeProxy services. This also brings better performance to your deployments.

Ingress Controller is supported exclusively by Standard_v2 and WAF_v2 SKUs, which also brings you autoscaling benefits. Application Gateway can react in response to an increase or decrease in traffic load and scale accordingly, without consuming any resources from your AKS cluster.

Using Application Gateway in addition to AGIC also helps protect your AKS cluster by providing TLS policy and Web Application Firewall (WAF) functionality.