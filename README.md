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

1. Step Function から呼び出す設定を ECS の task definition で作成する
   1. 設定画面に入る  
      Management Console → ECS → 新しいタスク定義の作成
   2. 設定の入力 (1/x)
      - タスク定義ファミリー: example_task_1023
      - コンテナ - 1
        - 名前: example_task_1023
        - イメージ URI: xxxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/example_1023:latest
        - 必須コンテナ: はい
      - コンテナポート
        - 80 / TCP (使わないが，はじめてなので，そのままにしておく)
   3. 設定の入力 (2/x)
      - アプリケーション環境: AWS Fargate (サーバーレス)
      - オペレーティングシステム/アーキテクチャ: Linux/X86_64
      - タスクサイズ
        - CPU: 1 vCPU
        - メモリ: 2GB
      - タスクロール: なし
      - タスク実行ロール: 新しいロールの作成
      - ストレージオプション: 21 GiB（デフォルトのまま）
      - モニタリングとログ記録 - オプション
        - デフォルトのまま
    4. 作成ボタンを押す

2. ECS クラスターの作成
   - example_cluster_1023


3. Step Functions から ECS Task を呼び出す部分を作成する
   1. 設定画面に入る  
      Management Console → Step Functions → ステートマシンの作成
   2. 標準 → 次へ
   3. ECS RunTask をドラッグ＆ドロップ
      - API パラメータ
        - TaskDefinition: ECS の task definition で作成した task の ARN を指定する
   4. ステートマシン設定を指定
      - MyStateMachine_example_1023

4. IAM ロールに権限の付与  
   <s>ステートマシンに紐づく IAM ロールに AmazonECS_FullAccess の権限を付与しておく．
   （権限が足りないと，iam:PassRole が足りないとエラーが出る．AmazonECSTaskExecutionRolePolicy だと不足？していた）．</s>

   下記のインラインポリシーを付与する．
   ```json
   {
      "Version": "2012-10-17",
      "Statement": [
         {
               "Sid": "VisualEditor0",
               "Effect": "Allow",
               "Action": [
                     "iam:PassRole",
                     "events:PutTargets",
                     "events:PutRule",
                     "events:DescribeRule"
               ],
               "Resource": "*"
         }
      ]
   }
   ```
   ログをみたいので，CloudWatchLogsFullAccess も付与しておく．


- [Step Functions から ECS Task を呼びだすときに、実行するシェルスクリプトを指定してみた](https://qiita.com/sugimount-a/items/31d03c17cc2055502fca)
- [Step Functions で ECS タスク（Fargate）を定期実行してみる](https://dev.classmethod.jp/articles/try-to-retry-ecs-tasks-using-step-functions/)


- [Fargateを利用したECSの使用方法を確認](https://www.wakuwakubank.com/posts/644-aws-fargate-ecs-basic/)


## Appendix

### StepFunctions のエラー

- ResourceInitializationError  
  IAM role の権限が足りなかったりすると発生する．まずは admin を付けて動くか確かめて，問題を切り分ける．

