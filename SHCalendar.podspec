Pod::Spec.new do | s |
    s.name = "SHCalendar"
    s.version = "1.0.0"

    s.summary = "万年历、日历选择"
    s.license = "MIT"
    s.author = {"CCSH" => "624089195@qq.com"}
    s.homepage = "https://github.com/CCSH/#{s.name}"
    s.source = {:git => "https://github.com/CCSH/#{s.name}.git", :tag => "#{s.version}"}
    
    s.source_files = "#{s.name}/*.{h,m}"

end
