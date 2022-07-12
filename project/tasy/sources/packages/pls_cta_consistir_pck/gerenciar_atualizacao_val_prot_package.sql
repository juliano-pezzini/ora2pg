-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Obtem novos valores para posterior atualiza__o dos mesmos nos protocolos



CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.gerenciar_atualizacao_val_prot ( tb_protocolos_p dbms_sql.number_table, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE
					

vl_cobrado_w			pls_protocolo_conta.vl_cobrado%type;
vl_coparticipacao_w		pls_protocolo_conta.vl_coparticipacao%type;
vl_total_w			pls_protocolo_conta.vl_contabil%type;
vl_total_imp_w			pls_protocolo_conta.vl_total_imp%type;
vl_glosa_w			pls_protocolo_conta.vl_glosa%type;
vl_total_beneficiario_w		pls_protocolo_conta.vl_total_beneficiario%type;
vl_contabil_w			pls_protocolo_conta.vl_contabil%type;
vl_proc_pendente_w		pls_protocolo_conta.vl_pendente%type;
vl_mat_pendente_w		pls_protocolo_conta.vl_pendente%type;
vl_pendente_w			pls_protocolo_conta.vl_pendente%type;
vl_proc_liberado_w		pls_protocolo_conta.vl_lib_sistema%type;
vl_mat_liberado_w		pls_protocolo_conta.vl_lib_sistema%type;
vl_liberado_w			pls_protocolo_conta.vl_lib_sistema%type;
vl_proc_lib_usuario_w		pls_protocolo_conta.vl_lib_usuario%type;
vl_mat_lib_usuario_w		pls_protocolo_conta.vl_lib_usuario%type;
vl_liberado_usuario_w		pls_protocolo_conta.vl_lib_usuario%type;
qt_procedimento_w		pls_protocolo_conta.qt_ocorrencias%type;
qt_material_w			pls_protocolo_conta.qt_ocorrencias%type;
qt_ocorrencia_w			pls_protocolo_conta.qt_ocorrencias%type;
vl_apresentado_proc_w		pls_protocolo_conta.vl_cobrado%type;
vl_apresentado_mat_w		pls_protocolo_conta.vl_cobrado%type;
nr_indexador_w			integer;
nr_indice_dados_w		integer;
tb_protocolos_dados_w		table_dados_protocolo;
					

BEGIN

nr_indice_dados_w := 0;
-- Se realmente tiver registros

if (tb_protocolos_p.count > 0) then
	
	nr_indexador_w	:= tb_protocolos_p.first;
	while(nr_indexador_w IS NOT NULL AND nr_indexador_w::text <> '') loop
	
		--Obter os valores das contas 

		select	coalesce(sum(a.vl_total),0),
			coalesce(sum(a.vl_total_imp),0),
			coalesce(sum(a.vl_glosa),0),
			coalesce(sum(a.vl_total_beneficiario),0),
			coalesce(sum(b.vl_coparticipacao),0)
		into STRICT	vl_total_w,
			vl_total_imp_w,
			vl_glosa_w,
			vl_total_beneficiario_w,
			vl_coparticipacao_w			
		FROM pls_conta a
LEFT OUTER JOIN pls_conta_coparticipacao b ON (a.nr_sequencia = b.nr_seq_conta)
WHERE a.nr_seq_protocolo	= tb_protocolos_p(nr_indexador_w);
		
		--Valores dos procedimentos 

		select	sum(vl_apresentado),
			sum(vl_pendente),
			sum(vl_lib_sistema),
			sum(vl_lib_usuario),
			sum(qt_procedimento)
		into STRICT	vl_apresentado_proc_w,
			vl_proc_pendente_w,
			vl_proc_liberado_w,
			vl_proc_lib_usuario_w,
			qt_procedimento_w
		from	(
			SELECT	CASE  ELSE 'D', 0, a.vl_procedimento_imp) vl_apresentado,		-- Apresentado = a.ie_status <> 'D' 




$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.gerenciar_atualizacao_val_prot ( tb_protocolos_p dbms_sql.number_table, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;