#使用方法
#将这个文件和.plist文件一起放入.xcodeproj所在的文件夹下，然后设置下面的ProjectName和SchemeName，运行即可
#.plist文件里method的取值有app-store、enterprise、ad-hoc、development

#工程绝对路径
project_path=$(cd `dirname $0`; pwd)
#工程名
project_name=YourProjectName
#scheme名
scheme_name=YourSchemeName
#build文件夹路径
build_path=${project_path}/build
#plist文件所在路径
exportOptionsPlistPath=${project_path}/exportOptions.plist
#导出文件所在路径
exportFilePath=$(pwd)/Desktop

# 打印scheme
xcodebuild \
-list \
-project ${project_path}/${project_name}.xcodeproj || exit

#清理工程
xcodebuild \
-project ${project_path}/${project_name}.xcodeproj clean || exit

#编译工程
xcodebuild \
archive -project ${project_path}/${project_name}.xcodeproj \
-scheme ${scheme_name} \
-archivePath ${build_path}/${project_name}.xcarchive || exit

# 打包
xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-exportPath ${exportFilePath} \
-exportOptionsPlist ${exportOptionsPlistPath} || exit

if [ -e $exportFilePath/$scheme_name.ipa ]; then
    echo "\n-=-=-=-=-=-=-=\n\n\n"
    echo "Build Success!"
    open $exportFilePath
else
    echo "\n-=-=-=-=-=-=-=\n\n"
    echo "error: Create IPA failed!"
fi
