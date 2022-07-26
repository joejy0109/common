#!/bin/bash

# Add or replace value of the export environment variable.
set_exp_env() {
    local TARGET=$1
    local REPLACE=$2
    local ADD_BIN_TO_PATH=$3

    local PROFILES=( $HOME/.bashrc $HOME/.profile $HOME/.bash_profile )
    local TARGET_PROFILE="$HOME/.bashrc"
    
    local ADDNEW='1'
    for p in ${PROFILES[@]}; do
        EXISTS=$(grep -irs "^export $TARGET" $p | cut -d ':' -f2)
        if ! [ -z "$EXISTS" ]; then
            sed -i "s|^export ${TARGET}=\(.*\)|export ${TARGET}=${REPLACE}|gi" $p
            ADDNEW='0'
        fi
    done

    if [ "$ADDNEW" = '1' ]; then
        cat << EOL >> $TARGET_PROFILE
export ${TARGET}=${REPLACE}
EOL
    fi

    if [ "$ADD_BIN_TO_PATH" = '1' ]; then
        cat << EOL >> $TARGET_PROFILE
export PATH=\$PATH:\$${TARGET}/bin
EOL
    fi
    
    echo $TARGET_PROFILE
}
