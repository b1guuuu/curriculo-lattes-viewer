from config.configdb import conexao

cursor = conexao.cursor()

def CriarPesquisador(id=None,nome=None,idIdentificador=None):
    sql = 'INSERT INTO pesquisador (id, nome, idIdentificador) VALUES(%s, %s, %s)'
    val = (id,nome,idIdentificador)
    cursor.execute(sql,val)
    conexao.commit()

# Read
def LerPesquisador():
    cursor.execute('SELECT * FROM pesquisador')
    resultado = cursor.fetchall()
    return resultado

def LerIdPesquisador():
    cursor.execute('SELECT id FROM pesquisador')
    resultado = cursor.fetchall()
    return resultado

def LerNomePesquisador():
    cursor.execute('SELECT nome FROM pesquisador')
    resultado = cursor.fetchall()
    return resultado

def LerIdInstitutoPesquisador():
    cursor.execute('SELECT idInstituto FROM pesquisador')
    resultado = cursor.fetchall()
    return resultado

# Update
def EditarPesquisador(id=None,nome=None):
    sql = 'UPDATE pesquisador SET id=%s, nome=%s WHERE id='+str(id)
    val = (id,nome)
    cursor.execute(sql,val)
    conexao.commit()

# Delete
def DeletarPesquisador(id):
    comando = ('DELETE FROM pesquisador WHERE id ='+str(id))
    cursor.execute(comando)
    conexao.commit()