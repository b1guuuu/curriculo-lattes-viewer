from config.configdb import conexao
#CRUD

cursor = conexao.cursor()

#CRUD
#CREATE
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
def UpdateInstituto(id=None,nome=None,acronimo=None):
    sql = 'UPDATE instituto SET nome=%s, acronimo=%s WHERE id='+str(id)
    val = (nome,acronimo)
    cursor.execute(sql,val)
    conexao.commit()

#DELETE
def DeletarInstituto(id):
    comando = ('DELETE FROM instituto WHERE id ='+str(id))
    cursor.execute(comando)
    conexao.commit()

#FILTER
def FilterInstituto(nome=None,acronimo=None,orderBy=None,sort=None):
    sql = 'SELECT * FROM instituto '
    if nome != 'null' and acronimo != 'null':
        sql += "WHERE nome LIKE '%" + nome + "%' AND acronimo LIKE '%" + acronimo +"%' "
    elif nome != 'null':
        sql += "WHERE nome LIKE '%" + nome + "%' "
    elif acronimo != 'null':
        sql += "WHERE acronimo LIKE '%" + acronimo + "%' "

    if orderBy != 'null':
        sql += "ORDER BY " + orderBy + " " + sort
        
    cursor.execute(sql)
    resultado = cursor.fetchall()
    return resultado
