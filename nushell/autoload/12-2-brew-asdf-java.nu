
# source ~/.asdf/plugins/java/set-java-home.nu

# FIXME: This is a tricky part.
def --env asdf_update_java_home [] {
    let $java_path = (asdf which java)

    if ($java_path | is-not-empty) {
        let $full_path = (realpath $java_path | lines | first | str trim)

        let $java_home = ($full_path | path dirname | path dirname)
        $env.JAVA_HOME = $java_home
        $env.JDK_HOME = $java_home
        echo $java_home
    }
}
