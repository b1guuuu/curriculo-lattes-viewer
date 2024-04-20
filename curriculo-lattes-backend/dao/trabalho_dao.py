from model.trabalho import Trabalho
from config.configdb import conexao

class TrabalhadoDao:
    cursor = conexao.cursor()

    # CRUD
    def create(self,id=None, titulo=None, ano=None, local=None, tipo=None):
        sql = 'INSERT INTO pesquisador (id, titulo, ano, local, tipo) VALUES(%s, %s, %s, %s, %s)'
        val = (id, titulo, ano, local, tipo)
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
    
    def get_local(self):
        self.cursor.execute('SELECT local FROM trabalho')
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
    def update(self,id=None, titulo=None, ano=None, local=None, tipo=None):
        sql = 'UPDATE instituto SET titulo=%s, ano=%s, local=%s, tipo=%s, WHERE id='+str(id)
        val = (id, titulo, ano, local, tipo)
        self.cursor.execute(sql, val)
        conexao.commit()