import psycopg2

conexao= psycopg2.connect(database='DBcurriculo',
                          host = 'localhost',
                          user = 'postgres',
                          password= 'postgres',
                          port = '5432')

print(conexao.info)
print(conexao.status)
# mover para outro arquivo

