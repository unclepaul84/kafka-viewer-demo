## Kafka Viewer with RBAC Prototype

Based on https://www.jpmorgan.com/technology/technology-blog/protecting-web-applications-via-envoy-oauth2-filter

Uses https://github.com/obsidiandynamics/kafdrop

``` mermaid
flowchart LR
    subgraph k8s
        ingress
        ingress-->envoy-proxy-sidecar
        subgraph pod
            
            envoy-proxy-sidecar-->kafka-viewer
        end
    end
    user-->|bearer token|ingress
    user-.get token.->oidc-provider
    envoy-proxy-sidecar-.verify token.->oidc-provider
    kafka[(Kafka)]
    kafka-viewer-->|Cert Auth|kafka
```

### Running

#### Reqs
* Docker
    * envoyproxy/envoy-dev
    * obsidiandynamics/kafdrop
    * confluentinc/cp-kafka
    * confluentinc/cp-zookeeper
    * ghcr.io/soluto/oidc-server-mock
* docker-compose
* Python >= 3.7
* protoc


#### Steps


1. Clone this repo
1. python -m venv env
1. source ./env/bin/activate
1. pip install -r requirements.txt
1. run ./compile_protos.sh
1. docker-compose up
1. python publisher.py
1. navigate to http://localhost:10000/topic/sys-50-trades/messages?partition=0&offset=0&count=100&keyFormat=DEFAULT&format=PROTOBUF&descFile=Trades.desc&msgTypeName=TradeTopic ,  use User1/pwd for credentials
