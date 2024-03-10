import mysql.connector

conexao = mysql.connector.connect(database="dbcurriculo",
                          host = "localhost",
                          user = "root",
                          password = "")

# print(conexao.info)
# print(conexao.status)