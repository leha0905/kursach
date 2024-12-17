#!/bin/bash

cleanup() {
    echo "Killing procs..."
    kill $SERVER_PID
    kill $FLUTTER_PID

    echo "Cleaning up cache and temporary data..."
    rm -rf ../lib/flutter_application/build/web
    rm -rf ~/.cache/google-chrome/Default/Cache

    exit
}

trap cleanup SIGINT SIGHUP

cd server
go run main.go parser.go &
SERVER_PID=$!

cd ../app/lib
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
flutter run -d chrome --dart-define=BASE_URL=http://localhost:8080 --web-port=3000 &
FLUTTER_PID=$!

wait $SERVER_PID
wait $FLUTTER_PID