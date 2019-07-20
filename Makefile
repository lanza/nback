
all:
	xcodebuild -workspace nBack.xcworspace -scheme nBack -allowProvisioningUpdates clean
	xcodebuild -workspace nBack.xcworspace -scheme nBack -allowProvisioningUpdates build | tee lastbuild.log
	XCCompilationDB lastbuild.log

