from xml.dom import pulldom
import glob
import itertools


def extract(input_xml):
    # Extracts titles from XML input and writes into array
    # Start pulling; it continues automatically
    doc = pulldom.parse(input_xml)
    in_title = False
    ms_titles = []
    for event, node in doc:
        if event == pulldom.START_ELEMENT and node.localName == "title" and node.getAttribute("xml:lang") == "bg":
            in_title = True
        elif event == pulldom.END_ELEMENT and node.localName == "title":
            in_title = False
        elif event == pulldom.CHARACTERS and in_title:
            ms_titles.append(node.data)
    return ms_titles


# http://locallyoptimal.com/blog/2013/01/20/elegant-n-gram-generation-in-python/
def find_ngrams(input_list, n):
    return zip(*[input_list[i:] for i in range(n)])
    # call with: all_ngrams = [list(find_ngrams(input_list, j)) for j in range(1,len(input_list) + 1)]


# Main
# Build an array with all ngrams of content items in each ms, converted to a set
# Note: Assumes the loss of duplicate information under set conversion is not significant
# Result is a list of tuples of filename plus flattened array of ngrams
files = glob.glob('data/*.xml')
all_contents = []
for filename in files:
    input_file = open(filename, 'rb')
    file_contents = extract(input_file)
    all_ngrams = [find_ngrams(file_contents, j) for j in range(1,len(file_contents) + 1)]
    flattened = list(itertools.chain(*all_ngrams))
    all_contents.append((filename, set(flattened)))
    input_file.close()


# Generate pairwise reports with intersection count
# Result is list of counts of intersections (pairwise)
# This list be converted into a matrix in Rx
output_reports = []
for first in all_contents:
    for second in all_contents:
        output_reports.append(len(first[1] & second[1]))
output = open('output.txt', 'w')
output.write(','.join([str(i) for i in output_reports]) + '\n')
output.close()

#Output labels
output = open('labels.txt', 'w')
output.write(','.join([item[0].split('.')[0].split('/')[1] for item in all_contents]))
output.close()