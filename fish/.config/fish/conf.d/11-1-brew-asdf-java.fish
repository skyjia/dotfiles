set --local set_java_home $HOME/.asdf/plugins/java/set-java-home.fish

if test -f $set_java_home
    source $set_java_home
end
