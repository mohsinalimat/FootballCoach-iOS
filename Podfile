platform :ios, '10.0'
use_frameworks!

def use_pod_list
    pod 'HexColors', '4.0.0'
    pod 'FCFileManager'
    pod 'AutoCoding'
    pod 'STPopup'
    pod 'RMessage'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'ATAppUpdater'
    pod 'DZNEmptyDataSet'
    pod 'MBProgressHUD'
    pod 'ScrollableSegmentedControl', '~> 1.3.0'
    pod 'Charts'
    pod 'ZGNavigationBarTitle'
    pod 'RSEmailFeedback'
    pod 'AccordionSwift', :git => 'https://github.com/Vkt0r/AccordionSwift.git'
    pod 'ZMJTipView'
end

target 'harbaughsim16' do
    use_pod_list
end

target 'cfctests' do
    use_pod_list
end


post_install do |installer|
    installer.aggregate_targets.each do |target|
        copy_pods_resources_path = "Pods/Target Support Files/#{target.name}/#{target.name}-resources.sh"
        string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
        assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
        text = File.read(copy_pods_resources_path)
        new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
        File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
    end
end
