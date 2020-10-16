#!/bin/bash

deploy=${deploy:-}
sonar=${sonar:-}

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"

        if [[ -n $2 && $2 != --* ]]; then
          declare $param="$2"
        else
          declare $param=1
        fi
        # echo $1 $2 // Optional to see the parameter:value result
   fi
  shift
done

IFIT_PROJECT_NAME=Undisposed.Fody

IFIT_MYGET_SOURCE=https://www.myget.org/F/orbital-drop-bear
IFIT_MYGET_KEY=a3606564-016d-4678-9d1f-62c301fbebfa

if [[ -z $sonar ]]; then
  git clean -fdX
fi
nuget restore
msbuild $IFIT_PROJECT_NAME/$IFIT_PROJECT_NAME.csproj /property:Configuration=Release
msbuild $IFIT_PROJECT_NAME/$IFIT_PROJECT_NAME.csproj /p:Configuration=Release /t:pack

if [[ -n $deploy ]]
then
  nuget push $IFIT_PROJECT_NAME/bin/Release/$IFIT_PROJECT_NAME.*.nupkg $IFIT_MYGET_KEY -Source $IFIT_MYGET_SOURCE
fi
