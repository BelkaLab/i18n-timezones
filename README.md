# i18n-timezones
Give your users a selection of supported timezones in their own language.

[Xliff](http://www.oasis-open.org/committees/xliff/documents/xliff-specification.htm) [Time Zone Database](https://www.iana.org/time-zones)'s translation tool and files, automated by the offical Unicode's [Common Locale Data Repository](http://cldr.unicode.org/) and [Google Translate API](https://cloud.google.com/translate/docs/languages) for the missing items.

![Alt text](https://img.shields.io/badge/license-MIT-green.svg?style=flat)



## Intro
You want give the users a selection of supported timezones in their own languages, and `XLIFF` is the
 format you use, then this is the repository for you.

The files are not translated manually, but they take advantage of the Unicode's Common Locale Data.
In case some item is missing, google translation API is used to give a fallback translation.
Because of this, some timezone could not have been translated correctly, although the most common
timezones and languages should have a pretty good translation thanks to the CLDR.


## Ready to use Xliff files
Under `/translations` you will find a bunch of timezone translations compiled already. The source items do not come from
   the IANA official DB, but from the latest Timezone DB Postgres has adopted.
   In the moment of writing Postgres [adopts](https://github.com/postgres/postgres/blob/REL9_6_STABLE/src/timezone/README) the latest spec IANA timezones db.
   The files will be updated whenever a new version of Postgres is on its docker [official repository](https://hub.docker.com/_/postgres/).

## Using the tool
If you want to translate it your own, or a translation is missing, you need Docker to run the whole thing, then you can take advantage
of the `run.sh`:

```bash
./run.sh <tag> [-o <outputFile>] [-k <devKey>]
```

`devKey` can be omitted if the environmental variable `DEVELOPER_KEY` is set

## Contributors
- [Matteo Bertamini](https://github.com/bertuz), Developer @[Belka](https://github.com/BelkaLab)

## License
i18n-timezones is Copyright (c) 2016 Belka, srl. It is free software, and may be redistributed under the terms specified in the LICENSE file.

## About Belka
![Alt text](http://s2.postimg.org/rcjk3hf5x/logo_rosso.jpg)

[Belka](http://belka.us/en) is a Digital Agency specialized in design, mobile applications development and custom solutions.
We love open source software! You can [see our projects](http://belka.us/en/portfolio/) or look at our case studies.

Interested? [Hire us](http://belka.us/en/contacts/) to help build your next amazing project.

[www.belka.us](http://belka.us/en)
