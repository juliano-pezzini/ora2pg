-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sql_pck.executa_sql_cursor ( ds_sql_p text, bind_sql_valor_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Recebe um comando sql e devolve um cursor pronto para receber um fetch
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
 ------------------------------------------------------------------------------------------------------------------
 usuario OS XXXXXX 01/01/2000 -
 Alteração:	Descrição da alteração.
Motivo:	Descrição do motivo.
 ------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cursor_w		sql_pck.t_cursor;
tb_bind_w		sql_pck.t_varchar2_table_bind;
ds_using_w		varchar(20000);


BEGIN
-- retorna todas as binds do comando sql e armazena nesta table
tb_bind_w := sql_pck.obter_bind_sql(ds_sql_p);
-- passa de parâmetro as binds identificadas no comando SQL e o valor das mesmas
ds_using_w := sql_pck.obter_using(tb_bind_w, bind_sql_valor_p);

-- executa o comando SQL e retorna um cursor
-- o replace no ds_sql_p em relação as aspas é para tratar as situações do comando SQL do tipo and ie_situacao = 'A'
begin
	EXECUTE 'begin open :cursor_w for ''' || replace(ds_sql_p, '''', '''''') || ''' ' || ds_using_w || '; end; ' using in out cursor_w;
	-- limpeza de memória
	tb_bind_w.delete;
	bind_sql_valor_p.delete;
	dbms_session.free_unused_user_memory;
exception
when others then
	-- Se deu erro no comando, exibe o erro desta forma:
	-- #@SQLERRM#@:
	--#@COMANDO#@.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(290584,	'SQLERRM=' || sqlerrm(SQLSTATE) || ';' ||
							'COMANDO=' || substr(ds_sql_p, 1, 4000) || ';');
end;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sql_pck.executa_sql_cursor ( ds_sql_p text, bind_sql_valor_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
