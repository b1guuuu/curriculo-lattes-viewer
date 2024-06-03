import mysql.connector

conexao = mysql.connector.connect(database="dbcurriculo",
                          host = "172.17.0.3",
                          user = "igor",
                          password = "root")
# print(conexao.info)
# print(conexao.status)