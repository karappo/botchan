# Deoploy

**Githubのmasterにpush後、しばらくすると同期されます。**

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

# Deploy（GitHub連携がうまくいっていないので、直接ibmcloudにpushする）

```sh
npm run login
npm run deploy
```

# Hubot

This is a version of GitHub's Campfire bot, hubot. He's pretty cool.

This version is designed to be deployed on [Heroku][heroku]. This README was generated for you by hubot to help get you started. Definitely update and improve to talk about your own instance, how to use and deploy, what functionality he has, etc!

[heroku]: http://www.heroku.com

### Testing Hubot Locally

You can test your hubot by running the following.

    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt.

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot by typing `hubot help`.

    Hubot> hubot help

    Hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...


### Scripting

Take a look at the scripts in the `./scripts` folder for examples.
Delete any scripts you think are useless or boring.  Add whatever functionality you
want hubot to have. Read up on what you can do with hubot in the [Scripting Guide](https://github.com/github/hubot/blob/master/docs/scripting.md).

### Redis Persistence

If you are going to use the `redis-brain.coffee` script from `hubot-scripts`
(strongly suggested), you will need to add the Redis to Go addon on Heroku which requires a verified
account or you can create an account at [Redis to Go][redistogo] and manually
set the `REDISTOGO_URL` variable.

    % heroku config:set REDISTOGO_URL="..."

If you don't require any persistence feel free to remove the
`redis-brain.coffee` from `hubot-scripts.json` and you don't need to worry
about redis at all.

[redistogo]: https://redistogo.com/

## Adapters

Adapters are the interface to the service you want your hubot to run on. This
can be something like Campfire or IRC. There are a number of third party
adapters that the community have contributed. Check
[Hubot Adapters][hubot-adapters] for the available ones.

If you would like to run a non-Campfire or shell adapter you will need to add
the adapter package as a dependency to the `package.json` file in the
`dependencies` section.

Once you've added the dependency and run `npm install` to install it you can
then run hubot with the adapter.

    % bin/hubot -a <adapter>

Where `<adapter>` is the name of your adapter without the `hubot-` prefix.

[hubot-adapters]: https://github.com/github/hubot/blob/master/docs/adapters.md

## hubot-scripts

There will inevitably be functionality that everyone will want. Instead
of adding it to hubot itself, you can submit pull requests to
[hubot-scripts][hubot-scripts].

To enable scripts from the hubot-scripts package, add the script name with
extension as a double quoted string to the `hubot-scripts.json` file in this
repo.

[hubot-scripts]: https://github.com/github/hubot-scripts

## external-scripts

Tired of waiting for your script to be merged into `hubot-scripts`? Want to
maintain the repository and package yourself? Then this added functionality
maybe for you!

Hubot is now able to load scripts from third-party `npm` packages! To enable
this functionality you can follow the following steps.

1. Add the packages as dependencies into your `package.json`
2. `npm install` to make sure those packages are installed

To enable third-party scripts that you've added you will need to add the package
name as a double quoted string to the `external-scripts.json` file in this repo.

## Deployment

    % heroku create --stack cedar
    % git push heroku master
    % heroku ps:scale app=1

If your Heroku account has been verified you can run the following to enable
and add the Redis to Go addon to your app.

    % heroku addons:add redistogo:nano

If you run into any problems, checkout Heroku's [docs][heroku-node-docs].

You'll need to edit the `Procfile` to set the name of your hubot.

More detailed documentation can be found on the
[deploying hubot onto Heroku][deploy-heroku] wiki page.

### Deploying to UNIX or Windows

If you would like to deploy to either a UNIX operating system or Windows.
Please check out the [deploying hubot onto UNIX][deploy-unix] and
[deploying hubot onto Windows][deploy-windows] wiki pages.

[heroku-node-docs]: http://devcenter.heroku.com/articles/node-js
[deploy-heroku]: https://github.com/github/hubot/blob/master/docs/deploying/heroku.md
[deploy-unix]: https://github.com/github/hubot/blob/master/docs/deploying/unix.md
[deploy-windows]: https://github.com/github/hubot/blob/master/docs/deploying/unix.md

## Campfire Variables

If you are using the Campfire adapter you will need to set some environment
variables. Refer to the documentation for other adapters and the configuraiton
of those, links to the adapters can be found on [Hubot Adapters][hubot-adapters].

Create a separate Campfire user for your bot and get their token from the web
UI.

    % heroku config:set HUBOT_CAMPFIRE_TOKEN="..."

Get the numeric IDs of the rooms you want the bot to join, comma delimited. If
you want the bot to connect to `https://mysubdomain.campfirenow.com/room/42`
and `https://mysubdomain.campfirenow.com/room/1024` then you'd add it like this:

    % heroku config:set HUBOT_CAMPFIRE_ROOMS="42,1024"

Add the subdomain hubot should connect to. If you web URL looks like
`http://mysubdomain.campfirenow.com` then you'd add it like this:

    % heroku config:set HUBOT_CAMPFIRE_ACCOUNT="mysubdomain"

[hubot-adapters]: https://github.com/github/hubot/blob/master/docs/adapters.md

## Restart the bot

You may want to get comfortable with `heroku logs` and `heroku restart`
if you're having issues.
