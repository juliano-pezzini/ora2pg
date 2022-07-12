-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Procedure utilizada para gerar linhas para os tipos de despesas relativos a  tabela de procedimentos(PRocedimentos, taxas, e di_rias)



CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.gerar_linha_resumo_materiais ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_indice_update_p INOUT integer, nr_indice_insert_p INOUT integer, tb_resumo_update_p INOUT table_dados_resumo_conta, tb_resumo_insert_p INOUT table_dados_resumo_conta, ie_tipo_desp_mat_p pls_conta_mat.ie_tipo_despesa%type, ie_tipo_desp_resumo_p pls_resumo_conta.ie_tipo_despesa%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p pls_outorgante.cd_estabelecimento%type) AS $body$
DECLARE

	
vl_total_mat_w		pls_resumo_conta.vl_apresentado%type;
qt_total_mat_w		pls_resumo_conta.qt_apresentado%type;
vl_glosa_mat_w		pls_resumo_conta.vl_glosa%type;
vl_saldo_mat_w		pls_resumo_conta.vl_saldo%type;
vl_pendente_mat_w	pls_resumo_conta.vl_pendente%type;
qt_pendente_mat_w	pls_resumo_conta.qt_ocorrencia_pend%type;
vl_lib_sist_mat_w	pls_resumo_conta.vl_liberado_sistema%type;
vl_lib_usuario_mat_w	pls_resumo_conta.vl_liberado_usuario%type;
ie_tipo_operacao_w	varchar(1);
nr_sequencia_w		pls_resumo_conta.nr_sequencia%type;
tb_vazia_w		table_dados_resumo_conta;
	

BEGIN

select 	max(nr_sequencia)
into STRICT	nr_sequencia_w
from  	pls_resumo_conta
where	nr_Seq_conta 	= nr_seq_conta_p
and	ie_tipo_despesa	= ie_tipo_desp_resumo_p;

if (coalesce(nr_sequencia_w::text, '') = '') then
	ie_tipo_operacao_w := 'I';
else
	ie_tipo_operacao_w := 'A';
end if;

select	coalesce(sum(vl_material_imp),0),
	count(1),
	coalesce(sum(vl_glosa),0),
	coalesce(sum(vl_saldo),0)
into STRICT	vl_total_mat_w,
	qt_total_mat_w,
	vl_glosa_mat_w,
	vl_saldo_mat_w
from 	pls_conta_mat
where 	nr_seq_conta 	= nr_seq_conta_p
and 	ie_tipo_despesa	= ie_tipo_desp_mat_p
and	((ie_status <> 'D') or (coalesce(ie_status::text, '') = ''));

select 	coalesce(sum(vl_liberado), 0.00)
into STRICT	vl_lib_sist_mat_w
from 	pls_conta_mat
where 	nr_seq_conta 	= nr_seq_conta_p
and	ie_status    	= 'S'	
and 	ie_tipo_despesa	= ie_tipo_desp_mat_p
and	(vl_liberado IS NOT NULL AND vl_liberado::text <> '');

select 	coalesce(sum(vl_liberado), 0.00)
into STRICT	vl_lib_usuario_mat_w
from 	pls_conta_mat
where 	nr_seq_conta	= nr_seq_conta_p
and	ie_status    	= 'L'	
and 	ie_tipo_despesa = ie_tipo_desp_mat_p
and	(vl_liberado IS NOT NULL AND vl_liberado::text <> '');

select 	coalesce(sum(vl_material_imp),0),
	count(1)
into STRICT	vl_pendente_mat_w,
	qt_pendente_mat_w
from 	pls_conta_mat
where 	nr_seq_conta 	= nr_seq_conta_p
and	((ie_status    	not in ('S','L','D')) or (coalesce(ie_status::text, '') = ''))
and 	ie_tipo_despesa = ie_tipo_desp_mat_p;

--Quando j_ existir um resumo de conta para essa conta, ent_o far_ update

-- a opera__o de update _ definida pelo par_metro de entrada 'A'


