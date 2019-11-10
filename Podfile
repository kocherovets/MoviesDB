source 'https://github.com/CocoaPods/Specs.git'
workspace 'MoviesDB'
platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!

def shared_pods
    pod 'ReduxVM'
end

target "MoviesDB" do
    project 'MoviesDB'

    shared_pods
end


target "MoviesDBTests" do
    project 'MoviesDB'

    shared_pods
end

target "MoviesDBUITests" do
    project 'MoviesDB'

    shared_pods
end
