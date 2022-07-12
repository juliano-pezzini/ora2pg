-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, ie_valido_p text default 'S', ie_restringe_filtro_p text default 'N') RETURNS integer AS $body$
DECLARE


qt_registro_w	integer;
ds_sql		varchar(2000);

var_cur_w	integer;
var_exec_w	integer;
var_retorno_w	integer;


BEGIN

-- Obter a quantidade de registros na selecao conforme o item e a transacao passados por parametro

ds_sql := 'select	count(1) ' ||
	  'from		pls_selecao_ocor_cta a ' ||
	  'where	a.nr_id_transacao = :nr_id_transacao_p ';

if (ie_valido_p = 'S') then

	ds_sql := 	ds_sql ||
			'and		a.ie_valido = ''S'' ';
end if;

-- Se o filtro for de excecao deve ser verificado o campo nr_seq_filtro, por que os registros de execcao sao validos para a regra inteira.

-- Se o filtro nao for um filtro de excecao entao ele so podera alterar os registros dele mesmo.

if (ie_restringe_filtro_p = 'S') then

	if (dados_filtro_p.ie_excecao = 'N') then

		ds_sql := ds_sql || ' and	a.nr_seq_filtro = :nr_seq_filtro ';
	end if;
end if;

var_cur_w := dbms_sql.open_cursor;
dbms_sql.parse(var_cur_w, ds_sql, 1);

dbms_sql.bind_variable(var_cur_w, ':nr_id_transacao_p', nr_id_transacao_p);

-- Se o filtro for de excecao deve ser verificado o campo nr_seq_filtro, por que os registros de execcao sao validos para a regra inteira.

-- Se o filtro nao for um filtro de excecao entao ele so podera alterar os registros dele mesmo.

if (ie_restringe_filtro_p = 'S') then
	if (dados_filtro_p.ie_excecao = 'N') then

		dbms_sql.bind_variable(var_cur_w, ':nr_seq_filtro', dados_filtro_p.nr_sequencia);
	end if;
end if;

dbms_sql.define_column(var_cur_w, 1, qt_registro_w);
var_exec_w := dbms_sql.execute(var_cur_w);

loop
var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
exit when var_retorno_w = 0;
	-- Atualiza a variavel com o resultado do select

	dbms_sql.column_value(var_cur_w, 1, qt_registro_w);
end loop;
dbms_sql.close_cursor(var_cur_w);

return qt_registro_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_tipos_ocor_pck.obter_qtde_reg_valido_filtro ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, ie_valido_p text default 'S', ie_restringe_filtro_p text default 'N') FROM PUBLIC;