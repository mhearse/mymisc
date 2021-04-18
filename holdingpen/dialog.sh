#!/bin/bash
options=$(find . -name '*tmp*' | awk '{print $1, "on"}')
cmd=(dialog --stdout --no-items \
        --separate-output \
        --ok-label "Save" \
        --cancel-label "Cancel"\
        --checklist "Select options:" 22 76 16)
choices=$("${cmd[@]}" ${options})
echo $choices
