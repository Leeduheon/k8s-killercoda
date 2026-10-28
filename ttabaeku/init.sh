#!/bin/bash

cat << 'EOF' >> ~/.bashrc
# 1. kubectl 단축어(k) 및 Tab 자동완성
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

# 2. 자주 쓰는 조회/생성/즉시삭제 단축 설정
alias kgp='kubectl get pods -o wide'
alias kgn='kubectl get nodes -o wide'
alias kgs='kubectl get svc -o wide'
alias kgd='kubectl get deploy -o wide'
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# 3. 네임스페이스 빠른 변경 함수 (사용법: kn kube-system)
kn() {
  kubectl config set-context --current --namespace="${1:-default}"
}
EOF

# 4. vi 에디터 YAML 전용 설정 (Tab 누르면 스페이스 2칸)
cat << 'EOF' > ~/.vimrc
set number
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
EOF

# 5. 따배쿠 실습 리포지토리 자동 다운로드
if [ ! -d ~/k8s-killercoda ]; then
  git clone https://github.com/Leeduheon/k8s-killercoda.git ~/k8s-killercoda
fi

# 6. 마스터 노드(controlplane)에도 파드가 배치되도록 NoSchedule 테인트 자동 해제
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule- 2>/dev/null || true

source ~/.bashrc
cd ~/k8s-killercoda/ttabaeku 2>/dev/null || cd ~/k8s-killercoda
clear
echo "✅ 쿠버네티스 기본 설정(k, Tab 자동완성, vimrc, 마스터노드 스케줄링 허용) 및 따배쿠 예제 다운로드 완료!"
kubectl get nodes
