from config import conexao
#CRUD

cursor = conexao.cursor()

#CRUD
#Create
def CreateInstituto(nome=None,acronimo=None):
    sql = 'INSERT INTO instituto (nome, acronimo) VALUES(%s, %s)'
    val = (nome,acronimo)
    cursor.execute(sql,val)
    conexao.commit()

#READ
def BuscarInstituto():
    cursor.execute('SELECT * FROM instituto')
    resultado = cursor.fetchall()
    return resultado

#UPDATE

#DELEAT
def DeletarInstituto(id):
    comando = ('DELETE FROM instituto WHERE id ='+str(id))
    cursor.execute(comando)
    conexao.commit()

