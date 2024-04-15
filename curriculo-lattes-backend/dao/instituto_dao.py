from model.instituto import Instituto
from config.configdb import conexao

class InstitutoDao:
    cursor = conexao.cursor()

    def mysql_result_to_object_list(self, mysql_result=[]):
        object_result = []
        for mysql_object in mysql_result:
            object_result.append(
                Instituto(mysql_object[0], mysql_object[1], mysql_object[2]))
        return object_result

    # CREATE
    def create(self, nome=None, acronimo=None):
        sql = 'INSERT INTO instituto (nome, acronimo) VALUES(%s, %s)'
        val = (nome, acronimo)
        self.cursor.execute(sql, val)
        conexao.commit()

    # READ
    def get_all(self):
        self.cursor.execute('SELECT * FROM instituto')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    # UPDATE
    def update(self, id=None, nome=None, acronimo=None):
        sql = 'UPDATE instituto SET nome=%s, acronimo=%s WHERE id='+str(id)
        val = (nome, acronimo)
        self.cursor.execute(sql, val)
        conexao.commit()

    # DELETE
    def delete(self, id):
        comando = ('DELETE FROM instituto WHERE id ='+str(id))
        self.cursor.execute(comando)
        conexao.commit()

    # FILTER
    def filter(self, nome=None, acronimo=None, orderBy=None, sort=None, posicaoInicial=1, quantidadeItens=100):
        sql = 'SELECT * FROM instituto '
        if nome != 'null' and acronimo != 'null':
            sql += "WHERE nome LIKE '%" + nome + "%' AND acronimo LIKE '%" + acronimo + "%' "
        elif nome != 'null':
            sql += "WHERE nome LIKE '%" + nome + "%' "
        elif acronimo != 'null':
            sql += "WHERE acronimo LIKE '%" + acronimo + "%' "

        if orderBy != 'null':
            sql += "ORDER BY " + orderBy + " " + sort + " "

        sql+='LIMIT ' + posicaoInicial + ', ' + quantidadeItens + ';'
        print(sql)
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    # COUNT
    def count(self, nome=None, acronimo=None):
        sql = 'SELECT COUNT(instituto.id) FROM instituto '
        if nome != 'null' and acronimo != 'null':
            sql += "WHERE nome LIKE '%" + nome + "%' AND acronimo LIKE '%" + acronimo + "%' "
        elif nome != 'null':
            sql += "WHERE nome LIKE '%" + nome + "%' "
        elif acronimo != 'null':
            sql += "WHERE acronimo LIKE '%" + acronimo + "%' "

        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado[0][0]