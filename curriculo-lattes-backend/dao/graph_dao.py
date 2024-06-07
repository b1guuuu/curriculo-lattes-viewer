from model.instituto import Instituto
from config.configdb import conexao

class GraphDao:
    cursor = conexao.cursor()
    
    def get_by_instituto(self, id_instituto):
        sql = f"""
            SELECT i.acronimo, i.id, ac.idTrabalho FROM instituto i 
            INNER JOIN pesquisador p ON p.idInstituto = i.id 
            INNER JOIN autor_cadastrado ac ON ac.idPesquisador = p.id 
            WHERE p.id IN (
                -- Busca todos os pesquisadores relacionados aos trabalhos recuperados
                SELECT DISTINCT(ac2.idPesquisador) from autor_cadastrado ac2 WHERE ac2.idTrabalho  IN ( 
                    -- Busca trabalhos dos pesquisadores no instituto escolhido
                    SELECT DISTINCT(ac1.idTrabalho) from autor_cadastrado ac1 WHERE ac1.idPesquisador IN (
                        -- Busca pesquisadores do instituto
                        SELECT  DISTINCT(p1.id) FROM pesquisador p1 WHERE p1.idInstituto = {id_instituto}
                    )
                )
            ) AND i.id != {id_instituto};
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado
    

    def get_by_pesquisador(self, id_pesquisador):
        sql = f"""
            -- Busca todos os pesquisadores relacionados com os trabalhos recuperados
            SELECT p.nome, ac2.idPesquisador from autor_cadastrado ac2
            INNER JOIN pesquisador p ON ac2.idPesquisador = p.id 
            WHERE ac2.idTrabalho IN ( 
                -- Busca todos os trabalhos do pesquisador
                SELECT DISTINCT (ac1.idTrabalho) from autor_cadastrado ac1 WHERE ac1.idPesquisador = '{id_pesquisador}'
            ) AND ac2.idPesquisador != '{id_pesquisador}';
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        return resultado
