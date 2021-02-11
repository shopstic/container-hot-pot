KUBE_PS1_CTX_COLOR=white
KUBE_PS1_SYMBOL_COLOR=cyan
source /root/kube-ps1.sh
PROMPT='$(kube_ps1)'$PROMPT
export PATH="/root/.krew/bin:$PATH"

SAVEHIST=1000
HISTFILE=/iac/.shell-history