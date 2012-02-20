Это пример CLI-утилиты на основе `thor` для [этой статьи](http://7vn.ru/blog/2012/02/20/thor/).

## Установка

Чтобы запустить утилиту у себя, достаточно клонировать git-репозиторий:

``` bash
$ git clone git://github.com/7even/workhorse.git
```

После чего нужно переместиться в директорию проекта, создать файл `config.yml` на основе примера в `config.yml.sample` и вписать туда свой email и пароль (по желанию можно также указать другой репозиторий на гитхабе).

``` bash
$ cd ./workhorse
$ cp config.yml.sample config.yml
# открываем config.yml и вписываем свои данные
$ bin/workhorse
```