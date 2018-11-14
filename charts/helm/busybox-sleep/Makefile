deploy:
	kubectl create -f busybox.yaml

get-pods:
	kubectl get pods busybox

exec-nslookup:
	kubectl exec -ti busybox -- nslookup kubernetes.default

exec-resolv:
	kubectl exec busybox cat /etc/resolv.conf

ls-dns-pods:
	kubectl get pods --namespace=kube-system -l k8s-app=kube-dns

debug-dns-errors:
	bash ./debug-dns-errors.sh
