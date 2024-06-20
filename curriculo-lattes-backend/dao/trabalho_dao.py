from model.trabalho import Trabalho
from config.configdb import conexao

class TrabalhoDao:
    cursor = conexao.cursor()

    def mysql_result_to_object_list(self, mysql_result=[]):
        object_result = []
        for mysql_object in mysql_result:
            object_result.append(
                Trabalho(mysql_object[0], mysql_object[1], mysql_object[2], mysql_object[3]))
        return object_result

    # CRUD
    def create(self, titulo=None, ano=None, tipo=None):
        sql = 'INSERT INTO trabalho (titulo, ano, tipo) VALUES (%s, %s, %s);'
        val = (titulo, ano, tipo)
        self.cursor.execute(sql,val)
        conexao.commit()

    # Read
    def get_all(self):
        self.cursor.execute('SELECT * FROM trabalho')
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)

    def get_by_pesquisadores_institutos_tipo(self, pesquisadores=[], institutos=[], tipo_producao=''):
        pesquisadores_ids = ','.join(f"'{pesquisador}'" for pesquisador in pesquisadores)
        institutos_ids = ','.join(str(instituto) for instituto in institutos)
        tipo_producao_filter = ''
        if tipo_producao == 'TODOS':
            tipo_producao_filter = "('ARTIGO', 'LIVRO')"
        else:
            tipo_producao_filter = f"('{tipo_producao}')"

        sql = f"""
            SELECT DISTINCT(t.id), t.titulo, t.ano, t.tipo FROM trabalho t
            INNER JOIN autor_cadastrado ac ON ac.idTrabalho = t.id 
            INNER JOIN pesquisador p ON ac.idPesquisador = p.id 
            WHERE t.tipo IN {tipo_producao_filter}
                AND p.id IN ({pesquisadores_ids})
                AND p.idInstituto  IN ({institutos_ids})
        """

        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)
    

    def get_pesquisadores_id(self, id_trabalho=None):
        self.cursor.execute(f'SELECT DISTINCT(ac.idPesquisador) FROM autor_cadastrado ac WHERE ac.idTrabalho = {id_trabalho}')
        resultado = self.cursor.fetchall()
        return resultado[0]

    def get_institutos_id(self, id_trabalho=None):
        sql = f"""
        SELECT DISTINCT (p.idInstituto) FROM pesquisador p 
        INNER JOIN autor_cadastrado ac ON ac.idPesquisador = p.id 
        WHERE ac.idTrabalho = {id_trabalho};
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado[0]

    def get_by_columns(self, titulo=None, ano=None, tipo=None):
        sql = 'SELECT * FROM trabalho WHERE titulo=%s AND ano=%s AND tipo=%s'
        val = (titulo, ano, tipo)
        self.cursor.execute(sql, val)
        resultado = self.cursor.fetchall()
        return self.mysql_result_to_object_list(resultado)
    
    def get_last_inserted_id(self):
        return self.cursor.lastrowid

    def filter(self, ano_inicio=None, ano_fim=None, id_instituto=None, id_pesquisador=None, tipo=None, orderBy=None, sort=None, posicaoInicial=1, quantidadeItens=100):
        sql = 'SELECT trabalho.* FROM trabalho '

        filtros = []
        if ano_inicio != 'null':
            filtros.append('trabalho.ano >= ' + str(ano_inicio))
        if ano_fim != 'null':
            filtros.append('trabalho.ano <= ' + str(ano_fim))
        if id_instituto != 'null':
            sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
            sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append("pesquisador.idInstituto = " + str(id_instituto))
        if id_pesquisador != 'null':
            if 'INNER JOIN' not in sql:
                sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
                sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append("pesquisador.id = '" + id_pesquisador + "'")
        if tipo != 'null':
            filtros.append("trabalho.tipo = '" + tipo + "'")

        if len(filtros) > 0:
            sql += 'WHERE ' + ' AND '.join(filtros) + ' '
        if orderBy != 'null':
            sql += "ORDER BY " + orderBy + " " + sort + " "

        sql+='LIMIT ' + posicaoInicial + ', ' + quantidadeItens + ';'
        self.cursor.execute(sql)
        trabalhos = self.cursor.fetchall()
        ids_str = '('

        for linha in trabalhos:
            ids_str += str(linha[0]) + ','
        ids_str += str(linha[0]) + ')'
        sql = f"""
            SELECT
                autor_nao_cadastrado.idTrabalho,
                autor_nao_cadastrado.nomeReferencia
            FROM
                autor_nao_cadastrado
            WHERE
                autor_nao_cadastrado.idTrabalho in {ids_str}
            UNION
            SELECT
                autor_cadastrado.idTrabalho,
                pesquisador.nomeReferencia
            FROM
                autor_cadastrado
            INNER JOIN pesquisador ON
                autor_cadastrado.idPesquisador = pesquisador.id
            WHERE
                autor_cadastrado.idTrabalho in {ids_str};
        """
        
        self.cursor.execute(sql)
        nomes = self.cursor.fetchall()
        trabalhos_com_nomes = []

        for linha in trabalhos:
            trabalho = {
                    'id': linha[0],
                    'titulo': linha[1],
                    'ano': linha[2],
                    'tipo': linha[3],
                    'nomes': []
                }
            for nome in nomes:
                if nome[0] == trabalho['id']:
                    trabalho['nomes'].append(nome[1])
            trabalhos_com_nomes.append(trabalho)

        return trabalhos_com_nomes

     # FILTER
    

    def filter_atualizado(self, ano_inicio=None, ano_fim=None, institutos=None, pesquisadores=None, tipo=None, orderBy=None, sort=None, posicaoInicial=1, quantidadeItens=100):
        sql = 'SELECT trabalho.* FROM trabalho '

        filtros = []
        if ano_inicio != 'null':
            filtros.append('trabalho.ano >= ' + str(ano_inicio))
        if ano_fim != 'null':
            filtros.append('trabalho.ano <= ' + str(ano_fim))
        if institutos != 'null':
            sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
            sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append(f"pesquisador.idInstituto IN ({institutos})")
        if pesquisadores != 'null':
            if 'INNER JOIN' not in sql:
                sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
                sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append(f"pesquisador.id IN ({pesquisadores})")
        if tipo != 'null':
            filtros.append(f"trabalho.tipo IN {tipo}")

        if len(filtros) > 0:
            sql += 'WHERE ' + ' AND '.join(filtros) + ' '
        if orderBy != 'null':
            sql += "ORDER BY " + orderBy + " " + sort + " "

        sql+='LIMIT ' + posicaoInicial + ', ' + quantidadeItens + ';'
        print('\n')
        print(sql)
        print('\n')
        
        self.cursor.execute(sql)
        trabalhos = self.cursor.fetchall()
        ids_str = '('

        for linha in trabalhos:
            ids_str += str(linha[0]) + ','
        ids_str += str(linha[0]) + ')'
        sql = f"""
            SELECT
                autor_nao_cadastrado.idTrabalho,
                autor_nao_cadastrado.nomeReferencia
            FROM
                autor_nao_cadastrado
            WHERE
                autor_nao_cadastrado.idTrabalho in {ids_str}
            UNION
            SELECT
                autor_cadastrado.idTrabalho,
                pesquisador.nomeReferencia
            FROM
                autor_cadastrado
            INNER JOIN pesquisador ON
                autor_cadastrado.idPesquisador = pesquisador.id
            WHERE
                autor_cadastrado.idTrabalho in {ids_str};
        """
        
        print('\n')
        print(sql)
        print('\n')
        self.cursor.execute(sql)
        nomes = self.cursor.fetchall()
        trabalhos_com_nomes = []

        for linha in trabalhos:
            trabalho = {
                    'id': linha[0],
                    'titulo': linha[1],
                    'ano': linha[2],
                    'tipo': linha[3],
                    'nomes': []
                }
            for nome in nomes:
                if nome[0] == trabalho['id']:
                    trabalho['nomes'].append(nome[1])
            trabalhos_com_nomes.append(trabalho)

        return trabalhos_com_nomes

     # FILTER
    

    # COUNT
    def count(self, ano_inicio=None, ano_fim=None, id_instituto=None, id_pesquisador=None, tipo=None):
        sql = 'SELECT COUNT(trabalho.id) FROM trabalho ' 

        filtros = []
        if ano_inicio != 'null':
            filtros.append('trabalho.ano >= ' + str(ano_inicio))
        if ano_fim != 'null':
            filtros.append('trabalho.ano <= ' + str(ano_fim))
        if id_instituto != 'null':
            sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
            sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append("pesquisador.idInstituto = " + str(id_instituto))
        if id_pesquisador != 'null':
            if 'INNER JOIN' not in sql:
                sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
                sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append("pesquisador.id = '" + id_pesquisador + "'")
        if tipo != 'null':
            filtros.append("trabalho.tipo = '" + tipo + "'")

        if len(filtros) > 0:
            sql += 'WHERE ' + ' AND '.join(filtros) + ' '

        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado[0][0]


    # COUNT
    def count_atualizado(self, ano_inicio=None, ano_fim=None, institutos=None, pesquisadores=None, tipo=None):
        sql = 'SELECT COUNT(trabalho.id) FROM trabalho ' 

        filtros = []
        if ano_inicio != 'null':
            filtros.append('trabalho.ano >= ' + str(ano_inicio))
        if ano_fim != 'null':
            filtros.append('trabalho.ano <= ' + str(ano_fim))
        if institutos != 'null':
            sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
            sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append(f"pesquisador.idInstituto IN ({institutos})")
        if pesquisadores != 'null':
            if 'INNER JOIN' not in sql:
                sql += 'INNER JOIN autor_cadastrado ON autor_cadastrado.idTrabalho=trabalho.id '
                sql += 'INNER JOIN pesquisador ON autor_cadastrado.idPesquisador=pesquisador.id '
            filtros.append(f"pesquisador.id IN ({pesquisadores})")
        if tipo != 'null':
            filtros.append(f"trabalho.tipo IN {tipo}")

        if len(filtros) > 0:
            sql += 'WHERE ' + ' AND '.join(filtros) + ' '

        print('\n')
        print(sql)
        print('\n')
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado[0][0]
