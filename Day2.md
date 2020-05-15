# Day 2
## 트러블 슈팅 및 각종 꿀팁 명령어

- 이미지가 어떻게 빌드됐는지 볼 수 있다.
`docker history sample-app:latest`

- 이전에 돌렸던 컨테이너 기록들 출력
`docker container ls -a`

- 한번만 이미지 돌려도 컨테이너 기록에 남게되서 불필요한 기록이 많아진다.
  - 종료된 컨테이너 한번에 삭제하는 커맨드
  `docker container prune`
  - 이미지도 삭제 가능
  `docker image prune`

- 쓸모없는 컨테이너 기록을 남기지 않고 실행하려면 --rm 옵션 추가
- docker run은 컨테이너 생성 -> 컨테이너 실행을 의미함 만약 컨테이너를 생성하고 싶지 않으면 run 명령에 --rm 옵션을 추가
`docker run --rm -it ubuntu:18.04 /bin/bash`

- 빌드된 이미지를 컨테이너로 실행
`docker container exec -it $컨테이너ID /bin/sh`

- 어떤 프로세스가 돌고 있는지 확인
`docker container top $컨테이너ID`

- 내가 돌리고 있는 프로세스가 어떤 자원을 소모하고 있는지 확인
`docker container ps`

- dockerfile이 여러개인 경우 -f로 빌드할 dockerfile 이름을 가리킬 수 있다.
`docker build -t sample-app:latest -f my.dockerfile .`

- -d : detach를 이용해서 컨테이너를 백그라운드에서 실행 -p : 외부에 포트 공개
`docker run -d -p 8080:8080 sample-app:latest`

- 도커 정보 명령어
`docker info`

## compose

- 도커 실행시 쳐야할 명령어가 너무 많아서 그걸 한 파일로 관리하려고 합쳐놓은게 compose 파일이다.
compose 파일이 발전해서 나온게 오케스트레이션

- `touch docker-compose.yaml` 명령으로 파일 생성 및 작성
  - version과 services 정의, yaml 포맷 숙지 필요
  ```
  version: '3.7'
  services:
    $서비스명:
      build:
        dockerfile: ./my.dockerfile
        context: .
      ports:
        - 8080:8080
  ```

- `docker build -f ./my.dockerfile -t $서비스명:latest .`
- `docker run -d -p 8080:8080 $서비스명:latest`


- compose 파일 실행
`docker-compose $파일명 up`

- 올렸던거 내리기
`docker-compose $파일명 down`


### mediawiki 실습
- mediawiki - compose의 우수한 예제
- mediawiki.docker-compose.yaml 파일 생성 후 https://hub.docker.com/_/mediawiki의 'Example stack.yml for mediawiki:' 내용 이용

- 실행 및 종료
  - docker-compose -f mediawiki.docker-compose.yaml up (실행)
  - http://localhost:8080 - docker compose 실행됨을 확인할 수 있음.
  - docker-compose -f mediawiki.docker-compose.yaml down (종료)
- volumes; compose file에 services 하위에 volumes 존재 volume : 컨테이너가 종료돼도 저장되는 디렉토리 선정
  - docker volume ls
  - volume은 docker 외부에 저장되는 데이터이지만 바깥에 쓰일 이름을 주지 않아서 이름 출력이 되지 않음. mediawiki
  - volume
    볼륨에 관해서 첨언을 드리자면 도커 컨테이너는 컨테이너 레이어에 파일 시스템(UnionFs)을 가지고 있는데 볼륨은 외부(호스트os, 다른컨테이너)에 파일 시스템을 연결 해주는 거에요. 호스트 - 컨테이너, 컨테이너 - 컨테이너 같이 외부와 파일시스템를 연결할때 사용해요. ex) 어플리케이션을 돌릴때 컨테이너 내부의 로그 파일을 호스트 os의 로그 디렉토리에 연결