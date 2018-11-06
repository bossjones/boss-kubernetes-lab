# Start
minikube --vm-driver=vmwarefusion -v 2 --cpus 4 --memory 6000 start

# dashboard
minikube dashboard

# docker
eval $(minikube docker-env)
