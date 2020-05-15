# Day 1
## Docker 기초
터미널에서 실습
### 예제 1) hello-world
이미지 내려받고 실행하기
```
docker pull hello-world
docker run hello-world
```
- [도커 허브 사이트](https://hub.docker.com/)에서 다운로드 수가 높은 **검증된** 이미지를 받아야 한다.

### 예제 2) ubuntu:18.04
버전을 명시하는 경우 docker pull `$태그명:$버전명` (:latest는 생략 가능)

```
docker pull ubuntu:18.04
docker run -it ubuntu:18.04 /bin/bash
```
- 우분투의 경우 기본적으로 떠있는 프로세스가 없어서 그냥 run을 하게 되면 바로 종료된다.
- -it 옵션과 뒤에 /bin/bash 를 붙여주어 쉘 스크립트 환경으로 연결 시켜줘야 한다.(i: interaction, t:tty)
- 이미지를 실행한 채로 `docker container ls`명령어를 입력하면 실행중인 도커 컨테이너가 출력된다.
- 우분투 cmd 환경에서 exit으로 종료시키고 다시 `docker container ls` 해보면 조회 안됨.
- `docker container ls -a`로 조회하면 종료된 컨테이너 확인 가능. 로그 확인 등의 디버깅에 이용 가능.

## vue app 이미지 생성 및 실행
### vue cli로 app 생성
```
vue create sample-app
```
### docker node 실행
[도커 허브 노드 이미지](https://hub.docker.com/_/node)
```
docker pull node
docker run -it node /bin/sh // 쉘 스크립트로 진입
node // node 실행
1 + 1 // 2 출력
console.log('hello world') // hello world 출력
```
- 해당 이미지에 Linux OS가 포함되어 있어서 node 이미지를 실행하면 Linux가 실행되고 거기에 설치된 node를 사용할 수 있음.

### dockerfile 작성 및 이미지 생성
아까 만들어둔 sample-app 폴더에 dockerfile 생성
```
touch dockerfile
```
dockerfile에 다음과 같이 작성한다. (보통 docker hub에 해당 이미지 페이지나 관련 깃헙 페이지를 참고한다.)
```
FROM node
WORKDIR /home/node/app
COPY . .
CMD yarn serve
```
파일 저장 후 터미널에서 다음 명령어 실행.
```
docker build -t sample-app:latest .
```
맨 뒤에 `.`(점)을 꼭 찍어줘야 한다. dockerfile에 작성된걸 바탕으로 이미지가 생성된다.    
`docker image ls`로 이미지 목록 출력해서 생성된 이미지 확인.    
생성한 이미지를 실행해보자.
```
docker run sample-app:latest
```
성공적으로 실행되면 `http://localhost:8080/` 터미널에 이렇게 로컬호스트 경로가 뜨고 브라우저로 열어보면 사이트에 연결할 수 없다고 나온다.
그러면 성공한 것이다. (보안상의 이유로 접속 막음)

### 실행중인 컨테이너 접속 및 종료
#### 접속
vue app을 띄워놓은 채로 새로운 터미널을 열어서 `docker container ls` 명령어로 컨테이너 ID를 확인한다.
확인 후 다음 명령어 입력.
```
docker container exec -it {CONTAINER ID} /bin/sh
```
연결되면 `top` 이라고 입력해보면 node가 실행되고 있음을 확인할 수 있다.   
#### 종료
다음 명령어 입력 시 node 프로세스 모두 종료
```
pkill node
```
PID 1번으로 잡힌 프로세스가 꺼지면 컨테이너도 자동 종료

## 기타
### dockerfile 작성시
앞서 실습에서는 `COPY . .` 명령어로 모든 파일을 복사했는데 실무에서는 그럴 필요 없이 `package.json`/`package-lock.json` 파일만 복사해주고 npm install이나 yarn install을 실행해주면 된다.
### 도움말
- 이미지 = 씨디
- 컨테이너 = 씨디로 설치한 것
- run/exec -it : (i: interaction, t:tty)
