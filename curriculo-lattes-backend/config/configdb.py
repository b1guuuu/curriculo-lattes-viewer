import mysql.connector

conexao = mysql.connector.connect(database="dbcurriculo",
                          host = "localhost",
                          user = "igor",
                          password = "root")
# print(conexao.info)
# print(conexao.status)