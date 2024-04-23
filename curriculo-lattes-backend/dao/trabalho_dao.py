from model.trabalho import Trabalho
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