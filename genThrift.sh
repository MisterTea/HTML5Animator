rm -Rf gen-java src/main/webapp/gen-js gen-py
find thrift/ -type f | xargs -I repme /Users/jgauci/apache/thrift-0.9.0-dev/compiler/cpp/thrift -gen java repme
find thrift/ -type f | xargs -I repme /Users/jgauci/apache/thrift-0.9.0-dev/compiler/cpp/thrift -gen js:jquery repme
mv gen-js src/main/webapp/
find thrift/ -type f | xargs -I repme /Users/jgauci/apache/thrift-0.9.0-dev/compiler/cpp/thrift -gen py:new_style repme
