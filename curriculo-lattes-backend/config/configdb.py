import mysql.connector

conexao = mysql.connector.connect(database="dbcurriculo",
                          host = "localhost",
                          user = "root",
                          password = "1234")
# print(conexao.info)
# print(conexao.status)