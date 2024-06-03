from model.instituto import Instituto
from config.configdb import conexao

class GraphDao:
    cursor = conexao.cursor()

    def get_all(self):
        sql = """
            SELECT pesquisador.id, pesquisador.nome, instituto.id, instituto.nome, trabalho.id, trabalho.titulo
            FROM pesquisador
            INNER JOIN instituto ON instituto.id = pesquisador.idInstituto
            INNER JOIN autor_cadastrado ON pesquisador.id = autor_cadastrado.idPesquisador
            INNER JOIN trabalho ON trabalho.id = autor_cadastrado.idTrabalho
            ORDER BY trabalho.id;
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        linhas = []
        for linha in resultado:
            linhas.append({
                'pesquisador_id': linha[0],
                'pesquisador_nome': linha[1],
                'instituto_id': linha[2],
                'instituto_nome': linha[3],
                'trabalho_id': linha[4],
                'trabalho_titulo': linha[5],
            })
        return linhas

    
    def get_by_instituto(self, id_instituto):
        sql = f"""
            SELECT i.acronimo
            FROM instituto i
            WHERE id IN (
                SELECT p1.idInstituto
                FROM pesquisador p1
                WHERE p1.id IN (
                    SELECT ac1.idPesquisador
                    FROM autor_cadastrado ac1
                    WHERE ac1.idTrabalho in (
                        SELECT ac2.idTrabalho
                        FROM autor_cadastrado ac2
                        WHERE ac2.idPesquisador in (
                            SELECT p2.id
                            FROM pesquisador p2
                            WHERE p2.idInstituto = {id_instituto}
                        )
                    )
                )
            );
        """
        self.cursor.execute(sql)
        resultado = self.cursor.fetchall()
        print(resultado)
        return resultado
