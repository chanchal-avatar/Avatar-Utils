# Avatar

## Git Config
https://dev.to/bhupesh/using-multiple-git-user-configs-with-credentials-store-4p5

## Get image dump

* Note: cat based pull is corrupting the data
adb shell run-as me.avatar.app cat /data/user/0/me.avatar.app/test.yuv > test.yuv

* Use below script to pull the data.
pull.cmd test.yuv


wsl ip config
https://medium.com/codemonday/access-wsl-localhost-from-lan-for-mobile-testing-8635697f008