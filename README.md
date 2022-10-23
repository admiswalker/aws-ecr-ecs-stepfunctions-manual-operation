# aws-ecr-ecs-stepfunctions-manual-operation

## ECR に Docker image を push する

1. ECR にリポジトリを作成する
2. ログイン
```bash
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
AWS_REGION=ap-northeast-1
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```
※ 上手くログインできない場合は，Management console から ECR リポジトリに入り，「プッシュコマンドの表示」から認証コマンドを確認する．
3. 



- [Docker イメージをプッシュする](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/docker-push-ecr-image.html)
- [[AWS] ECRにDockerイメージをプッシュする](https://blog.katsubemakito.net/aws/aws-ecr-push-dockerimage)

## Step Functions

- [Step Functions で ECS タスク（Fargate）を定期実行してみる](https://dev.classmethod.jp/articles/try-to-retry-ecs-tasks-using-step-functions/)
