#!/bin/bash

releaseVersion="$1"
devVersion="$2"

echo "Change project to new version: ${releaseVersion}"

mvn -N versions:update-child-modules versions:set -DgroupId=com.morningstar -DartifactId=finametrica-api -DnewVersion=$releaseVersion -DnextSnapshot=false
mvn versions:commit

projectVersion=$(mvn org.apache.maven.plugins:maven-help-plugin:2.2:evaluate -Dexpression=project.version|grep -Ev '(^\[|Download\w+:)')
echo "Project version: ${projectVersion}"

echo "Commit push and tag..."
git branch -f master HEAD
git checkout master

git add .
git commit -m "New release from Jenkins"
git push -f origin master
git tag $projectVersion
git push -f origin $projectVersion

echo "Change project to new development version"
mvn -N versions:update-child-modules versions:set -DgroupId=com.morningstar -DartifactId=finametrica-api -DnewVersion=$devVersion -DnextSnapshot=false
mvn versions:commit

echo "Commit push to ${devVersion}"
git branch -f master HEAD
git checkout master

git add .
git commit -m "New development release from Jenkins"
git push -f origin master
