-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_simult_concor_pck.atu_pls_combinacao_item_tm ( nr_seq_regra_p pls_combinacao_item_cta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


current_setting('pls_simult_concor_pck.ds_sql_w')::varchar(4000)		varchar(1000);
bind_sql_w		sql_pck.t_dado_bind;
cursor_w		sql_pck.t_cursor;
nr_seq_regra_w		pls_combinacao_item_cta.nr_sequencia%type;
nm_regra_w		pls_combinacao_item_cta.nm_regra%type;

tb_origem_proced_w	pls_util_cta_pck.t_number_table;
tb_procedimento_w	pls_util_cta_pck.t_number_table;
tb_ie_gera_ocorrencia_w	pls_util_cta_pck.t_varchar2_table_1;
tb_ie_and_or_w		pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_registro_w	pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_material_w	pls_util_cta_pck.t_number_table;
tb_ie_agrup_item_w	pls_util_cta_pck.t_varchar2_table_255;
bind_sql_valor_w	sql_pck.t_dado_bind;
-- pega tudo o que pertence a regra para gravar na tabela
C01 CURSOR(	nr_seq_regra_pc	pls_combinacao_item_cta.nr_sequencia%type) FOR
	SELECT	ie_origem_proced,
		cd_procedimento, 
		ie_gera_ocorrencia, 
		'AND' ie_and_or, 
		'P' ie_tipo_registro, 
		null nr_seq_material,
		ie_agrupamento_item
	from	table(pls_simult_concor_pck.obter_procedimentos_regra(nr_seq_regra_pc, 'AND', null, null, null))
	
union all

	SELECT	ie_origem_proced, 
		cd_procedimento, 
		ie_gera_ocorrencia, 
		'OR' ie_and_or, 
		'P' ie_tipo_registro, 
		null nr_seq_material,
		ie_agrupamento_item
	from	table(pls_simult_concor_pck.obter_procedimentos_regra(nr_seq_regra_pc, 'OR', null, null, null))
	
union all

	select  null ie_origem_proced, 
		null cd_procedimento, 
		ie_gera_ocorrencia, 
		'AND' ie_and_or, 
		'M' ie_tipo_registro, 
		nr_seq_material,
		ie_agrupamento_item
	from    table(pls_simult_concor_pck.obter_materiais_regra(nr_seq_regra_pc, 'AND', null, null, null))
	
union all

	select  null ie_origem_proced, 
		null cd_procedimento, 
		ie_gera_ocorrencia, 
		'OR' ie_and_or, 
		'M' ie_tipo_registro, 
		nr_seq_material,
		ie_agrupamento_item
	from    table(pls_simult_concor_pck.obter_materiais_regra(nr_seq_regra_pc, 'OR', null, null, null));


BEGIN

EXECUTE 'LOCK TABLE PLS_COMBINACAO_ITEM_TM IN EXCLUSIVE MODE';

-- Limpar as linhas da tabela, esta sendo usado o DELETE no lugar do TRUNCATE TABLE pois se nao a tabela sera esvaziada para 
-- todas as sessoes penduradas no Oracle.
-- se for regra especifica apaga, senao limpa tudo
if (nr_seq_regra_p IS NOT NULL AND nr_seq_regra_p::text <> '') then
	commit;
	delete /*+ PARALLEL(t,8)*/ from pls_combinacao_item_tm t where nr_seq_combinacao = nr_seq_regra_p;
else
	bind_sql_valor_w := sql_pck.executa_sql('truncate table pls_combinacao_item_tm', bind_sql_valor_w);
end if;

commit;

PERFORM set_config('pls_simult_concor_pck.ds_sql_w', 'select	a.nr_sequencia nr_seq_regra,' || pls_util_pck.enter_w ||
		'	a.nm_regra ' || pls_util_pck.enter_w ||
		'from	pls_combinacao_item_cta a' || pls_util_pck.enter_w ||
		'where	1 = 1' || pls_util_pck.enter_w, false);
		
-- se tiver regra para filtrar
if (nr_seq_regra_p IS NOT NULL AND nr_seq_regra_p::text <> '') then
	PERFORM set_config('pls_simult_concor_pck.ds_sql_w', current_setting('pls_simult_concor_pck.ds_sql_w')::varchar(4000) || 'and a.nr_sequencia = :nr_seq_regra_pc', false);
	bind_sql_w := sql_pck.bind_variable(	':nr_seq_regra_pc', nr_seq_regra_p, bind_sql_w);
else
	PERFORM set_config('pls_simult_concor_pck.ds_sql_w', current_setting('pls_simult_concor_pck.ds_sql_w')::varchar(4000) || 'and a.cd_estabelecimento = :cd_estabelecimento_pc', false);
	bind_sql_w := sql_pck.bind_variable(	':cd_estabelecimento_pc', wheb_usuario_pck.get_cd_estabelecimento, bind_sql_w);
end if;

bind_sql_w := sql_pck.executa_sql_cursor(	current_setting('pls_simult_concor_pck.ds_sql_w')::varchar(4000), bind_sql_w);
loop
	fetch	cursor_w
	into 	nr_seq_regra_w, nm_regra_w;
	EXIT WHEN NOT FOUND; /* apply on cursor_w */
	
	open C01(nr_seq_regra_w);
	loop
		--Limpa os registros das listas
		tb_origem_proced_w.delete;
		tb_procedimento_w.delete;
		tb_ie_gera_ocorrencia_w.delete;
		tb_ie_and_or_w.delete;
		tb_ie_tipo_registro_w.delete;
		tb_nr_seq_material_w.delete;
		
		-- Executa o fetch de um numero determinado de linhas.
		fetch C01 bulk collect into 	tb_origem_proced_w, tb_procedimento_w,
						tb_ie_gera_ocorrencia_w, tb_ie_and_or_w,
						tb_ie_tipo_registro_w, tb_nr_seq_material_w,
						tb_ie_agrup_item_w
		limit 7000;
		
		-- Quando o cursor nao tiver mais linhas entao sai do loop.
		exit when tb_ie_tipo_registro_w.count = 0;
					
		--insere os registros na tabela global temporaria 
		forall i in tb_ie_tipo_registro_w.first .. tb_ie_tipo_registro_w.last
			insert 	into pls_combinacao_item_tm(
				nr_sequencia, ie_tipo_registro, nr_seq_combinacao,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, ie_origem_proced, cd_procedimento,
				ie_and_or, ie_gera_ocorrencia, nr_seq_material,
				ie_agrupamento_item, nm_regra)				
			values (nextval('pls_combinacao_item_tm_seq'), tb_ie_tipo_registro_w(i), nr_seq_regra_w,
				clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, tb_origem_proced_w(i), tb_procedimento_w(i),
				tb_ie_and_or_w(i), tb_ie_gera_ocorrencia_w(i), tb_nr_seq_material_w(i),
				tb_ie_agrup_item_w(i), nm_regra_w);
			commit;
	end loop;
	close C01;
end loop;
close cursor_w;		

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_simult_concor_pck.atu_pls_combinacao_item_tm ( nr_seq_regra_p pls_combinacao_item_cta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;