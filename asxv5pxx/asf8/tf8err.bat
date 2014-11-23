call ..\_path symantec
asf8 -ol tf8ext.asm
asf8 -gloaxff tf8err.asm
aslink -u tf8err tf8err tf8ext

