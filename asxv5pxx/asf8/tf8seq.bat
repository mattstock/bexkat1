call ..\_path symantec
asf8 -ol tf8ext.asm
asf8 -gloaxff tf8seq.asm
asxscn tf8seq.lst
aslink -u tf8seq tf8seq tf8ext
asxscn -i tf8seq.rst

