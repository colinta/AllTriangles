project do |p|
    p.project_name = "AllTriangles"
    p.class_prefix = "FW"
    p.organization = "colinta"

    p.debug_configuration.settings["ENABLE_TESTABILITY"] = "YES"
end

application_for :ios, 8.0, :swift do |target|
    target.name = "All Triangles"

    target.all_configurations.supported_devices = :universal
    target.all_configurations.product_bundle_identifier = "com.colinta.AllTriangles"

    target.include_files = ["Source/**/*", "Resources/**/*"]

    target.all_configurations.settings["INFOPLIST_FILE"] = "Support/Info.plist"
    target.all_configurations.settings["SWIFT_OBJC_BRIDGING_HEADER"] = "Support/BridgingHeader.h"

    # target.release_configuration.settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"

    target.system_frameworks << 'SpriteKit'
end
