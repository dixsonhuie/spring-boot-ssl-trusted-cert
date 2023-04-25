# spring-boot-ssl-trusted-cert
Spring Boot with SSL and trusted self signed client certificates

## This code was originally from mkyong.com
### What is it?
This source code is an Spring Boot SSL (HTTPS) example.

Tested with
* Maven 3
* Java 8
* Spring Boot 2.2.4.RELEASE
* Spring Boot default embedded Tomcat 9
* Self-signed certificate (PKCS12)

For explanation, please visit this article - [Spring Boot SSL (HTTPS) examples](https://mkyong.com/spring-boot/spring-boot-ssl-https-examples/)

### How to run this?
```bash
$ git clone https://github.com/mkyong/spring-boot

$ cd spring-boot-ssl

$ mvn clean package

$ java -jar target/spring-boot-web.jar

  access https://localhost:8443
```
## Demonstrate the ability to accept trusted certs from a client

1. Run `cert.sh`. It will create the server and client keystore, export the client cert, import the client cert into the server keystore and copy to the project resources directory.

2. The `application.yml` file has been modified so that web application expects the client to provide a certificate.
```
server:
  port: 8443
  ssl:
    enabled: true
    client-auth: need
    key-store: classpath:localhost.p12
    key-store-password: changeit
    key-alias: server
    key-store-type: PKCS12
    key-store-provider: SUN
    trust-store: classpath:localhost.p12
    trust-store-password: changeit
    trust-store-type: PKCS12
```    
3. As before, run the Spring Boot application:
```
mvn clean package
java -jar target/spring-boot-web.jar -Djavax.net.debug=all
```
4. Test with curl
```
curl -k --cert-type P12 --cert client.p12:changeit https://localhost:8443
```
5. Other useful commands:
```
keytool -list -storetype PKCS12 -keystore localhost.p12
keytool -v -printcert -file client.crt
```
