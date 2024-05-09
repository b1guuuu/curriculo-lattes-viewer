from model.trabalho import Trabalho
from model.nome_citacao import NomeCitacao
from config.configdb import conexao

class TrabalhoDao:
    cursor = conexao.cursor()

    def mysql_result_to_object_list(self, mysql_result=[]):
        object_result = []
        for mysql_object in mysql_result:
            object_result.append(
                Trabalho(mysql_object[0], mysql_object[1], mysql_object[2], mysql_object[3], mysql_object[4]))
        return object_result

    # CRUD
    def create(self, titulo=None, ano=None, tipo=None, idPesquisador=None):
        sql = 'INSERT INTO trabalho (titulo, ano, tipo, idPesquisador) VALUES (%s, %s, %s, %s);'
        val = (titulo, ano, tipo, idPesquisador)
        self.cursor.execute(sql,val)
        conexao.commit()

    # Read
    def get_all(self):
        self.cursor.execute('SELECT * FROM trabalho')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)
    
    def get_id(self):
        self.cursor.execute('SELECT id FROM trabalho')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    def get_titulo(self):
        self.cursor.execute('SELECT titulo FROM trabalho')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)
    
    def get_ano(self):
        self.cursor.execute('SELECT ano FROM trabalho')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)
    
    def get_tipo(self):
        self.cursor.execute('SELECT tipo FROM trabalho')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)
    
    # Delete
    def delete(self, id):
        comando = ('DELETE FROM trabalho WHERE id ='+str(id))
        self.cursor.execute(comando)
        conexao.commit()

    # UPDATE
    def update(self,id=None, titulo=None, ano=None, tipo=None):
        sql = 'UPDATE trabalho SET titulo=%s, ano=%d, tipo=%s WHERE id='+str(id)
        val = (titulo, ano, tipo)
        self.cursor.execute(sql, val)
        conexao.commit()

    def get_last_inserted_id(self):
        return self.cursor.lastrowid

     # FILTER
    def filter(self, ano_inicio=None, ano_fim=None, id_instituto=None, id_pesquisador=None, tipo=None, orderBy=None, sort=None, posicaoInicial=1, quantidadeItens=100):
        sql = 'SELECT trabalho.id, trabalho.titulo, trabalho.ano, trabalho.tipo, trabalho.idPesquisador, nomecitacao.id, nomecitacao.nome, nomecitacao.idTrabalho FROM trabalho '
        sql += 'LEFT JOIN nomecitacao ON trabalho.id=nomecitacao.idTrabalho '
        
        filtros = []
        if ano_inicio != 'null':
            filtros.append('trabalho.ano >= ' + str(ano_inicio))
        if ano_fim != 'null':
            filtros.append('trabalho.ano <= ' + str(ano_fim))
        if id_instituto != 'null':
            sql += 'INNER JOIN pesquisador ON trabalho.idPesquisador=pesquisador.id '
            filtros.append("pesquisador.idInstituto = " + str(id_instituto))
        if id_pesquisador != 'null':
            filtros.append("trabalho.idPesquisador = '" + id_pesquisador + "'")
        if tipo != 'null':
            filtros.append("trabalho.tipo = '" + tipo + "'")

        if len(filtros) > 0:
            sql += 'WHERE ' + ' AND '.join(filtros) + ' '
        if orderBy != 'null':
            sql += "ORDER BY " + orderBy + " " + sort + " "

        sql+='LIMIT ' + posicaoInicial + ', ' + quantidadeItens + ';'
        print(sql)
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()

        ultimo_id = -1
        trabalhos_com_nomes = []
        trabalho = None

        for linha in resultado:
            if linha[0] != ultimo_id:
                if ultimo_id != -1:
                    trabalhos_com_nomes.append(trabalho)
                ultimo_id = linha[0]
                trabalho = {
                    'id': linha[0],
                    'titulo': linha[1],
                    'ano': linha[2],
                    'tipo': linha[3],
                    'idPesquisador': linha[4],
                    'nomes': []
                }
            trabalho['nomes'].append({
                'id': linha[5],
                'nome': linha[6],
                'idTrabalho': linha[7]
            })
        return trabalhos_com_nomes

    # COUNT
    def count(self, ano_inicio=None, ano_fim=None, id_instituto=None, id_pesquisador=None, tipo=None):
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