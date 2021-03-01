#!/bin/bash -e

EDU_ACCOUNT=$1

# Setup pal-tracker codebase

cd ~/workspace
wget https://github.com/platform-acceleration-lab/pal-tracker/releases/download/platform-acceleration-cnd-release-12.3.70/pal-tracker.zip
unzip pal-tracker.zip
rm pal-tracker.zip

# Setup auto scaler plugin
wget https://github.com/billkable/patch-cnd-remote-desktop/raw/main/autoscaler-for-pcf-cliplugin-linux64-binary-2.0.233
cf install-plugin -f autoscaler-for-pcf-cliplugin-linux64-binary-2.0.233
rm autoscaler-for-pcf-cliplugin-linux64-binary-2.0.233

# Setup mysql plugin
cf install-plugin -r "CF-Community" -f mysql-plugin

# Setup git global config

git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"

# Setup assignment submission

mkdir -p ~/workspace/assignment-submission
cd ~/workspace/assignment-submission
gradle wrapper

cat > build.gradle <<EOF
buildscript {
    repositories {
        maven { url "http://platform-acceleration-lab-maven.s3.amazonaws.com" }
        jcenter()
    }

    dependencies {
        classpath "io.pivotal.pal.assignments:assignments-plugin:5.4.1"
    }
}

apply plugin: "io.pivotal.pal.assignments.plugin"

assignments {
    apiUrl = "https://assignments.education.pivotal.io/"
    emails = [
       "EMAIL"
    ]
    courseCode = "CND"
}

defaultTasks "tasks"
EOF

sed -i "s/EMAIL/${EDU_ACCOUNT}/g" build.gradle

./gradlew testAssignment -PexampleUrl=https://example.com