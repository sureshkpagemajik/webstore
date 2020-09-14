#!/bin/bash

source=/opt/egbtm/

cp -R $source  $PWD/Modules/customers/egbtm/
cp -R $source  $PWD/Modules/customers/egbtm/
cp -R $source  $PWD/Modules/customers/egbtm/
cp -R $source  $PWD/Modules/gateway/egbtm/
cp -R $source  $PWD/Modules/order/egbtm/
cp -R $source  $PWD/Modules/payment/egbtm/
cp -R $source  $PWD/Modules/products/egbtm/
cp -R $source  $PWD/Modules/quote/egbtm/
cp -R $source  $PWD/Modules/webstore/egbtm/

echo copied to all Microservices.
echo Starting docker-compose with btm_embedded method... 

docker-compose -f btm_embedded/docker-compose.yml up -d
