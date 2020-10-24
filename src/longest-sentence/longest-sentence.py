import nltk
nltk.download('punkt')
from nltk.tokenize import sent_tokenize
import rusyllab

with open('data', 'r') as f:
    data = f.read().replace('\n', '. ').replace('.. ', '. ')
    sentences = sent_tokenize(data)

parsed = []

total_sentences = 0
total_words = 0
total_syllables = 0

for s in sentences:
    if len(s) > 14 and not '/' in s:
        words = len(s.split())

        total_words += words
        total_sentences += 1

        syl = rusyllab.split_words(s.split())
        syl = list(filter(lambda a: a != ' ', syl))
        syl = list(filter(lambda a: a != '.', syl))
        total_syllables += len(syl)

        r = 206.835 - 1.52 * words - 65.14 * len(syl) / words

        parsed.append({
            'data': s,
            'characters': len(s),
            'words': words,
            'r': r
        })

parsed=sorted(parsed, key=lambda i: (-i["characters"], i["r"]))

print('sent ' + str(total_sentences))
print('word ' + str(total_words))
print('syll ' + str(total_syllables))

r = 206.835 - 1.52 * total_words / total_sentences - 65.14 * total_syllables / total_words
print(r)

print()

for i in parsed:
    print('ra: ' + str(i['r']).split('.')[0] + '\t ch:' + str(i['characters']) + '\t wo:' + str(i['words']))
    print(i['data'])
    print()


