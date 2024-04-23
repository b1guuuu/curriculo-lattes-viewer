from model.nome_citacao import NomeCitacao
from config.configdb import conexao

class NomeCitacaoDao:
    cursor = conexao.cursor()

    def mysql_result_to_object_list(self, mysql_result=[]):
        object_result = []
        for mysql_object in mysql_result:
            object_result.append(
                NomeCitacao(mysql_object[0], mysql_object[1], mysql_object[2]))
        return object_result

    # CRUD
    def create(self, nome=None, idTrabalho=None):
        sql = 'INSERT INTO nomecitacao (nome, idTrabalho) VALUES(%s, %s)'
        val = (nome, idTrabalho)
        self.cursor.execute(sql,val)
        conexao.commit()

    def get_by_idTrabalho(self, idTrabalho=None):
        sql = 'SELECT * FROM nomecitacao WHERE idTrabalho='+str(idTrabalho)
        resultado = self.cursor.execute(sql)
        return self.mysql_result_to_object_list(resultado)
    