
alias podnfo='kubectl get pods -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,STATUS:.status.phase,NODE:.spec.nodeName,IP:.status.podIP -A'

