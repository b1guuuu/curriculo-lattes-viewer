from config.configdb import conexao

class PesquisadorDao:
    cursor = conexao.cursor()

    # CREATE
    def create(id=None,nome=None,idIdentificador=None):
        sql = 'INSERT INTO pesquisador (id, nome, idIdentificador) VALUES(%s, %s, %s)'
        val = (id,nome,idIdentificador)
        cursor.execute(sql,val)
        conexao.commit()

    # READ
    def getAll():
        cursor.execute('SELECT * FROM pesquisador')
        resultado = cursor.fetchall()
        return resultado

    def getAllId():
        cursor.execute('SELECT id FROM pesquisador')
        resultado = cursor.fetchall()
        return resultado

    def getAllName():
        cursor.execute('SELECT nome FROM pesquisador')
        resultado = cursor.fetchall()
        return resultado

    def getAllIdInstituto():
        cursor.execute('SELECT idInstituto FROM pesquisador')
        resultado = cursor.fetchall()
        return resultado

    # Update
    def update(id=None,nome=None):
        sql = 'UPDATE pesquisador SET id=%s, nome=%s WHERE id='+str(id)
        val = (id,nome)
        cursor.execute(sql,val)
        conexao.commit()

    # Delete
    def delete(id):
        comando = ('DELETE FROM pesquisador WHERE id ='+str(id))
        cursor.execute(comando)
        conexao.commit()