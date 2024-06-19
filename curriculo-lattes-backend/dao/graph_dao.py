from model.instituto import Instituto
from config.configdb import conexao

class GraphDao:
    cursor = conexao.cursor()
    
    def get_by_instituto(self, id_instituto, pesquisadores = [], tipo_producao=''):
        tipo_producao_filter = ''
        if tipo_producao == 'TODOS':
            tipo_producao_filter = "('ARTIGO', 'LIVRO')"
        else:
            tipo_producao_filter = f"('{tipo_producao}')"

        pesq_filter = ','.join(f"'{pesquisador}'" for pesquisador in pesquisadores)

        sql = f"""
            -- Busca todos os autores envolvidos nos trabalhos
            SELECT i.acronimo as instituto_acronimo,
                i.id as instituto_id,
                ac2.idTrabalho as trabalho_id,
                ac2.idPesquisador as pesquisador_id,
                ac2.ordem as pesquisador_ordem,
                p2.nome as pesquisador_nome
            FROM autor_cadastrado ac2
                INNER JOIN pesquisador p2 ON ac2.idPesquisador = p2.id
                INNER JOIN instituto i ON i.id = p2.idInstituto
            WHERE ac2.idTrabalho IN (
                    -- Busca Trabalhos dos pesquisadores do instituto atual
                    SELECT DISTINCT (ac1.idTrabalho)
                    FROM autor_cadastrado ac1
                        INNER JOIN trabalho t ON ac1.idTrabalho = t.id
                        INNER JOIN pesquisador p1 ON ac1.idPesquisador = p1.id
                    WHERE ac1.idPesquisador IN ({pesq_filter})
                        AND p1.idInstituto = {id_instituto}
                        AND t.tipo IN {tipo_producao_filter}
                )
                AND i.id != {id_instituto};
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado
    

    def get_by_pesquisador(self, id_pesquisador, institutos = [], tipo_producao=''):
        tipo_producao_filter = ''
        if tipo_producao == 'TODOS':
            tipo_producao_filter = "('ARTIGO', 'LIVRO')"
        else:
            tipo_producao_filter = f"('{tipo_producao}')"
        
        instituto_filter = ','.join(str(instituto) for instituto in institutos)

        sql = f"""
            -- Busca todos os pesquisadores relacionados com os trabalhos recuperados
            SELECT p.nome,
                ac2.idPesquisador
            from autor_cadastrado ac2
                INNER JOIN pesquisador p ON ac2.idPesquisador = p.id 
            WHERE ac2.idTrabalho IN ( 
                -- Busca todos os trabalhos do pesquisador
                SELECT DISTINCT (ac1.idTrabalho) 
                from autor_cadastrado ac1 
                INNER JOIN trabalho t ON t.id = ac1.idTrabalho
                WHERE ac1.idPesquisador = '{id_pesquisador}'
                AND t.tipo IN {tipo_producao_filter}
            ) AND ac2.idPesquisador != '{id_pesquisador}'
            AND p.idInstituto IN ({instituto_filter});
        """

        print('')
        print(sql)
        print('')

        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado

    def get_trabalho_relacoes(self, trabalho_id):
        sql = f"""
        SELECT p.nome, i.acronimo, p.id, i.id, ac.idTrabalho, ac.ordem FROM autor_cadastrado ac 
        INNER JOIN pesquisador p ON ac.idPesquisador = p.id 
        INNER JOIN instituto i ON p.idInstituto = i.id 
        WHERE ac.idTrabalho = {trabalho_id};
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return [{"pesquisador_nome":linha[0], "instituto_acronimo": linha[1], "pesquisador_id": linha[2], "instituto_id": linha[3], "trabalho_id": linha[4], "trabalho_ordem": linha[5]} for linha in resultado]


    def get_trabalho_relacoes_distinct_instituto(self, trabalho_id):
        sql = f"""
        SELECT DISTINCT(i.id), p.nome, i.acronimo, p.id, ac.idTrabalho, ac.ordem FROM autor_cadastrado ac 
        INNER JOIN pesquisador p ON ac.idPesquisador = p.id 
        INNER JOIN instituto i ON p.idInstituto = i.id 
        WHERE ac.idTrabalho = {trabalho_id};
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return [{"pesquisador_nome":linha[1], "instituto_acronimo": linha[2], "pesquisador_id": linha[3], "instituto_id": linha[0], "trabalho_id": linha[4], "trabalho_ordem": linha[5]} for linha in resultado]

    def get_trabalho_relacoes_distinct_pesquisador(self, trabalho_id):
        sql = f"""
        SELECT DISTINCT(p.id), p.nome, i.acronimo, i.id, ac.idTrabalho, ac.ordem FROM autor_cadastrado ac 
        INNER JOIN pesquisador p ON ac.idPesquisador = p.id 
        INNER JOIN instituto i ON p.idInstituto = i.id 
        WHERE ac.idTrabalho = {trabalho_id};
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return [{"pesquisador_nome":linha[1], "instituto_acronimo": linha[2], "pesquisador_id": linha[0], "instituto_id": linha[3], "trabalho_id": linha[4], "trabalho_ordem": linha[5]} for linha in resultado]

