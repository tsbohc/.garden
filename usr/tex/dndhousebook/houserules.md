#HOUSE RULES

## foreword

D&D -- не видеоигра. Здесь можно поднять с земли песок и бросить его кому-то в глаза. Использовать мешок с мукой чтобы обнаружить что-то невидимое. Подсыпать снотворное кому-нибудь в эль. Разлить на полу масло, чтобы сделать поверхность скользкой.

Как DM, я черпаю вдохновение из поджанра фэнтези Sword&Sorcery. Мне нравится исследовать темы личной драмы героев в рамках сырых стен самых темных подземелий.

## ability scores

1. 3d10, записываем наибольший ролл, повторяем 6 раз
2. распределяем [6 5 4 3 2 1], по 1 значению на стат

```
W: [highest 1 of 3d10]
output W named "prep"

ABILITIES: 6 d (W)
loop A over {1..6} {
    output (A @ ABILITIES + (7 - A)) named "Ability [A]"
}

output ABILITIES + 21 named "total"
```

Total scores average at 68.85, ranging from 59 to 78 within >1% probability. This is an overall power decrease of 6.28% compared to 4d6 drop the lowest, which averages at 73.47, ranging from 61 to 86 within >1% probability. Also, the variablity between characters is reduced by 4 points, ensuring more consistent group.

Estimated distribution:

1. 16 85% | 15 13% | 14  2%
2. 15 51% | 14 36% | 13 10%
3. 13 42% | 12 26% | 14 20%
4. 11 34% | 12 27% | 19 22%
5.  9 28% | 10 23% |  8 22%
6.  6 22% |  7 21% |  5 17%

Rolls are capped at 16 to accomodate for racials without introducing stat caps. Hitting 85% with a +2 racial allows one to hit 20 in a score on level 4. On the other hand, flaws are more prevalent, ranging from 2-3 on average.

Such distribution should help separate players by areas of expertise and let each one have their time under the spotlight.

## critical damage
При выпадении натуральной 20, урон равен: бросок урона + максимальный урон броска урона.

## rule of cool

Иногда, DM готов закрыть глаза на незначительное нарушение правил или законов физики, если это способствует крутому моменту в игре. Иногда.

Я всегда оценю хорошую шутку, в персонаже или нет.

## descriptive combat

В бою, игрок может сказать:

> Я бью его своей булавой.

И DM ответит:

> Ты попал, и наносишь 7 урона.

Или, игрок может дать более подробное описание своего действия:

> Я делаю шаг в сторону и бью его своей булавой, целясь в голову.

> Твоя булава попадает в его шлем и раздается звонкий гул. Оглушенный, он едва удерживается на ногах. Ты наносишь 7 урона.

Такие проявления креативности приветствуются и будут поощряться.

## alignment

За моим столом, это способ объяснить свои действия, а не их характеризация. Плохие герои могут совершать хорошие поступки, пускай и из своих корыстных побуждений.

Рассмотрим пример с Робин Гудом:

<table>
<tr>
<td></td>
<td align="center"><b>lawful</b></td>
<td align="center"><b>chaotic</b></td>
</tr>
<tr>
</tr>
<tr>
<td align="center"><b>good</b></td>
<td>Я верен истинному королю, поэтому помогаю его людям и противостою ложному королю.</td>
<td>Я ворую золото у богатых и отдаю его бедным, потому что они более несчастны.</td>
</tr>
<tr>
</tr>
<tr>
<td align="center"><b>evil</b></td>
<td>Я хочу отомстить нынешнему королю, и верен коду разбойников.</td>
<td>Я отдаю золото бедным чтобы усугубить отношения между королем и людьми, что приведет к народному восстанию.</td>
</tr>
</table>

Полная характеризация:

<table>
<tr>
<td></td>
<td align="center"><b>lawful</b><br>принцип</td>
<td align="center"><b>neutral</b><br>нужда</td>
<td align="center"><b>chaotic</b><br>импульс</td>
</tr>
<tr>
</tr>
<tr>
<td align="center"><b>good</b><br>творить добро</td>
<td>служит порядку, поступает правильно</td>
<td>не заитересован в порядке или хаосе, поступает правильно</td>
<td>сомневается в порядке, поступает правильно</td>
</tr>
<tr>
</tr>
<tr>
<td align="center"><b>neutral</b><br>не вмешиваться</td>
<td>верит в порядок, не вмешивается</td>
<td>не верит в порядок или хаос, не вмешивается</td>
<td>не верит в порядок, не вмешивается</td>
</tr>
<tr>
</tr>
<tr>
<td align="center"><b>evil</b><br>творить зло</td>
<td>хочет чтобы порядок служил ему, творит зло</td>
<td>не задумывается о порядке или хаосе, творит зло чтобы достичь своих целей</td>
<td>противостоит порядку, творит зло без причины</td>
</tr>
</table>
