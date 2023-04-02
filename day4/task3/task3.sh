#!/bin/bash

chars=$(cat alice.txt | wc -m)
words=$(cat alice.txt | wc -w)
firstqueen=$(awk 'BEGIN {IGNORECASE = 1} /королев./ {print; exit;}' alice.txt)
# вывод всей седьмой главы, в которой находим участников чаепития
tea=$(awk '/СЕДЬМАЯ/{flag=1} /ВОСЬМАЯ/{print;flag=0}flag' alice.txt \
	  | grep -o -E "((Шляпа)|(Алиса)|(Садовая Соня)|(Заяц))" | sort | uniq)
echo "Количество букв в произведении: ${chars}"
echo "Количество слов в произведении: ${words}"
echo -e  "Первое предложение, в котором упоминается королева:\n${firstqueen}"
echo -e "Все участники чаепития:\n${tea}"

