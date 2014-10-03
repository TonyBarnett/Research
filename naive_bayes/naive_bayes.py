from collections import Counter
from collections.abc import Iterable
import re
from inflection import singularize

from mssqlDB import mssqlDB

__author__ = 'tony.barnett'

class naive_bayes:
    def __init__(self, prior):
        mssql = mssqlDB()
        self.p_word_given_class = dict()
        self.p_class_given_word = dict()

        self.word_regex = re.compile('\\b\\w+\\b')
        self.stop_words = [y for x in mssql.read_from_database('CrapDump', 'SELECT strStopWord FROM StopWord') for y in x]
        self.prior = prior


    def clean_word(self, word):
        if isinstance(word, str):
            return singularize(word.lower()) if singularize(word.lower()) not in self.stop_words else None
        elif isinstance(word, list):
            return [singularize(w.lower()) for w in word if w not in self.stop_words]
        else:
            raise ValueError()


    def train_nb(self, training_items, target_classes):
        #  Training items is value:
        vocabulary = list()
        for training_item in training_items:
            description = training_item['description']
            d = description if not isinstance(description, str) else [x for x in self.word_regex.findall(description)]
            if d:
                vocabulary += self.clean_word(d)
        total_words = len(vocabulary)

        #  Get P(w).
        probability_of_word = Counter(vocabulary)
        probability_of_word = {key: count / total_words for key, count in probability_of_word.items()}

        #  Get P(c).
        probability_of_class = 1 / len(target_classes)

        #  Count words in classes.
        number_words_in_classes = dict()
        words_in_class = dict()
        for target_class, description in target_classes.items():
            words_in_class[target_class] = [self.clean_word(x) for x in self.word_regex.findall(description)]
            number_words_in_classes[target_class] = len(words_in_class[target_class])

        #  get P(w|c)
        #  as the the number of times a word occurs in a description divided by the number of words
        #  in that description
        for clas, class_word_count in number_words_in_classes.items():
            self.p_word_given_class[clas] = dict()
            for word, word_count in Counter(words_in_class[clas]).items():
                self.p_word_given_class[clas][word] = word_count / class_word_count

        #  Apply Bayes' theorem to get P(c|w)
        #  P(w|c)P(c) / P(w)
        for word, p_word in probability_of_word.items():
            self.p_class_given_word[word] = dict()

            for clas in target_classes.keys():

                pwc = self.p_word_given_class[clas][word] * probability_of_class + self.prior \
                    if word in self.p_word_given_class[clas] \
                    else self.prior

                self.p_class_given_word[word][clas] = pwc / (p_word + self.prior)
        return


def get_probability_class(self, word, clas=None):
    if clas:
        return self.p_class_given_word[word][clas] + self.prior if word in self.p_class_given_word else self.prior

    else:
        returner = dict()
        for clas in range(1, 124):
            c = str(clas)
            returner[c] = get_probability_class(word, c)
        return returner


def get_probability_class_given_document(document, clas, training_method='bernoulli'):
    if training_method == 'bernoulli':
        pass
    elif training_method == 'multinomial':
        pass
    else:
        raise ValueError('Unknown training type {0}.'.format(training_method))
    raise NotImplementedError()


    #  item has to be a key: value pair (key: description)
def run_nb_for_item(self, source_description):
    result = dict()

    if not isinstance(source_description, Iterable):
        raise ValueError('A document must be iterable.')
    description = [x for x in self.word_regex.findall(source_description)] \
        if isinstance(source_description, str) \
        else source_description
    #  I think this is lazyness but \shrug
    #  description = [source_description] if isinstance(source_description, str) else source_description
    for c in range(1, 124):
        clas = str(c)

        result[clas] = 1

        if len(description) < 1:
            raise ValueError('A document must have a description.')

        for word in description:
            result[clas] *= get_probability_class(word, clas)
    return max(result, key=result.get)


    #  validation_items is [key: \w+, words: [], target: \d+]
def test_nb(validation_items):
    validation_results = list()

    for validation_item in validation_items:
        #  target = validation_items[validation_item]
        words = validation_item['description']
        validation_class = validation_item['target']
        class_guess = run_nb_for_item(words)

        validation_results.append(True if class_guess == str(validation_class) else False)

    return validation_results
