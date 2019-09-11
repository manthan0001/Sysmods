test -d $HOME/dev/scripts 
and set PATH $HOME/dev/scripts $PATH

test -d $HOME/.local/bin
and set PATH $HOME/.local/bin $PATH

test -d $HOME/.cargo/bin
and set PATH $HOME/.cargo/bin $PATH

alias p=prevd
alias j=jobs

alias aws-google-auth='touch $HOME/.aws/credentials; touch $HOME/.aws/config; touch $HOME/.aws/saml_cache.xml; docker run -v $HOME/.aws:/root/.aws --rm -it -e GOOGLE_USERNAME=jason@swift-nav.com -e GOOGLE_IDP_ID=C02x4yyeb -e GOOGLE_SP_ID=115297745755 -e AWS_DEFAULT_REGION=us-west-2 -e AWS_PROFILE=default cevoaustralia/aws-google-auth'

set -e pure_color_mute
set -U pure_color_mute (set_color normal)

command -v bass
and test -f ~/.nix-profile/etc/profile.d/nix.sh
and bass source ~/.nix-profile/etc/profile.d/nix.sh

command -v rvm
and rvm default

set -U FZF_DEFAULT_OPTS "--color info:254,prompt:37,spinner:108,pointer:235,marker:235"

function kp --description "Kill processes"
  set -l __kp__pid ''
  if contains -- '--tcp' $argv
    set __kp__pid (lsof -Pwni tcp | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:tcp]'" | awk '{print $2}')
  else
    set __kp__pid (ps -ef | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:process]'" | awk '{print $2}')
  end
  if test "x$__kp__pid" != "x"
    if test "x$argv[1]" != "x"
      echo $__kp__pid | xargs kill $argv[1]
    else
      echo $__kp__pid | xargs kill -9
    end
    kp
  end
end

function docker_stop
  docker ps --format '{{.ID}}\tNAME={{.Names}}\tIMAGE={{.Image}}\tCOMMAND={{.Command}}' | table \t 15 40 30 '*' \
    | eval "fzf $FZF_DEFAULT_OPTS -m --header='[docker:stop]'" \
    | field 0 \
    | xargs docker stop 
end

function docker_rmi
  docker images --format='{{.ID}}\tSIZE={{.Size}}\tAGE={{.CreatedSince}}\t{{.Repository}}:{{.Tag}}' | table \t 15 15 20 '*' \
    | sort -n -k 2 -t = \
    | eval "fzf $FZF_DEFAULT_OPTS -m --header='[docker:remove]'" \
    | field 0 \
    | xargs docker rmi
end

function docker_rm
  docker ps -a --format '{{.ID}}\tNAME={{.Names}}\tIMAGE={{.Image}}\tSTATUS={{.Status}}\tCOMMAND={{.Command}}' | table \t 15 40 30 30 '*' \
    | eval "fzf $FZF_DEFAULT_OPTS -m --header='[docker:remove]'" \
    | field 0 \
    | xargs docker rm
end

function shake
  ./Shakefile.hs
end

export GROOVY_HOME=/usr/local/opt/groovy/libexec

function _aws_cfg_field -a field
  grep $field ~/.aws/credentials|cut -d= -f2 | sed 's@^ *@@'
end

function aws_google_auth_env
  export AWS_ACCESS_KEY_ID=(_aws_cfg_field aws_access_key_id)
  export AWS_SECRET_ACCESS_KEY=(_aws_cfg_field aws_secret_access_key)
  export AWS_SESSION_TOKEN=(_aws_cfg_field aws_session_token)
  export AWS_DEFAULT_REGION=us-west-2
  export AWS_REGION=us-west-2
end

export HELM_HOME=$HOME/helm

alias k kubectl