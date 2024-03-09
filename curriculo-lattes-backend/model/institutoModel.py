from config import * 
#CRUD

cursor = conexao.cursor()

#CRUD
#Create
def Create(nome,acronimo):
    comando = f'INCERT INTO instituto (nome, acronimo)
    VALUES ({nome},{acronimo})'
    cursor.execute(comando)
    conexao.commit()

#READ
def Read():
    comando = 'SELECT * FROM instituto'
    resultado = cursor.fetchall()
    return resultado

#UPDATE

#DELEAT
def Deleat(nome):
    comando = f'DELETE FROM instituto WHERE nome = "{nome}"'
    cursor.execute(comando)
    conexao.commit()