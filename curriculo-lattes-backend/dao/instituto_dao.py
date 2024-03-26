from config.configdb import conexao

class InstitutoDao:
    cursor = conexao.cursor()

    # CREATE
    def create(nome=None,acronimo=None):
        sql = 'INSERT INTO instituto (nome, acronimo) VALUES(%s, %s)'
        val = (nome,acronimo)
        cursor.execute(sql,val)
        conexao.commit()

    # READ
    def getAll():
        cursor.execute('SELECT * FROM instituto')
        resultado = cursor.fetchall()
        return resultado

    # UPDATE
    def update(id=None,nome=None,acronimo=None):
        sql = 'UPDATE instituto SET nome=%s, acronimo=%s WHERE id='+str(id)
        val = (nome,acronimo)
        cursor.execute(sql,val)
        conexao.commit()

    # DELETE
    def delete(id):
        comando = ('DELETE FROM instituto WHERE id ='+str(id))
        cursor.execute(comando)
        conexao.commit()

    # FILTER
    def filter(nome=None,acronimo=None,orderBy=None,sort=None):
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
