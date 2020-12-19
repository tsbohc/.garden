from PIL import Image

# NOTES
# 2b ⣿⣿ = perfect square
# this means that the image will be 1x high and 2x wide
#
# 2b is a block of 4x4 pixels
#
# unicode braille contains all 256 possible patterns
# empty?

def symbol(binary_code):
    if binary_code == '00000000':
        return ' '
    return chr(10240 + int(binary_code, 2))

def convert(fname, swidth, boffset, inv):
    image = Image.open(fname).convert('L')

    W, H = image.size[0], image.size[1]

    # because it's set with symbols and braille is 2px wide
    swidth = swidth * 2

    wpercent = swidth/W
    sheight = int(H * wpercent)
    image = image.resize((swidth, sheight))

    W, H = image.size[0], image.size[1]

    W = int(W/2) * 2
    H = int(H/4) * 4

    pixels = list(image.getdata())
    average = int(sum(pixels) / len(pixels))

    # {{{
    order = {
        1: { 'x': 0, 'y': 0 },
        2: { 'x': 0, 'y': 1 },
        3: { 'x': 0, 'y': 2 },
        4: { 'x': 1, 'y': 0 },
        5: { 'x': 1, 'y': 1 },
        6: { 'x': 1, 'y': 2 },
        7: { 'x': 0, 'y': 3 },
        8: { 'x': 1, 'y': 3 }
    }
    # }}}

    for ty in range(0, H, 4):
        for tx in range(0, W, 2):

            braille = ''

            for i in order:
                x = tx + order[i]['x']
                y = ty + order[i]['y']
                l = pixels[W*y+x]
                if l >= average + boffset:
                    braille += str(inv)
                else:
                    if inv == 1:
                        braille += '0'
                    else:
                        braille += '1'
            braille = braille[::-1]

            print(symbol(braille), end='')
        print('')


convert('phos1.jpg', 29, 40, 1)


