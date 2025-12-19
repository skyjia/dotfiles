# ----- Network Proxy BEGIN -----

def --env get_sys_proxy [] {
    # Cache scutil --proxy output for 10 seconds
    let now = (date now | format date "%s" | into int)
    if ( ($env | get SCUTIL_PROXY_CACHE_TIME? | is-not-empty) and ($now - ($env.SCUTIL_PROXY_CACHE_TIME | into int)) <= 10) {
        $env.SCUTIL_PROXY_CACHE
    } else {
        let proxy = scutil --proxy
        $env.SCUTIL_PROXY_CACHE = $proxy
        $env.SCUTIL_PROXY_CACHE_TIME = $now
        $proxy
    }
}

def get_sys_proxy_value [key: string] {
    let v = get_sys_proxy | lines | where {|l| ($l | str trim | split row ' ' | first) == $key }
    if ($v | is-empty) {
        ''
    } else {
        $v | str trim | split row ' ' | get 2?
    }
}

def get_sys_proxy_list [key: string] {
    get_sys_proxy | lines | find $key | skip 1 | take until {|l| $l =~ '}' } | each {|l| $l | split row ' ' | get 2? } | compact | str join ','
}

def is_sys_proxy_enabled [] {
    (get_sys_proxy_value 'HTTPEnable') == '1'
}

def --env set_proxy [] {
    let http_proxy = get_sys_proxy_value 'HTTPProxy'
    let http_port = get_sys_proxy_value 'HTTPPort'
    let https_proxy = get_sys_proxy_value 'HTTPSProxy'
    let https_port = get_sys_proxy_value 'HTTPSPort'
    let http =  $http_proxy + ':' + $http_port 
    let https =  $https_proxy + ':' + $https_port
    let socks = get_sys_proxy_value 'SOCKSProxy'
    let socks_port = get_sys_proxy_value 'SOCKSPort'
    # let no_proxy = (get_sys_proxy_list 'ExceptionsList' | default '')

    $env.HTTP_PROXY = 'http://' + $https
    $env.HTTPS_PROXY = 'http://' + $https
    # $env.NO_PROXY = $no_proxy

    # $env.http_proxy = $env.HTTP_PROXY
    # $env.https_proxy = $env.HTTPS_PROXY
    if ($socks | is-not-empty) and ($socks_port | is-not-empty) {
        $env.ALL_PROXY = 'socks5h://' + $socks + ':' + $socks_port
        # $env.all_proxy = $env.ALL_PROXY
    }

    ^git config --global http.proxy $env.HTTP_PROXY
    ^git config --global https.proxy $env.HTTPS_PROXY
}

# Check and remove specified environment variable
def --env unset_env [env_name] {
    if ( $env | get --optional $env_name | is-not-empty) {
        hide-env $env_name
    }
}

def --env unset_proxy [] {
    unset_env HTTP_PROXY
    unset_env HTTPS_PROXY
    unset_env NO_PROXY
    unset_env http_proxy
    unset_env https_proxy
    unset_env no_proxy
    unset_env ALL_PROXY
    unset_env all_proxy
    ^git config --global --unset http.proxy
    ^git config --global --unset https.proxy
}


def --env ensure_enable_proxy [] {
    if (is_sys_proxy_enabled) {
        print "System proxy is enabled. Setting environment variables."
        set_proxy
    } else {
        print "System proxy is not enabled."
        unset_proxy
    }
}

def --env toggle_proxy [] {
    if (( $env | get HTTP_PROXY? | is-empty) and ($env | get HTTPS_PROXY? | is-empty)) {
        print "No proxy is currently set. Enabling system proxy."
        ensure_enable_proxy
    } else {
        print "Proxy is currently set. Disabling system proxy."
        unset_proxy
    }
}

# Only run ensure_enable_proxy if this script is executed directly, not sourced
ensure_enable_proxy

alias tp = toggle_proxy
alias tpe = ensure_enable_proxy
alias tpd = unset_proxy

# ----- Network Proxy END -----
