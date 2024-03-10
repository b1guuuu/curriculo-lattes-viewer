from config import conexao
#CRUD

cursor = conexao.cursor()

#CRUD
#Create
def Create(nome=None,acronimo=None):
    sql = 'INSERT INTO instituto (nome, acronimo) VALUES(%s, %s)'
    val = (nome,acronimo)
    cursor.execute(sql,val)
    conexao.commit()

#READ
def Read():
    cursor.execute('SELECT * FROM instituto')
    resultado = cursor.fetchall()
    return resultado

#UPDATE

#DELEAT
def Deleat(id):
    comando = ('DELETE FROM instituto WHERE id ='+str(id))
    cursor.execute(comando)
    conexao.commit()

# Create("Faculdade Miguel","FeMASS")