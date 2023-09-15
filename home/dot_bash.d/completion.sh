
include() { test -f "${1}" && source "${1}"; }

include "${HOME}/bin/.vagrant/embedded/gems/2.3.2/gems/vagrant-2.3.2/contrib/bash/completion.sh"
include "${HOME}/.nvm/nvm.sh"
include "${HOME}/.nvm/bash_completion"

which chezmoi   >& /dev/null && source <( chezmoi   completion bash )
which kubectl   >& /dev/null && source <( kubectl   completion bash )
which kustomize >& /dev/null && source <( kustomize completion bash )

unset include
