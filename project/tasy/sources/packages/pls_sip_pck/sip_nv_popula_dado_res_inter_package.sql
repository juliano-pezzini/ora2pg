-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.sip_nv_popula_dado_res_inter ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


_ora2pg_r RECORD;
tb_rowid_w			pls_util_cta_pck.t_rowid;
tb_nr_seq_clinica_w		pls_util_cta_pck.t_number_table;
tb_ie_regime_internacao_w	pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_tipo_atendimento_w	pls_util_cta_pck.t_number_table;
tb_ie_regime_atendimento_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_saude_ocupacional_w	pls_util_cta_pck.t_varchar2_table_5;
tb_qt_nasc_vivos_total_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_cbo_saude_w		pls_util_cta_pck.t_number_table;
tb_cd_cid_principal_w		pls_util_cta_pck.t_varchar2_table_10;
tb_cd_cat_cid_principal_w	pls_util_cta_pck.t_varchar2_table_10;

nr_indice_w			integer;
						
c01 CURSOR(	nr_seq_lote_pc		pls_lote_sip.nr_sequencia%type,
		nm_usuario_pc		usuario.nm_usuario%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	a.nr_sequencia nr_seq_conta,
		pls_sip_pck.obter_conta_princ_inter(a.nr_seq_segurado, a.cd_guia_ok, CASE WHEN a.ie_origem_conta='A' THEN  'S'  ELSE 'N' END ) nr_seq_conta_princ
	from   	pls_conta a
	where	a.nr_sequencia in (	SELECT	distinct z.nr_seq_conta
					from	sip_nv_dados z
					where	z.nr_seq_lote_sip = nr_seq_lote_pc
					and	z.ie_tipo_atendimento = 'I');
	
c02 CURSOR(nr_seq_conta_pc	sip_nv_dados.nr_seq_conta%type) FOR
	SELECT	a.nr_seq_clinica,
		a.ie_regime_internacao,
		a.nr_seq_tipo_atendimento,
		a.ie_regime_atendimento,
		a.ie_saude_ocupacional,
		a.qt_nasc_vivos_total,
		a.nr_seq_cbo_saude,
		a.cd_cid_principal cd_doenca_dig,
		a.cd_cat_cid_principal cd_categoria_cid
	from	pls_conta_v a
	where	a.nr_sequencia = nr_seq_conta_pc;
	
c03 CURSOR(	nr_seq_lote_pc		pls_lote_sip.nr_sequencia%type,
		nr_seq_conta_lote_pc	sip_nv_dados.nr_seq_conta%type) FOR
	SELECT	oid
	from	sip_nv_dados a
	where	a.nr_seq_lote_sip = nr_seq_lote_pc
	and	a.nr_seq_conta = nr_seq_conta_lote_pc;
						
BEGIN

-- busca todas as contas que fazem parte do envio do SIP

nr_indice_w := 0;
for r_c01_w in c01(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p) loop				
	
	-- abre um cursor para buscar os dados da conta original da abertura

	for r_c02_w in c02(r_c01_w.nr_seq_conta_princ) loop
		
		-- retornar todos os registros da sip_nv_dados que precisam ser alterados com os dados da conta 

		-- original da abertura

		for r_c03_w in c03(nr_seq_lote_p, r_c01_w.nr_seq_conta) loop
	
			tb_rowid_w(nr_indice_w) := r_c03_w.rowid;
			tb_nr_seq_clinica_w(nr_indice_w) := r_c02_w.nr_seq_clinica;
			tb_ie_regime_internacao_w(nr_indice_w) := r_c02_w.ie_regime_internacao;
			tb_nr_seq_tipo_atendimento_w(nr_indice_w) := r_c02_w.nr_seq_tipo_atendimento;
			tb_ie_regime_atendimento_w(nr_indice_w) := r_c02_w.ie_regime_atendimento;
			tb_ie_saude_ocupacional_w(nr_indice_w) := r_c02_w.ie_saude_ocupacional;
			tb_qt_nasc_vivos_total_w(nr_indice_w) := r_c02_w.qt_nasc_vivos_total;
			tb_nr_seq_cbo_saude_w(nr_indice_w) := r_c02_w.nr_seq_cbo_saude;
			tb_cd_cid_principal_w(nr_indice_w) := r_c02_w.cd_doenca_dig;
			tb_cd_cat_cid_principal_w(nr_indice_w) := r_c02_w.cd_categoria_cid;
			
			-- se atingiu a quantidade de registros manda para o banco

			if (nr_indice_w >= current_setting('pls_sip_pck.qt_registro_transacao_w')::integer) then
				
				 SELECT * FROM pls_sip_pck.p_grava_dado_cta_ref(	tb_rowid_w, tb_nr_seq_clinica_w, tb_ie_regime_internacao_w, tb_nr_seq_tipo_atendimento_w, tb_ie_regime_atendimento_w, tb_ie_saude_ocupacional_w, tb_qt_nasc_vivos_total_w, tb_nr_seq_cbo_saude_w, tb_cd_cid_principal_w, tb_cd_cat_cid_principal_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	tb_rowid_w := _ora2pg_r.tb_rowid_p; tb_nr_seq_clinica_w := _ora2pg_r.tb_nr_seq_clinica_p; tb_ie_regime_internacao_w := _ora2pg_r.tb_ie_regime_internacao_p; tb_nr_seq_tipo_atendimento_w := _ora2pg_r.tb_nr_seq_tipo_atendimento_p; tb_ie_regime_atendimento_w := _ora2pg_r.tb_ie_regime_atendimento_p; tb_ie_saude_ocupacional_w := _ora2pg_r.tb_ie_saude_ocupacional_p; tb_qt_nasc_vivos_total_w := _ora2pg_r.tb_qt_nasc_vivos_total_p; tb_nr_seq_cbo_saude_w := _ora2pg_r.tb_nr_seq_cbo_saude_p; tb_cd_cid_principal_w := _ora2pg_r.tb_cd_cid_principal_p; tb_cd_cat_cid_principal_w := _ora2pg_r.tb_cd_cat_cid_principal_p;
				nr_indice_w := 0;
				
			-- se nao bota na fila e fica na espera.

			else
				nr_indice_w := nr_indice_w + 1;
			end if;

		end loop;
	end loop;
end loop;
-- se sobrou algo manda para o banco

SELECT * FROM pls_sip_pck.p_grava_dado_cta_ref(	tb_rowid_w, tb_nr_seq_clinica_w, tb_ie_regime_internacao_w, tb_nr_seq_tipo_atendimento_w, tb_ie_regime_atendimento_w, tb_ie_saude_ocupacional_w, tb_qt_nasc_vivos_total_w, tb_nr_seq_cbo_saude_w, tb_cd_cid_principal_w, tb_cd_cat_cid_principal_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	tb_rowid_w := _ora2pg_r.tb_rowid_p; tb_nr_seq_clinica_w := _ora2pg_r.tb_nr_seq_clinica_p; tb_ie_regime_internacao_w := _ora2pg_r.tb_ie_regime_internacao_p; tb_nr_seq_tipo_atendimento_w := _ora2pg_r.tb_nr_seq_tipo_atendimento_p; tb_ie_regime_atendimento_w := _ora2pg_r.tb_ie_regime_atendimento_p; tb_ie_saude_ocupacional_w := _ora2pg_r.tb_ie_saude_ocupacional_p; tb_qt_nasc_vivos_total_w := _ora2pg_r.tb_qt_nasc_vivos_total_p; tb_nr_seq_cbo_saude_w := _ora2pg_r.tb_nr_seq_cbo_saude_p; tb_cd_cid_principal_w := _ora2pg_r.tb_cd_cid_principal_p; tb_cd_cat_cid_principal_w := _ora2pg_r.tb_cd_cat_cid_principal_p;
				
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.sip_nv_popula_dado_res_inter ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
