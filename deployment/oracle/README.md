# Oracle VM 배포

이 디렉터리는 Oracle Always Free VM에서 Docker 기반 FastAPI를 실행하기 위한 예시 파일을 둡니다.

Oracle은 애플리케이션 실행 서버로 사용하고, 운영 DB와 파일 저장소는 기존처럼 Cloudflare D1/R2를 사용합니다.

```text
Oracle VM
  -> Docker Compose
      -> Uvicorn
          -> FastAPI
              -> Cloudflare D1 / R2
```

## 1. 서버 준비

Ubuntu VM에 SSH로 접속한 뒤 Docker와 Compose plugin을 설치합니다.

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin git
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
```

그룹 변경을 반영하려면 SSH를 종료한 뒤 다시 접속합니다.

```bash
exit
```

## 2. 소스 가져오기

운영에 사용할 브랜치를 확인한 뒤 저장소를 내려받습니다.

```bash
    git clone <repository-url>
    cd <repository-directory>
    git checkout master
```

운영 브랜치를 별도로 정하면 해당 브랜치명으로 바꿉니다.

## 3. 환경변수 작성

저장소 루트에서 `.env.example`을 복사해 `.env`를 작성합니다.

```bash
cp .env.example .env
chmod 600 .env
nano .env
```

Oracle VM에서 실행하는 FastAPI가 사용하는 값은 다음과 같습니다.

```env
SECRET_KEY=<long-random-secret>
DISPLAY_TIMEZONE=Asia/Seoul
REPOSITORY_BACKEND=d1
STORAGE_BACKEND=r2

CLOUDFLARE_ACCOUNT_ID=<cloudflare-account-id>
D1_DATABASE_ID=<d1-database-id>
CLOUDFLARE_API_TOKEN=<d1-read-write-api-token>

R2_BUCKET_NAME=<r2-bucket-name>
R2_ACCOUNT_ID=<cloudflare-account-id>
R2_ACCESS_KEY_ID=<r2-access-key-id>
R2_SECRET_ACCESS_KEY=<r2-secret-access-key>
R2_PUBLIC_BASE_URL=<r2-public-base-url>
```

`CLOUDFLARE_API_TOKEN`은 배포 전용 토큰이 아니라 FastAPI가 D1 REST API를 호출할 수 있는 권한을 가져야 합니다. R2 업로드를 사용하려면 R2 S3 API용 Access Key와 Secret Access Key가 별도로 필요합니다.

`.env`는 절대로 Git에 커밋하지 않습니다.

## 4. FastAPI 실행

예시 Compose 파일을 실제 파일로 복사합니다.

```bash
cp deployment/oracle/docker-compose.yml.example deployment/oracle/docker-compose.yml
```

저장소 루트에서 이미지를 빌드하고 컨테이너를 시작합니다. Dockerfile의 multi-stage build가 Node 환경에서 React 프론트를 빌드한 뒤, 결과물을 FastAPI 이미지에 포함합니다. 따라서 Oracle VM에 Node/npm을 별도로 설치하거나 `app/static/frontend`를 Git에서 내려받을 필요가 없습니다.

```bash
docker compose -f deployment/oracle/docker-compose.yml up -d --build
```

상태와 로그를 확인합니다.

```bash
docker compose -f deployment/oracle/docker-compose.yml ps
docker compose -f deployment/oracle/docker-compose.yml logs -f fastapi
```

Compose는 호스트의 `8000` 포트를 외부에 직접 공개하지 않고 `127.0.0.1:8000`으로만 연결합니다. 이후 Nginx 또는 Caddy가 80/443 요청을 받아 FastAPI로 전달하는 구조를 사용합니다.

## 5. 로컬 확인

VM 내부에서 health endpoint를 확인합니다.

```bash
curl http://127.0.0.1:8000/health
```

정상적으로 시작되면 응답에 다음 값이 포함됩니다.

```json
{
  "ok": true,
  "repository_backend": "d1",
  "storage_backend": "r2",
  "database_role": "shadow"
}
```

`database_role`이 `shadow`인 것은 오류가 아닙니다. D1을 원본으로 사용하고, 공용 repository helper를 위해 로컬 SQLite를 보조 DB로 사용하는 현재 구조를 의미합니다.

## 6. 코드 반영

새 버전을 반영할 때는 서버에서 다음 명령을 실행합니다.

```bash
git pull origin master
docker compose -f deployment/oracle/docker-compose.yml up -d --build --force-recreate
```

프론트 소스가 변경되면 Docker build cache가 해당 단계부터 다시 실행되며, `npm ci`는 `frontend/package-lock.json` 기준으로 의존성을 설치합니다. 호스트의 Node 설치나 호스트 디렉터리의 프론트 산출물은 필요하지 않습니다.

현재 Compose 설정은 `restart: unless-stopped`를 사용하므로 VM 재부팅 후에도 컨테이너가 자동으로 다시 시작됩니다.

`/app/instance`는 named volume으로 연결되어 페이지뷰 로그와 SQLite shadow DB가 컨테이너 재생성 후에도 유지됩니다. 운영 데이터의 원본은 계속 D1이며, 에셋 파일의 원본은 R2입니다.

## 7. 다음 운영 계층

현재 단계에서는 FastAPI가 VM 내부의 `127.0.0.1:8000`에서 실행됩니다. 외부 도메인 연결을 위해 다음 작업이 필요합니다.

1. Nginx 또는 Caddy 설치
2. 도메인에 대한 reverse proxy 설정
3. HTTPS 인증서 설정
4. Cloudflare DNS 레코드 연결
5. 외부에서 `/health` 확인
6. Cloudflare Access 또는 별도 인증 계층 적용

인증 계층을 적용하기 전에는 Oracle 공인 IP나 도메인을 외부에 공개하지 않습니다.
