# Deoploy

**GitHub連携がうまくいっていないので、直接ibmcloudにpushする**

```sh
npm run login
npm run deploy
```

```sh
bluemix login -u xxx@karappo.net -o Karappo -s prod

```

# IBM Bluemix での運用

2016.2.22 Heroku から Bluemix へ移行した。

1. Bluemixのアカウントを作成
2. CloudFoundryアプリの中から、DevOps>Delivery Pipelineを選択、無料枠で作成
3. Githubと連携するPipeline作って、pushイベントを飛ばすと、自動的にアプリが作成されるはず
4. 作成されたアプリのランタイム＞環境変数 に`HUBOT_SLACK_TOKEN`と`HUBOT_SLACK_TEAM`と`HUBOT_SLACK_BOTNAME`を設定（値は[こちら](https://karappo.slack.com/services/2605121852?updated=1)を参照）
5. うまくいかない場合はエラーが出ていないか確認（アプリ＞ログ）

↓ショートカット（リンク先の「Use Continuous Delivery to deploy this example instead?」というリンクをクリックするとパイプラインの作成へジャンプできるっぽい）
[![Deploy to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/karappo/botchan.git)


[IBM Cloud 上の botchan2 の管理画面](https://cloud.ibm.com/apps/4db32e85-f546-4cd2-8e76-5b270bd97489?paneId=overview&ace_config=%7B%22region%22%3A%22au-syd%22%2C%22crn%22%3A%22crn%3Av1%3Abluemix%3Apublic%3Acf%3Aau-syd%3As%2Ffab22cac-4465-4ad5-a098-73ba6f5edd91%3A%3Acf-application%3A4db32e85-f546-4cd2-8e76-5b270bd97489%22%2C%22resource_id%22%3A%224db32e85-f546-4cd2-8e76-5b270bd97489%22%2C%22orgGuid%22%3A%221b0a4693-d160-4362-bab8-51722dcf2ab3%22%2C%22spaceGuid%22%3A%22fab22cac-4465-4ad5-a098-73ba6f5edd91%22%2C%22redirect%22%3A%22https%3A%2F%2Fcloud.ibm.com%2Fresources%22%2C%22bluemixUIVersion%22%3A%22v6%22%7D&env_id=ibm:yp:au-syd)
