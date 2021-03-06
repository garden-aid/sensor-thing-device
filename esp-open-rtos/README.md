## EXAMPLE BY @rongsaws

See https://github.com/SuperHouse/esp-open-rtos/pull/173

Please follow the steps below to build and run the example on your ESP8266.

1. Modify client_config.c to provide your own account-specific AWS IoT
 endpoint, ECC-based client certificate, and private key.

 Your endpoint is in the form of ```<prefix>.iot.<region>.amazonaws.com```.
 It can be retrieved using the following command:

 ```sh
 $ aws iot describe-endpoint
 ```

 Your ECC-based certificate and private key can be generated by using
 the following commands:

 ```sh
 $ openssl ecparam -out ecckey.key -name prime256v1 -genkey
 $ openssl req -new -sha256 -key ecckey.key -nodes -out eccCsr.csr
 $ aws iot create-certificate-from-csr --certificate-signing-request file://eccCsr.csr --certificate-pem-outfile eccCert.crt --set-as-active
 ```

 To convert the certificate or key file into C string, you could try
 the following example:

 ```sh
 $ cat ecckey.key | sed -e 's/^/"/g' | sed -e 's/$/\\r\\n"/g'
 ```

 *Note, more information about using ECC-based certificate with AWS IoT
 can be found in the following blog*

 https://aws.amazon.com/blogs/iot/elliptic-curve-cryptography-and-forward-secrecy-support-in-aws-iot-3/

2. Create and attach AWS IoT access policy to the certificate

 ```sh
 $ aws iot create-policy --policy-name test-thing-policy --policy-document '{ "Version": "2012-10-17", "Statement": [{"Action": ["iot:*"], "Resource": ["*"], "Effect": "Allow" }] }'
 $ aws iot attach-principal-policy --policy-name test-thing-policy --principal "arn:aws:iot:eu-west-1:892804553548:cert/2d9c2da32a95b5e95a277c3b8f7af40869727f5259dc2e907fc8aba916c857e"
 ```

 *Note, the 'principal' argument is the certificate ARN generated from the
 pervious command 'aws iot create-certificate-from-csr'.*

3. Modify include/ssid_config.h with your Wifi access Id and credential.

4. Build and flash the example firmware to the device using the command
 below:

 ```sh
 $ make flash -C examples/aws_iot ESPPORT=/dev/ttyUSB0
 ```

 *Note, it assumes your ESP8266 is connected through USB and exposed under
 your Linux host as /dev/ttyUSB0.*

5. Once the ESP8266 is connected to AWS IoT, you can use the MQTT client
 on the AWS IoT console to receive the messages published by the ESP8266
 to topic 'esp8266/status'. You could also publish 'on' or 'off' message
 to topic 'esp8266/control' to toggle the GPIO/LED (GPIO2 is used by the
 example).
