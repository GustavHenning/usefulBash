#!/bin/bash

# if ($i == "FAIL") printf "%s", red "FAIL" reset;

{ pip install --upgrade --quiet pip \
&& pip freeze --local --quiet | grep -v \'^\-e\' | cut -d = -f 1  | xargs -n1 sudo -H pip install --user -U;  } | 
    awk -v "red=$(tput setaf 1)" -v "green=$(tput setaf 2)" \
        -v "reset=$(tput sgr0)" '
    { for (i = 1; i <= NF; i++) {
           if ($(i-1) == "up-to-date:") printf green "✓ %s\n", $i reset;
           else if($(i-1) == "installed") printf green "⇅ %s\n", $i reset;
           else if($(i-1) == "uninstalled") printf red "⇅ %s\n", $i reset;
           #else printf "%s", $i

           if (i == NF) printf "";
           else printf "%s", OFS 
      }}'
