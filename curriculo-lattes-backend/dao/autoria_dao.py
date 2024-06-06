from model.instituto import Instituto
from config.configdb import conexao

class AutoriaDao:
    cursor = conexao.cursor()

    # READ
    def get_all(self):
        self.cursor.execute('SELECT * FROM autor_cadastrado')
        resultado = self.cursor.fetchall()
        autorias = []
        for linha in resultado:
            autorias.append({
                'idPesquisador': linha[0],
                'idTrabalho': linha[1],
                'ordem': linha[3]
            })
        return autorias
    # CREATE
    def create_autor_cadastrado(self, idPesquisador=None, idTrabalho=None, ordem=None):
        sql = 'INSERT INTO autor_cadastrado (idPesquisador, idTrabalho, ordem) VALUES(%s, %s, %s)'
        val = (idPesquisador, idTrabalho, ordem)
        self.cursor.execute(sql, val)
        conexao.commit()

    # CREATE
    def create_autor_nao_cadastrado(self, idTrabalho=None, ordem=None, nome=None, nomeReferencia=None):
        sql = 'INSERT INTO autor_nao_cadastrado (idTrabalho, ordem, nome, nomeReferencia) VALUES(%s, %s,%s, %s)'
        val = (idTrabalho, ordem, nome, nomeReferencia)
        self.cursor.execute(sql, val)
        conexao.commit()

    # DELETE
    def delete_autor_nao_cadastrado(self, idTrabalho=None, ordem=None):
        sql = 'DELETE FROM autor_nao_cadastrado WHERE idTrabalho=%s AND ordem=%s'
        val = (idTrabalho, ordem)
        self.cursor.execute(sql, val)
        conexao.commit()

    # DELETE
    def delete_trabalhos_pesquisador(self, idPesquisador=None):
        sql = f'DELETE FROM trabalho WHERE id in (SELECT idTrabalho FROM autor_cadastrado WHERE idPesquisador=\'{idPesquisador}\')'
        print(sql)
        self.cursor.execute(sql)
        conexao.commit()

    def get_autor_nao_cadastrado_by_nome(self, nome=None):
        sql = f'SELECT * FROM autor_nao_cadastrado WHERE nome = \'{nome}\''
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        autores = []
        for linha in resultado:
            autores.append({
                'idTrabalho': linha[0],
                'ordem': linha[1],
                'nome': linha[2],
                'nomeReferencia': linha[3]
            })
        return autores