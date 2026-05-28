# media-server
- RTSP 스트림을 webRTC 스트림으로 변환하여 송출시키는 서버입니다.
- based on MediaMTX
  
## 카메라 설정 방법
- RTSP 스트림을 변환할 카메라의 접속 정보를 cam_conf/example.conf 파일에 작성합니다.
- conf 파일 이름은 자유롭게 변경 가능합니다.
- 연결해야 할 카메라가 여러 대인 경우, 카메라 수 만큼 example.conf를 복사하여 사용하는 것을 권장합니다.
- 사용하지 않는 설정 파일은 삭제하여 주십시오.
- docker 환경에서 사용하는 경우, video-recorder 에 주입한 카메라 설정 파일을 그대로 사용해도 무방합니다.
- video-recorder 설정을 그대로 사용할 경우, cam_conf 디렉토리의 example.conf 파일을 삭제하고, 환경변수를 통해 사용할 conf 파일이 존재하는 디렉토리를 지정하여 주십시오.
```
cd cam_conf
cp example.conf <Camera Name>.conf
...
rm example.conf
```

### [카메라 연결 설정파일 옵션 설명]
- cam_name: 카메라 이름 / webRTC URL 접속 주소에 사용됩니다.
- cam_ip: 카메라 IPv4 주소 / 서버에서 카메라에 접속할 수 있도록 미리 조치하시기 바랍니다.
- cam_port: 카메라에 설정된 RTSP 포트 번호
- cam_rtsp_path: 카메라의 RTSP 엔드포인트 주소 / 카메라 제조사별로 상이하므로, 메뉴얼을 통해 엔드포인트 주소를 미리 확인하시기 바랍니다.
- username: 카메라 접근을 위한 계정의 UserName / 카메라 관리 페이지에서 설정한 값을 입력하십시오.
- password: 카메라 접근을 위한 계정의 비밀번호 / 카메라 관리 페이지에서 설정한 값을 입력하십시오.
  
## MediaMTX 환경설정
- mediaMTX 공식 Repository의 mediamtx.yml 파일을 참고하시기 바랍니다.
- https://github.com/bluenviron/mediamtx/blob/main/mediamtx.yml 
 
## 환경변수 작성 (컨테이너로 배포하는 경우)
```
   cp media-server.env.sample .media-server.env
```
#### [환경변수명 설명]
- MEDIA_SERVER_CONT_NAME: 컨테이너 이름
- MEDIA_SERVER_IMG_NAME: 컨테이너 이미지 이름(경로) / Image 빌드 시 사용하였던 container-name과 tag 사용 (e.g. media-server:latest)
- HOST_EXT_IP: Host 서버의 External IP
- MEDIA_SERVER_LOG_PATH_ROOT: 본 프로그램의 로그 저장 경로
- MEDIA_SERVER_CONF_PATH_ROOT: 본 프로그램의 설정 파일(mediaMTX.yml) 경로 // mediamtx.yml 파일을 입력해야 합니다. (DIR/mediamtx.yml)
- CAMERA_CONF_PATH_ROOT: 카메라 설정 파일 경로

## Docker Image 빌드
```
docker build -t <container-name>:<tag> .
```
- e.g) docker build -t media-server:latest .

## 컨테이너 실행
```
docker compose -f <Compose.yml 경로> --env-file <env경로> up -d
```
- e.g.) docker compose -f media-server-docker-compose.yml --env-file .media-server.env up -d

## Reference
- 인트라넷(폐쇄망) 배포에 대비하여, Github를 통해 배포되는 mediaMTX 소스코드를 가져와 활용합니다.
- 원본: https://github.com/bluenviron/mediamtx