if (ie_tipo_operacao_w = 'A') then
	tb_resumo_update_p.nr_seq_conta(nr_indice_update_p)		:= nr_seq_conta_p;
	tb_resumo_update_p.ie_tipo_despesa(nr_indice_update_p)		:= ie_tipo_desp_resumo_p;
	tb_resumo_update_p.vl_apresentado(nr_indice_update_p)		:= vl_total_mat_w;
	tb_resumo_update_p.qt_apresentado(nr_indice_update_p)		:= qt_total_mat_w;
	tb_resumo_update_p.vl_liberado_sistema(nr_indice_update_p)	:= vl_lib_sist_mat_w;
	tb_resumo_update_p.vl_liberado_usuario(nr_indice_update_p)	:= vl_lib_usuario_mat_w;
	tb_resumo_update_p.vl_pendente(nr_indice_update_p)		:= vl_pendente_mat_w;
	tb_resumo_update_p.vl_saldo(nr_indice_update_p)			:= vl_saldo_mat_w;
	tb_resumo_update_p.vl_glosa(nr_indice_update_p)			:= vl_glosa_mat_w;
  	tb_resumo_update_p.qt_ocorrencia_pend(nr_indice_update_p)	:= qt_pendente_mat_w;
	tb_resumo_update_p.nr_sequencia(nr_indice_update_p)		:= nr_sequencia_w;
	
	if (nr_indice_update_p >= pls_util_cta_pck.qt_registro_transacao_w) then
		CALL pls_cta_consistir_pck.atualiza_dados_resumo_conta( tb_vazia_w, tb_resumo_update_p, nm_usuario_p, cd_estabelecimento_p);
		nr_indice_update_p := 0;
		tb_resumo_update_p := pls_cta_consistir_pck.limpa_tabela_resumo(tb_resumo_update_p);
	else
		nr_indice_update_p := nr_indice_update_p + 1;
	end if;	

else
	tb_resumo_insert_p.nr_seq_conta(nr_indice_insert_p)		:= nr_seq_conta_p;
	tb_resumo_insert_p.ie_tipo_despesa(nr_indice_insert_p)		:= ie_tipo_desp_resumo_p;
	tb_resumo_insert_p.vl_apresentado(nr_indice_insert_p)		:= vl_total_mat_w;
	tb_resumo_insert_p.qt_apresentado(nr_indice_insert_p)		:= qt_total_mat_w;
	tb_resumo_insert_p.vl_liberado_sistema(nr_indice_insert_p)	:= vl_lib_sist_mat_w;
	tb_resumo_insert_p.vl_liberado_usuario(nr_indice_insert_p)	:= vl_lib_usuario_mat_w;
	tb_resumo_insert_p.vl_pendente(nr_indice_insert_p)		:= vl_pendente_mat_w;
	tb_resumo_insert_p.vl_saldo(nr_indice_insert_p)			:= vl_saldo_mat_w;
	tb_resumo_insert_p.vl_glosa(nr_indice_insert_p)			:= vl_glosa_mat_w;
	tb_resumo_insert_p.qt_ocorrencia_pend(nr_indice_insert_p)	:= qt_pendente_mat_w;
	tb_resumo_insert_p.nr_sequencia(nr_indice_insert_p)		:= null;
	
	if (nr_indice_insert_p >= pls_util_cta_pck.qt_registro_transacao_w) then
		CALL pls_cta_consistir_pck.atualiza_dados_resumo_conta( tb_resumo_insert_p, tb_vazia_w, nm_usuario_p, cd_estabelecimento_p);
		nr_indice_insert_p := 0;
		tb_resumo_insert_p := pls_cta_consistir_pck.limpa_tabela_resumo(tb_resumo_insert_p);
	else
		nr_indice_insert_p := nr_indice_insert_p + 1;
	end if;	
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.gerar_linha_resumo_materiais ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_indice_update_p INOUT integer, nr_indice_insert_p INOUT integer, tb_resumo_update_p INOUT table_dados_resumo_conta, tb_resumo_insert_p INOUT table_dados_resumo_conta, ie_tipo_desp_mat_p pls_conta_mat.ie_tipo_despesa%type, ie_tipo_desp_resumo_p pls_resumo_conta.ie_tipo_despesa%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p pls_outorgante.cd_estabelecimento%type) FROM PUBLIC;
