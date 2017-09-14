## Tyk REST GRPC Proxy Plugin Bakery

To use this container you must have a copy of the Tyk source:

    git clone https://github.com/TykTechnologies/tyk.git
    cd tyk
    git checkout grpc-proxy
    cd ..
    mkdir proto

Place your `proto` file into the `proto/` folder so the container can find it. Then run the container:

    docker run --rm -v $PWD/proto/:/proto -v $PWD/tyk/vendor/:/go/src tykio/bakery grpc {PROTOFILENAME} {SERVICENAME}

- `PROTOFILENAME` Will be *just the name* of the file so we know what proto file to work on
- `SERVICENAME` Will be the CamelCase name of your service, so if it is called `your_service`, this will be `YourService` it will start with a capital letter.

This will generate a `plugin.so` file which you can then bundle using `tyk-cli` and deploy to your gateway using the bundle downloader.