#!/bin/sh
if [[ $CIRCLE_BRANCH != pull* ]]
then
        git config --global user.name "jogendra"
        git config --global user.email "imjog24@gmail.com"
        git clone --quiet --branch=ipa https://jogendra:$GITHUB_API_KEY@github.com/fossasia/open-event-orga-iOS ipa > /dev/null
        ls

        cd ipa

        # Delete all stale files
	find . -path ./.git -prune -o -exec rm -rf {} \; 2> /dev/null
	git add .

        # temporary commit to persist delete file changes
        git commit -m "temp"

        # Checkout a temporary branch to delete original ipa branch later
        git checkout --orphan temp

        cp -r $HOME/Library/Developer/Xcode/DerivedData/EventyayOrganizer-*/Build/Products/Debug-iphonesimulator/EventyayOrganizer.app EventyayOrganizer.app
        mkdir Payload
        mv EventyayOrganizer.app Payload/
        zip -r Payload.zip Payload
        mv Payload.zip EventyayOrganizer.ipa
        rm -rf Payload/
        ls -a

	# Add the EventyayOrganizer ipa
        git add EventyayOrganizer.ipa

        git commit -am "[Circle CI] Updated EventyayOrganizer.ipa"
        
        # Delete original ipa branch
        git branch -D ipa

        # Rename 'temp' branch to ipa
        git branch -m ipa

        # Perform force push since histories are unrelated
        git push origin ipa --force --quiet > /dev/null
fi
