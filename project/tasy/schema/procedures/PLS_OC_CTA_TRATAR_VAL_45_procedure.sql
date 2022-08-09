-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_45 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


dados_validacao_w	pls_tipos_ocor_pck.dados_val_partic;

-- Regras
C01 CURSOR(nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		a.ie_forma_aplicacao,
		a.ie_incidencia,
		a.nr_seq_regra_partic,
		a.ie_glosa
	from	pls_oc_cta_val_regra_part a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

BEGIN

if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- usa uma tabela para armazenar as combinaçoes de participantes

	-- no futuro isso deve ser feito através de uma view materializada, nao foi feito ainda por motivo de nao existir suporte para este tipo de objetos no TASY
	CALL pls_gerencia_upd_obj_pck.atualizar_objetos(nm_usuario_p, 'PLS_OC_CTA_TRATAR_VAL_45', 'PLS_GRUPO_PARTIC_TM');
	
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	
	-- abre as regras
	for	r_C01_w in C01(dados_regra_p.nr_sequencia) loop
	
		dados_validacao_w.nr_sequencia		:= r_C01_w.nr_sequencia;
		dados_validacao_w.ie_forma_aplicacao	:= r_C01_w.ie_forma_aplicacao;
		dados_validacao_w.ie_incidencia		:= r_C01_w.ie_incidencia;
		dados_validacao_w.nr_seq_regra_partic	:= r_C01_w.nr_seq_regra_partic;
		dados_validacao_w.ie_glosa		:= r_C01_w.ie_glosa;
		
	
		case(dados_validacao_w.ie_forma_aplicacao)
			-- grau duplicado
			when 'GD' then
				pls_regra_partic_pck.processa_grau_duplicado(	dados_validacao_w, nr_id_transacao_p,
										dados_regra_p, nm_usuario_p);
										
			-- participante duplicado
			when 'PD' then
				pls_regra_partic_pck.processa_partic_duplicado(	dados_validacao_w, nr_id_transacao_p, 
										dados_regra_p, nm_usuario_p);
			
			-- Regra de participantes
			when 'R' then
				pls_regra_partic_pck.processa_regra_partic(	dados_validacao_w, nr_id_transacao_p, 
										dados_regra_p, nm_usuario_p);
										
			when 'GDS' then
				pls_regra_partic_pck.processa_grau_duplicado_unico(	dados_validacao_w, nr_id_transacao_p,
											dados_regra_p, nm_usuario_p);
			
			when 'GDP' then
			
				pls_regra_partic_pck.processa_grau_duplic_part_dif(	dados_validacao_w, nr_id_transacao_p,
											dados_regra_p, nm_usuario_p);
											
			when 'PDP' then
				CALL pls_regra_partic_pck.processa_partic_duplic_prest(	dados_validacao_w, nr_id_transacao_p,
										dados_regra_p, nm_usuario_p);								
			else
				null;
		end case;
	end loop;
	
	-- seta os registros que serao válidos ou inválidos após o processamento 
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_45 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
