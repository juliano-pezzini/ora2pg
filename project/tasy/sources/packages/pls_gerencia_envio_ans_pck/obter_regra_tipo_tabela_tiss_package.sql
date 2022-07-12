-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Function  utilizada para retornar o cdigo do Tipo de Tabela TISS  conforme regra da funo OPS - Monitoramento ANS



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.obter_regra_tipo_tabela_tiss ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proc_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_tipo_despesa_p pls_conta_proc.ie_tipo_despesa%type, cd_tipo_tabela_p INOUT tiss_tipo_tabela.cd_tabela_xml%type, nr_seq_regra_p INOUT pls_regra_tabela_tiss.nr_sequencia%type) AS $body$
DECLARE

cd_tipo_tabela_w	tiss_tipo_tabela.cd_tabela_xml%type;
ie_tipo_despesa_w	pls_material.ie_tipo_despesa%type;
nr_seq_regra_princ_w	pls_regra_tabela_tiss.nr_sequencia%type;


BEGIN

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then

	if (current_setting('pls_gerencia_envio_ans_pck.ie_controla_estab_w')::pls_controle_estab.ie_monitoramento_ans%type = 'S') then
		begin
			with query_tmp as (
				select 	a.cd_tabela,
					a.nr_seq_regra_princ
				from 	pls_tipo_tabela_tiss_proc_v a
				where 	a.cd_procedimento = cd_procedimento_p
				and 	a.ie_origem_proced = ie_origem_proc_p
				and	a.cd_estabelecimento = cd_estabelecimento_p
				and	exists (select	1
						from	pls_monitor_tab_ref_tiss b
						where	b.nr_seq_regra_tab_ref = a.nr_seq_regra
						and	b.ie_versao_tiss = current_setting('pls_gerencia_envio_ans_pck.cd_versao_tiss_w')::pls_monitor_tiss_lote.cd_versao_tiss%type)
				order 	by a.nr_prioridade desc
			)

			select	cd_tabela,
				nr_seq_regra_princ
			into STRICT	cd_tipo_tabela_w,
				nr_seq_regra_princ_w
			from	query_tmp LIMIT 1;
		exception
		when others then
			cd_tipo_tabela_w	:= '';
			nr_seq_regra_princ_w	:= '';
		end;
	else
		begin
			with query_tmp as (
				select 	a.cd_tabela,
					a.nr_seq_regra_princ
				from 	pls_tipo_tabela_tiss_proc_v a
				where 	a.cd_procedimento = cd_procedimento_p
				and 	a.ie_origem_proced = ie_origem_proc_p
				and	exists (select	1
						from	pls_monitor_tab_ref_tiss b
						where	b.nr_seq_regra_tab_ref = a.nr_seq_regra
						and	b.ie_versao_tiss = current_setting('pls_gerencia_envio_ans_pck.cd_versao_tiss_w')::pls_monitor_tiss_lote.cd_versao_tiss%type)
				order 	by a.nr_prioridade desc
			)

			select	cd_tabela,
				nr_seq_regra_princ
			into STRICT	cd_tipo_tabela_w,
				nr_seq_regra_princ_w
			from	query_tmp LIMIT 1;
		exception
		when others then
			cd_tipo_tabela_w	:= '';
			nr_seq_regra_princ_w	:= '';
		end;
	end if;

elsif (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	ie_tipo_despesa_w := ie_tipo_despesa_p;

	if (current_setting('pls_gerencia_envio_ans_pck.ie_controla_estab_w')::pls_controle_estab.ie_monitoramento_ans%type = 'S') then

		if (ie_tipo_despesa_w IS NOT NULL AND ie_tipo_despesa_w::text <> '') then
			select	max(ie_tipo_despesa)
			into STRICT	ie_tipo_despesa_w
			from	pls_material
			where	nr_sequencia = nr_seq_material_p
			and	cd_estabelecimento = cd_estabelecimento_p;
		end if;

		begin
		with query_tmp as (
			select 	a.cd_tabela,
				a.nr_seq_regra_princ
			from 	pls_tipo_tabela_tiss_mat_v a
			where (a.nr_seq_material = nr_seq_material_p or a.ie_tipo_despesa = ie_tipo_despesa_w )
			and	a.cd_estabelecimento = cd_estabelecimento_p
			and	exists (select	1
					from	pls_monitor_tab_ref_tiss b
					where	b.nr_seq_regra_tab_ref = a.nr_seq_regra
					and	b.ie_versao_tiss = current_setting('pls_gerencia_envio_ans_pck.cd_versao_tiss_w')::pls_monitor_tiss_lote.cd_versao_tiss%type)
			order 	by nr_prioridade desc
		)
		select	cd_tabela,
			nr_seq_regra_princ
		into STRICT	cd_tipo_tabela_w,
			nr_seq_regra_princ_w
		from	query_tmp LIMIT 1;
		exception
		when others then
			cd_tipo_tabela_w	:= '';
			nr_seq_regra_princ_w	:= '';
		end;
	else
		if (ie_tipo_despesa_w IS NOT NULL AND ie_tipo_despesa_w::text <> '') then
			select	ie_tipo_despesa
			into STRICT	ie_tipo_despesa_w
			from	pls_material
			where	nr_sequencia = nr_seq_material_p;
		end if;

		begin
		with query_tmp as (
			select 	a.cd_tabela,
				a.nr_seq_regra_princ
			from 	pls_tipo_tabela_tiss_mat_v a
			where (a.nr_seq_material = nr_seq_material_p or a.ie_tipo_despesa = ie_tipo_despesa_w )
			and	exists (select	1
					from	pls_monitor_tab_ref_tiss b
					where	b.nr_seq_regra_tab_ref = a.nr_seq_regra
					and	b.ie_versao_tiss = current_setting('pls_gerencia_envio_ans_pck.cd_versao_tiss_w')::pls_monitor_tiss_lote.cd_versao_tiss%type)
			order 	by nr_prioridade desc
		)
		select	cd_tabela,
			nr_seq_regra_princ
		into STRICT	cd_tipo_tabela_w,
			nr_seq_regra_princ_w
		from	query_tmp LIMIT 1;
		exception
		when others then
			cd_tipo_tabela_w	:= '';
			nr_seq_regra_princ_w	:= '';
		end;
	end if;
end if;

cd_tipo_tabela_p := cd_tipo_tabela_w;
nr_seq_regra_p := nr_seq_regra_princ_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.obter_regra_tipo_tabela_tiss ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proc_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_tipo_despesa_p pls_conta_proc.ie_tipo_despesa%type, cd_tipo_tabela_p INOUT tiss_tipo_tabela.cd_tabela_xml%type, nr_seq_regra_p INOUT pls_regra_tabela_tiss.nr_sequencia%type) FROM PUBLIC;