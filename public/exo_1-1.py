#%load solutions/exo_1.py
def estPremier(n):
# Écrire le code ici
    return True

def listeNombresPremiers(n):
    res = []
    for it in range(2, (n+3)**2):
        if estPremier(it):
            res.append(it)
            if len(res) == n:
                return res
