from model.pesquisador import Pesquisador
from config.configdb import conexao

class PesquisadorDao:
    cursor = conexao.cursor()

    def mysql_result_to_object_list(self, mysql_result=[]):
        object_result = []
        for mysql_object in mysql_result:
            object_result.append(
                Pesquisador(mysql_object[0], mysql_object[1], mysql_object[2], mysql_object[3], mysql_object[4]))
        return object_result

    # CREATE
    def create(self,id=None,nome=None, nomeReferencia=None, idInstituto=None):
        sql = 'INSERT INTO pesquisador (id, nome, nomeReferencia, idInstituto) VALUES(%s, %s, %s, %s)'
        val = (id,nome,nomeReferencia,idInstituto)
        self.cursor.execute(sql,val)
        conexao.commit()

    # READ
    def get_all(self):
        self.cursor.execute('SELECT * FROM pesquisador')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    def get_all_id(self):
        self.cursor.execute('SELECT id FROM pesquisador')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    def get_by_nome_ou_referecia(self, nome='', nome_referencia=''):
        sql = 'SELECT * FROM pesquisador WHERE nome = %s OR nomeReferencia = %s'
        val = (nome, nome_referencia)
        self.cursor.execute(sql, val)
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    def get_all_id_instituto(self):
        self.cursor.execute('SELECT idInstituto FROM pesquisador')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    # Delete
    def delete(self, id):
        comando = ('DELETE FROM pesquisador WHERE id ='+id)
        self.cursor.execute(comando)
        conexao.commit()

    # FILTER
    def filter(self, nomePesquisador=None, nomeInstituto=None, orderBy=None, sort=None, posicaoInicial=1, quantidadeItens=100):
        sql = 'SELECT pesquisador.* FROM pesquisador '
        sql += "INNER JOIN instituto ON pesquisador.idInstituto = instituto.id "
        if nomePesquisador != 'null' and nomeInstituto != 'null':
            sql += "WHERE pesquisador.nome LIKE '%" + nomePesquisador + "%' AND instituto.nome LIKE '%" + nomeInstituto + "%' "
        elif nomePesquisador != 'null':
            sql += "WHERE pesquisador.nome LIKE '%" + nomePesquisador + "%' "
        elif nomeInstituto != 'null':
            sql += "WHERE instituto.nome LIKE '%" + nomeInstituto + "%' "
        if orderBy != 'null':
            sql += "ORDER BY " + orderBy + " " + sort + " "
        
        sql+='LIMIT ' + posicaoInicial + ', ' + quantidadeItens + ';'
        print(sql)
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    # COUNT
    def count(self, nomePesquisador=None, nomeInstituto=None):
        sql = 'SELECT COUNT(pesquisador.id) FROM pesquisador '
        sql += "INNER JOIN instituto ON pesquisador.idInstituto = instituto.id "
        if nomePesquisador != 'null' and nomeInstituto != 'null':
            sql += "WHERE pesquisador.nome LIKE '%" + nomePesquisador + "%' AND instituto.nome LIKE '%" + nomeInstituto + "%' "
        elif nomePesquisador != 'null':
            sql += "WHERE pesquisador.nome LIKE '%" + nomePesquisador + "%' "
        elif nomeInstituto != 'null':
            sql += "WHERE instituto.nome LIKE '%" + nomeInstituto + "%' "

        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado[0][0]