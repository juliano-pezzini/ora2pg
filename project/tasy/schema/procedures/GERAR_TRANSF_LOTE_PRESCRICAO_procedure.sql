-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_transf_lote_prescricao ( nr_lote_p ap_lote.nr_sequencia%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_prescricao_p prescr_material.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_material_p material.cd_material%type, cd_setor_atendimento_p setor_atendimento.cd_setor_atendimento%type, dt_atendimento_p timestamp, cd_cgc_p pessoa_juridica.cd_cgc%type, qt_material_p bigint, nr_seq_lote_fornec_p material_lote_fornec.nr_sequencia%type, cd_loc_estoque_saida_p local_estoque.cd_local_estoque%type, cd_loc_estoque_ent_p local_estoque.cd_local_estoque%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
nr_movimento_estoque_w		movimento_estoque.nr_movimento_estoque%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_operacao_transf_setor_w		parametro_estoque.cd_operacao_transf_setor%type;
ie_consignado_mat_w		material.ie_consignado%type;
cd_unidade_medida_w		material.cd_unidade_medida_consumo%type;
cd_centro_custo_w			centro_custo.cd_centro_custo%type;
cd_conta_contabil_w		conta_contabil.cd_conta_contabil%type;
ds_lote_fornec_w			material_lote_fornec.ds_lote_fornec%type;
dt_validade_w			material_lote_fornec.dt_validade%type;
cd_operacao_correspondente_w	operacao_estoque.cd_operacao_correspondente%type;
cd_local_estoque_w		local_estoque.cd_local_estoque%type;
cd_loc_estoque_saida_w		local_estoque.cd_local_estoque%type;


BEGIN 
 
begin 
 
cd_estabelecimento_w := cd_estabelecimento_p;
 
if (coalesce(cd_estabelecimento_w::text, '') = '') then 
	select	max(cd_estabelecimento) 
	into STRICT	cd_estabelecimento_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
end if;
 
select	max(cd_operacao_transf_setor) 
into STRICT	cd_operacao_transf_setor_w 
from	parametro_estoque 
where	cd_estabelecimento = cd_estabelecimento_w 
and	ie_situacao = 'A';
 
if (coalesce(nr_seq_lote_fornec_p,0) > 0) then 
	select	max(ds_lote_fornec), 
		max(dt_validade) 
	into STRICT	ds_lote_fornec_w, 
		dt_validade_w 
	from	material_lote_fornec 
	where	nr_sequencia = nr_seq_lote_fornec_p;
end if;
 
cd_local_estoque_w 	:= cd_loc_estoque_ent_p;
 
if (coalesce(cd_local_estoque_w::text, '') = '') then 
	select	cd_local_estoque 
	into STRICT	cd_local_estoque_w 
	from (SELECT	cd_local_estoque, 
			coalesce(ie_prioridade,0) ie_prioridade 
		from	setor_local 
		where	coalesce(ie_loca_estoque_pac,'N') = 'S' 
		and	cd_setor_atendimento = cd_setor_atendimento_p 
		order by coalesce(ie_prioridade,0) desc) alias5 LIMIT 1;
	 
	if (coalesce(cd_local_estoque_w::text, '') = '') then 
		select	max(cd_local_estoque) 
		into STRICT	cd_local_estoque_w 
		from	setor_atendimento 
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	end if;
end if;
 
cd_loc_estoque_saida_w	:= cd_loc_estoque_saida_p;
if (coalesce(cd_loc_estoque_saida_w::text, '') = '') then 
	select	max(cd_local_estoque) 
	into STRICT	cd_loc_estoque_saida_w 
	from	setor_atendimento 
	where	cd_setor_atendimento = cd_setor_atendimento_p;
end if;
 
CALL consiste_lote_prescr_disp(nr_lote_p, nr_prescricao_p, cd_material_p, qt_material_p, nr_seq_lote_fornec_p, 
			cd_loc_estoque_saida_w, dt_atendimento_p, cd_estabelecimento_p, cd_setor_atendimento_p, nm_usuario_p);
 
SELECT * FROM define_conta_material(	cd_estabelecimento_w, cd_material_p, 3, null, cd_setor_atendimento_p, null, null, null, null, null, cd_loc_estoque_saida_w, null, dt_atendimento_p, cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
 
/*Gerando movimentação de estoque( Saída )*/
 
select	nextval('movimento_estoque_seq') 
into STRICT	nr_movimento_estoque_w
;
 
insert into movimento_estoque( 
 	nr_movimento_estoque, 
 	cd_estabelecimento, 
 	cd_local_estoque, 
 	dt_movimento_estoque, 
 	cd_operacao_estoque, 
 	cd_acao, 
 	cd_material, 
 	dt_mesano_referencia, 
 	qt_movimento, 
 	dt_atualizacao, 
 	nm_usuario, 
 	ie_origem_documento, 
 	nr_documento, 
 	nr_sequencia_item_docto, 
 	cd_unidade_medida_estoque, 
 	cd_setor_atendimento, 
 	qt_estoque, 
	cd_centro_custo, 
 	cd_unidade_med_mov, 
	cd_fornecedor, 
	ds_observacao, 
	nr_seq_tab_orig, 
	nr_seq_lote_fornec, 
	cd_lote_fabricacao, 
	dt_validade, 
	nr_atendimento, 
	nr_prescricao, 
	nr_receita, 
	cd_conta_contabil, 
	nr_ordem_compra, 
	nr_item_oci, 
	nr_lote_ap, 
	nr_lote_producao) 
values (	nr_movimento_estoque_w, 
 	cd_estabelecimento_w, 
 	cd_loc_estoque_saida_w, 
	dt_atendimento_p, 
 	cd_operacao_transf_setor_w, 
 	1, 
	cd_material_p, 
	dt_atendimento_p, 
 	qt_material_p, 
 	clock_timestamp(), 
 	nm_usuario_p, 
 	'3', 
 	coalesce(nr_prescricao_p,nr_atendimento_p), 
 	coalesce(nr_seq_prescricao_p,999), 
 	cd_unidade_medida_w, 
 	cd_setor_atendimento_p, 
 	qt_material_p, 
	cd_centro_custo_w, 
	cd_unidade_medida_w, 
	cd_cgc_p, 
	substr(wheb_mensagem_pck.get_texto(312560),1,255), 
	0, 
	CASE WHEN nr_seq_lote_fornec_p=0 THEN  null  ELSE nr_seq_lote_fornec_p END , 
	ds_lote_fornec_w, 
	dt_validade_w, 
	nr_atendimento_p, 
	nr_prescricao_p, 
	null, 
	cd_conta_contabil_w, 
	null, 
	null, 
	CASE WHEN nr_lote_p=0 THEN  null  ELSE nr_lote_p END , 
	null);
	 
SELECT * FROM define_conta_material(	cd_estabelecimento_w, cd_material_p, 3, null, cd_setor_atendimento_p, null, null, null, null, null, cd_local_estoque_w, null, dt_atendimento_p, cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
 
select	max(cd_operacao_correspondente) 
into STRICT	cd_operacao_correspondente_w 
from	operacao_estoque 
where	cd_operacao_estoque = cd_operacao_transf_setor_w 
and	ie_situacao = 'A';
	 
/*Gerando movimentação de estoque( Entrada )*/
	 
select	nextval('movimento_estoque_seq') 
into STRICT	nr_movimento_estoque_w
;
 
insert into movimento_estoque( 
 	nr_movimento_estoque, 
 	cd_estabelecimento, 
 	cd_local_estoque, 
 	dt_movimento_estoque, 
 	cd_operacao_estoque, 
 	cd_acao, 
 	cd_material, 
 	dt_mesano_referencia, 
 	qt_movimento, 
 	dt_atualizacao, 
 	nm_usuario, 
 	ie_origem_documento, 
 	nr_documento, 
 	nr_sequencia_item_docto, 
 	cd_unidade_medida_estoque, 
 	cd_setor_atendimento, 
 	qt_estoque, 
	cd_centro_custo, 
 	cd_unidade_med_mov, 
	cd_fornecedor, 
	ds_observacao, 
	nr_seq_tab_orig, 
	nr_seq_lote_fornec, 
	cd_lote_fabricacao, 
	dt_validade, 
	nr_atendimento, 
	nr_prescricao, 
	nr_receita, 
	cd_conta_contabil, 
	nr_ordem_compra, 
	nr_item_oci, 
	nr_lote_ap, 
	nr_lote_producao) 
values (	nr_movimento_estoque_w, 
 	cd_estabelecimento_w, 
 	cd_local_estoque_w, 
	dt_atendimento_p, 
 	cd_operacao_correspondente_w, 
 	1, 
	cd_material_p, 
	dt_atendimento_p, 
 	qt_material_p, 
 	clock_timestamp(), 
 	nm_usuario_p, 
 	'3', 
 	coalesce(nr_prescricao_p,nr_atendimento_p), 
 	coalesce(nr_seq_prescricao_p,999), 
 	cd_unidade_medida_w, 
 	cd_setor_atendimento_p, 
 	qt_material_p, 
	cd_centro_custo_w, 
	cd_unidade_medida_w, 
	cd_cgc_p, 
	substr(wheb_mensagem_pck.get_texto(312560),1,255), 
	0, 
	CASE WHEN nr_seq_lote_fornec_p=0 THEN  null  ELSE nr_seq_lote_fornec_p END , 
	ds_lote_fornec_w, 
	dt_validade_w, 
	nr_atendimento_p, 
	nr_prescricao_p, 
	null, 
	cd_conta_contabil_w, 
	null, 
	null, 
	CASE WHEN nr_lote_p=0 THEN  null  ELSE nr_lote_p END , 
	null);
	 
CALL grava_log_ap_lote_hist(nr_lote_p, substr(wheb_mensagem_pck.get_texto(312560),1,255), 
	substr(wheb_mensagem_pck.get_texto(312561),1,255), nm_usuario_p);
	 
update	ap_lote 
set	cd_local_estoque = cd_local_estoque_w 
where	nr_sequencia = nr_lote_p;
 
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
 
exception 
when others then 
	CALL gravar_log_tasy(22, substr(sqlerrm,1,2000), 'Tasy');
end;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_transf_lote_prescricao ( nr_lote_p ap_lote.nr_sequencia%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_prescricao_p prescr_material.nr_sequencia%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_material_p material.cd_material%type, cd_setor_atendimento_p setor_atendimento.cd_setor_atendimento%type, dt_atendimento_p timestamp, cd_cgc_p pessoa_juridica.cd_cgc%type, qt_material_p bigint, nr_seq_lote_fornec_p material_lote_fornec.nr_sequencia%type, cd_loc_estoque_saida_p local_estoque.cd_local_estoque%type, cd_loc_estoque_ent_p local_estoque.cd_local_estoque%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
