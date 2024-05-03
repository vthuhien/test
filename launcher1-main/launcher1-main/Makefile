APP_NAME = "launcher1"
BUILD_DATE = $(shell DATE +"%d.%m.%y_%H.%M")

VERSION_CODE := $(shell grep "version:" pubspec.yaml | cut -d':' -f2 | cut -d'+' -f2)
VERSION_NAME := $(shell grep "version:" pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1 | cut -d':' -f2)

# Adding a help file: https://gist.github.com/prwhite/8168133#gistcomment-1313022
help: ## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
		IFS=$$'#' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "%-30s %s\n" $$help_command $$help_info ; \
	done


apk: ## make Android APK
	@printf "Building APK..."
	@rm -rf ./build_done/android
	@mkdir -p build_done/android
	@flutter build apk --release --obfuscate --split-debug-info=./build/app/outputs/apk
	@cp -a ./build/app/outputs/apk/release/app-release.apk ./build_done/android/$(APP_NAME)_$(VERSION_CODE)_$(VERSION_NAME)_$(BUILD_DATE).apk
	@printf "DONE ./build_done/android/\n"
# @firebase crashlytics:symbols:upload --app=$(FIREBASE_ANDROID) ./build/app/outputs/apk/



res: ## Generate Dart Code for Res in Assets
	@fluttergen -c pubspec.yaml

# if 'Unable to generate package graph'
# remove generate: true in pubspec.yaml
lang:  ## Generate *.g.dart files
	@flutter gen-l10n  

# if 'Unable to generate package graph'
# remove generate: true in pubspec.yaml
gen:  ## Generate *.g.dart files
	@flutter pub get
	@flutter gen-l10n  
	@dart run build_runner build --delete-conflicting-outputs


pods: ## Update Pods
pods: clean
	@flutter pub get && cd ios/ && pod install --repo-update && cd ../ && flutter run

clean: ## clean Flutter Project
	@pod cache clean --all
	@rm -rf ./build_done
	@rm -rf ./android/.gradle
	@rm -rf ./ios/.symlinks
	@rm -rf pubspec.lock
	@rm -rf ios/Podfile.lock
	@flutter clean 


backup: ## backup Project to zip
backup: clean
	@zip -r $(APP_NAME)_$(BUILD_DATE).zip .
