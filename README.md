# aws-ecr-ecs-stepfunctions-manual-operation

## ECR に Docker image を push する

Management console から ECR リポジトリに入り，「プッシュコマンドの表示」から認証コマンドを確認するのが一番はやい．コマンドに落とし込みたい場合は下記を参考にすること．

1. ECR にリポジトリを作成する
2. 環境変数の設定（docker image の push に使用する値を先に定義しておく）
   ```bash
   AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
   AWS_REGION=ap-northeast-1
   ECR_REPOSITORY_NAME=example_1023
   ```
3. ログイン
   ```bash
   aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
   ```
4. ローカル環境で docker image を build する．この際，tag を付ける．
   ```bash
   docker build -t ${ECR_REPOSITORY_NAME} .
   ```
   ※ たとえば，build 用の shell script に書き込んでおく．
5. イメージタグの付与 (push に必要)
   ```bash
   docker tag ${ECR_REPOSITORY_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest
   ```
6. ECR に push する
   ```bash
   docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest
   ```

- [Docker イメージをプッシュする](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/docker-push-ecr-image.html)
- [[AWS] ECRにDockerイメージをプッシュする](https://blog.katsubemakito.net/aws/aws-ecr-push-dockerimage)

## Step Functions

- [Step Functions で ECS タスク（Fargate）を定期実行してみる](https://dev.classmethod.jp/articles/try-to-retry-ecs-tasks-using-step-functions/)
