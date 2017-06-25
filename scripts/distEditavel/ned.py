#!/usr/bin/python

from sys import argv
from sys import stdin
from nltk.metrics import edit_distance
from multiprocessing import Pool

def matrizTextos(separador,arquivo):
	entrada = stdin if '-' == arquivo else open(arquivo,'r')
	resposta = [linha.split(separador) for linha in entrada]

	entrada.close()
	return resposta

def menorDistancia(texto,matriz):
	resposta = []

	for linha in matriz:
		distancia = edit_distance(texto,linha[1])

		if not resposta or resposta[1] >= distancia:
			resposta = [linha[0],distancia]
	
	return resposta

def tarefa(linha,matriz):
	resposta = menorDistancia(linha,matriz)

	if resposta: return '%s\t%s\t%s' % (linha.strip(),resposta[0],resposta[1])

	return None

# Main
argc = len(argv)

if 3 == argc:
	print edit_distance(argv[1],argv[2])

elif 4 == argc:
	matriz = matrizTextos(argv[1],argv[3])
	entrada = stdin if '-' == argv[2] else open(argv[2],'r')
	pool = Pool()
	processos = []

	for linha in entrada:
		processos.append(pool.apply_async(tarefa,[linha,matriz]))

	for it in processos:
		it = it.get()

		if it: print it
	
	entrada.close()
