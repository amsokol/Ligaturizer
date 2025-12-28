#!/bin/bash

mkdir -p 'fonts/output/GoogleSansCodeRadon'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Bold.ttf \
    --output-dir='fonts/output/GoogleSansCodeRadon' \
    --prefix='' \
    --output-name='Google Sans Code Radon'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Light.ttf \
    --output-dir='fonts/output/GoogleSansCodeRadon' \
    --prefix='' \
    --output-name='Google Sans Code Radon'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Medium.ttf \
    --output-dir='fonts/output/GoogleSansCodeRadon' \
    --prefix='' \
    --output-name='Google Sans Code Radon'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-Regular.ttf \
    --output-dir='fonts/output/GoogleSansCodeRadon' \
    --prefix='' \
    --output-name='Google Sans Code Radon'

fontforge -lang py -script ligaturize.py fonts/GoogleSansCodeFrozenSS01/GoogleSansCode-SemiBold.ttf \
    --output-dir='fonts/output/GoogleSansCodeRadon' \
    --prefix='' \
    --output-name='Google Sans Code Radon'
