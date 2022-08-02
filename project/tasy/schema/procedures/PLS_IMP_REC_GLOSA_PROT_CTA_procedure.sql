-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_rec_glosa_prot_cta ( nr_seq_protocolo_p bigint, cd_guia_prestador_p text, cd_ans_p text, cd_guia_p text, nm_operadora_p text, cd_prestador_executor_p text, nm_prestador_executor_p text, ie_recurso_glosa_p text, nr_protocolo_p text, vl_total_recursado_p bigint, dt_recurso_p timestamp, nr_lote_p text, nm_usuario_p text, cd_cpf_prestador_imp_p pls_rec_glosa_prot_cta_imp.cd_cpf_prestador_imp%type, cd_cgc_prestador_imp_p pls_rec_glosa_prot_cta_imp.cd_cgc_prestador_imp%type, nr_seq_protocolo_cpt_p INOUT bigint) AS $body$
DECLARE

					 
														 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Importar todas os protocolos do arquivo de Recurso de Glosa do padrão TISS 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ x] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_protocolo_cpt_imp_w		bigint;
nr_seq_prestador_w			pls_rec_glosa_prot_cta_imp.nr_seq_prestador%type;
nr_seq_prestador_aux_w			pls_rec_glosa_prot_cta_imp.nr_seq_prestador%type;

BEGIN
 
if (cd_cgc_prestador_imp_p IS NOT NULL AND cd_cgc_prestador_imp_p::text <> '') then 
	nr_seq_prestador_aux_w	:= pls_obter_prestador_cgc(	cd_cgc_prestador_imp_p,null);
	 
	if (nr_seq_prestador_aux_w IS NOT NULL AND nr_seq_prestador_aux_w::text <> '') then 
		nr_seq_prestador_w	:= nr_seq_prestador_aux_w;
	end if;	
end if;
 
if (coalesce(nr_seq_prestador_w::text, '') = '') then 
	nr_seq_prestador_w	:= pls_obter_prestador_imp(	cd_cgc_prestador_imp_p, cd_cpf_prestador_imp_p, cd_prestador_executor_p, 
								null, null, null);
end if;
 
select 	nextval('pls_rec_glosa_prot_cta_imp_seq') 
into STRICT	nr_seq_protocolo_cpt_imp_w
;
 
insert into pls_rec_glosa_prot_cta_imp( nr_sequencia, dt_recurso , dt_atualizacao, 
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
					vl_total_recursado, cd_ans, cd_guia,         
					cd_guia_prestador, nm_operadora, ie_recurso_glosa, 
					cd_prestador_executor, nm_prestador_executor, nr_lote, 
					nr_protocolo, nr_seq_protocolo,nr_seq_prestador, 
					cd_cpf_prestador_imp, cd_cgc_prestador_imp) 
			values (	nr_seq_protocolo_cpt_imp_w, dt_recurso_p , clock_timestamp(), 
					nm_usuario_p, clock_timestamp(), nm_usuario_p, 
					vl_total_recursado_p, cd_ans_p, cd_guia_p,         
					cd_guia_prestador_p, nm_operadora_p, ie_recurso_glosa_p, 
					cd_prestador_executor_p, nm_prestador_executor_p, nr_lote_p, 
					nr_protocolo_p, nr_seq_protocolo_p, nr_seq_prestador_w, 
					cd_cpf_prestador_imp_p, cd_cgc_prestador_imp_p);
 
/*---------------------------------------------------------------------------------------------------- 
		OS 874282 --- Edson (ekjunior) 
  Criado esse trecho com UPDATE para alimentar o campo Prestador 
  na tabela PLS_REC_GLOSA_PROTOCOLO com a informação vinda no XML. 
  Tratamento realizado após comentar trecho na 
  PROCEDURE - PLS_GERAR_REC_GLOSA_PROTOCOLO. Linha 20 
*/
 
update	pls_rec_glosa_protocolo 
set	nr_seq_prestador 	= nr_seq_prestador_w, 
	nr_lote_prestador	= nr_lote_p 
where	nr_sequencia 		= nr_seq_protocolo_p 
and	coalesce(nr_seq_prestador::text, '') = '';
/*-------------------------------------------------------------------------------------------------------*/
 
 
nr_seq_protocolo_cpt_p 	:= nr_seq_protocolo_cpt_imp_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_rec_glosa_prot_cta ( nr_seq_protocolo_p bigint, cd_guia_prestador_p text, cd_ans_p text, cd_guia_p text, nm_operadora_p text, cd_prestador_executor_p text, nm_prestador_executor_p text, ie_recurso_glosa_p text, nr_protocolo_p text, vl_total_recursado_p bigint, dt_recurso_p timestamp, nr_lote_p text, nm_usuario_p text, cd_cpf_prestador_imp_p pls_rec_glosa_prot_cta_imp.cd_cpf_prestador_imp%type, cd_cgc_prestador_imp_p pls_rec_glosa_prot_cta_imp.cd_cgc_prestador_imp%type, nr_seq_protocolo_cpt_p INOUT bigint) FROM PUBLIC;

