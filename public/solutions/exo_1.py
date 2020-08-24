def estPremier(n):
    for k in range(2, int(n**0.5 + 1)):
        if n % k == 0:
            return False
        
    return True

def listeNombresPremiers(n):
    res = []
    for it in range(2, (n+3)**2):
        if estPremier(it):
            res.append(it)
            if len(res) == n:
                return res
