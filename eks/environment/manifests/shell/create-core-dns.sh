aws eks create-fargate-profile \
    --fargate-profile-name coredns \
    --cluster-name gamo-cluster-test \
    --pod-execution-role-arn arn:aws:iam::960293440626:role/eksctl-gamo-cluster-test-cl-FargatePodExecutionRole-mhoHWS9ums3z \
    --selectors namespace=kube-system,labels={k8s-app=kube-dns} \
    --subnets subnet-0fa9ab6256c36b661 subnet-0b1f8d0025c871f2e subnet-0e08fdd95233bc1de

kubectl patch deployment coredns \
    -n kube-system \
    --type json \
    -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'

kubectl rollout restart -n kube-system deployment coredns

aws eks describe-cluster \
  --name gamo-cluster-test \
  --query "cluster.identity.oidc.issuer" \
  --output text


#	作業メモ
# Fargateだとkubectlコマンドで作成したサービスがCLBになってしまい、FargateがCLBに対応していない。
# なのでALBかNLBでサービスを作成する必要がありそう　https://miraitranslate-tech.hatenablog.jp/entry/2022/09/12/120000
# 他にCoreDNSの設定をFargate仕様に変える必要がある？　https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/fargate-getting-started.html