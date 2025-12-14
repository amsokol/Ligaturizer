#!/usr/bin/bash

mkdir -p 'fonts/output/Google Sans Code'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Bold.ttf \
    --output-dir='fonts/output/Google Sans Code' \
    --prefix='' \
    --output-name='Google Sans Code'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Light.ttf \
    --output-dir='fonts/output/Google Sans Code' \
    --prefix='' \
    --output-name='Google Sans Code'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Medium.ttf \
    --output-dir='fonts/output/Google Sans Code' \
    --prefix='' \
    --output-name='Google Sans Code'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Regular.ttf \
    --output-dir='fonts/output/Google Sans Code' \
    --prefix='' \
    --output-name='Google Sans Code'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-SemiBold.ttf \
    --output-dir='fonts/output/Google Sans Code' \
    --prefix='' \
    --output-name='Google Sans Code'
