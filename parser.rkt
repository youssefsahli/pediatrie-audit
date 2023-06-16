#lang brag

cfg ::= topic+
topic ::= TOPIC title*
title ::= TITLE (line-edit-label | checkbox-label)*
line-edit-label ::= LINE-EDIT-LABEL
checkbox-label ::= CHECKBOX-LABEL
