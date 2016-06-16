# http://locallyoptimal.com/blog/2013/01/20/elegant-n-gram-generation-in-python/
import itertools
input_list = ['all', 'this', 'happened', 'more', 'or', 'less']

def find_ngrams(input_list, n):
  return zip(*[input_list[i:] for i in range(n)])

all_ngrams = [list(find_ngrams(input_list, j)) for j in range(1,len(input_list) + 1)]

print(all_ngrams)
print(len(all_ngrams))

# https://coderwall.com/p/rcmaea/flatten-a-list-of-lists-in-one-line-in-python
flatten = list(itertools.chain(*all_ngrams))

print(flatten)
print(len(flatten))