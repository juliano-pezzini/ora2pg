-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.vincula_regra_campo_esp_item () AS $body$
DECLARE


ds_select_w		varchar(4000);
ds_restricao_w		varchar(3500);
ds_campo_w		varchar(500);
cursor_w		sql_pck.t_cursor;
bind_sql_valor_w	sql_pck.t_dado_bind;

tb_nr_seq_item_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_regra_w	pls_util_cta_pck.t_number_table;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ds_campo,
		a.cd_area_procedimento,
		a.cd_especialidade,
		a.cd_grupo_proc,
		a.cd_procedimento,
		a.ie_tipo_guia,
		a.nr_seq_prestador_exec,
		a.cd_prestador_exec,
		a.nr_seq_prestador_prot,
		a.cd_prestador_prot
	from	pls_xml_regra_campo_esp a,
		pls_regra_campo_espec_tmp b
	where 	a.nr_sequencia = b.nr_sequencia
	order by     coalesce(ie_tipo_guia,0) desc,
		     coalesce(nr_seq_prestador_exec,0) desc,
		     coalesce(nr_seq_prestador_prot,0) desc,
		     coalesce(cd_area_procedimento,0) desc,
		     coalesce(cd_especialidade,0) desc,
		     coalesce(cd_grupo_proc,0) desc,
		     coalesce(cd_procedimento,0) desc;

BEGIN

-- faz o select do item, da regra e dos campos ent_o, restringe pelo campo da regra para caso j_ tenha entrado 

--em alguma regra n_o processe novamente para respeitar a ordenacao definida pelo usu_rio (nr_seq_regra is null)

ds_campo_w := 	' select a.nr_sequencia nr_seq_item, '|| pls_util_pck.enter_w ||
			' :nr_seq_regra nr_seq_regra_conv '|| pls_util_pck.enter_w ||
		' from pls_conta_item_imp_tmp a ' || pls_util_pck.enter_w ||
		' where decode(a.nr_seq_regra, null, -1, -2) = -1 ' || pls_util_pck.enter_w;

for r_c01_w in C01 loop

	tb_nr_seq_item_w.delete;
	tb_nr_seq_regra_w.delete;
	
	-- limpa os dados da bind

	bind_sql_valor_w.delete;
	ds_restricao_w := '';

	-- atribui a sequencia da regra

	bind_sql_valor_w := sql_pck.bind_variable(':nr_seq_regra', r_c01_w.nr_sequencia, bind_sql_valor_w);

	-- monta a restricao de acordo com os dados da regra que esta sendo processada

	bind_sql_valor_w := pls_conv_xml_cta_pck.obter_rest_regra_carac_espec(	'a', r_c01_w.ds_campo, r_c01_w.cd_area_procedimento, r_c01_w.cd_especialidade, r_c01_w.cd_grupo_proc, r_c01_w.cd_procedimento, r_c01_w.ie_tipo_guia, r_c01_w.nr_seq_prestador_exec, r_c01_w.cd_prestador_exec, r_c01_w.nr_seq_prestador_prot, r_c01_w.cd_prestador_prot, bind_sql_valor_w);
	
	-- monta o select

	ds_select_w := ds_campo_w || ds_restricao_w;
	bind_sql_valor_w := sql_pck.executa_sql_cursor(ds_select_w, bind_sql_valor_w);
	
	-- atualiza a tabela tempor_ria dos itens com o numero da regra que se encaixa ao item

	loop
		fetch cursor_w bulk collect into tb_nr_seq_item_w, tb_nr_seq_regra_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_nr_seq_item_w.count = 0;
		
		forall i in tb_nr_seq_item_w.first..tb_nr_seq_item_w.last
			update	pls_conta_item_imp_tmp
			set 	nr_seq_regra = tb_nr_seq_regra_w(i)
			where 	nr_sequencia = tb_nr_seq_item_w(i);
		commit;
	end loop;
	close cursor_w;
end loop;                                               	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.vincula_regra_campo_esp_item () FROM PUBLIC;
