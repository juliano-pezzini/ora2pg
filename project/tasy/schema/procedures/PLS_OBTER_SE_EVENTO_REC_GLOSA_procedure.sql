-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_se_evento_rec_glosa ( nr_seq_prot_rec_p pls_rec_glosa_protocolo.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_evento_p INOUT pls_evento.nr_sequencia%type, nr_seq_regra_p INOUT pls_evento_regra_producao.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  	Verificar se tem evento cadastrado para as contas de recurso de glosa. 
	Procedure chamada na liberacao do protocolo de recurso para pagamento.
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
C01 CURSOR FOR
	SELECT	e.nr_seq_conta,
		e.cd_procedimento,
		e.ie_origem_proced,
		e.nr_seq_material,
		e.ie_tipo_guia,
		e.ie_origem_conta,
		e.nr_seq_tipo_atendimento, 
		e.ie_tipo_despesa,
		e.nr_seq_segurado,
		CASE WHEN coalesce(e.nr_seq_exame_coleta::text, '') = '' THEN 'N'  ELSE CASE WHEN e.ds_tipo_item='Prestador (Taxa de Coleta)' THEN 'S'  ELSE 'N' END  END  ie_taxa_coleta,
		e.ie_regime_atendimento,
		e.ie_saude_ocupacional
	from	pls_conta_medica_resumo e,
		pls_conta_proc d,
		pls_rec_glosa_proc c,
		pls_rec_glosa_conta b,
		pls_rec_glosa_protocolo a
	where	a.nr_sequencia			= nr_seq_prot_rec_p
	and	a.nr_sequencia			= b.nr_seq_protocolo
	and	b.nr_sequencia			= c.nr_seq_conta_rec
	and	c.nr_seq_conta_proc		= d.nr_sequencia
	and	d.nr_sequencia			= e.nr_seq_conta_proc
	and	d.nr_seq_conta			= e.nr_seq_conta
	
union

	SELECT	e.nr_seq_conta,
		e.cd_procedimento,
		e.ie_origem_proced,
		e.nr_seq_material,
		e.ie_tipo_guia,
		e.ie_origem_conta,
		e.nr_seq_tipo_atendimento, 
		e.ie_tipo_despesa,
		e.nr_seq_segurado,
		CASE WHEN coalesce(e.nr_seq_exame_coleta::text, '') = '' THEN 'N'  ELSE CASE WHEN e.ds_tipo_item='Prestador (Taxa de Coleta)' THEN 'S'  ELSE 'N' END  END  ie_taxa_coleta,
		e.ie_regime_atendimento,
		e.ie_saude_ocupacional
	from	pls_conta_medica_resumo e,
		pls_conta_mat d,
		pls_rec_glosa_mat c,
		pls_rec_glosa_conta b,
		pls_rec_glosa_protocolo a
	where	a.nr_sequencia			= nr_seq_prot_rec_p
	and	a.nr_sequencia			= b.nr_seq_protocolo
	and	b.nr_sequencia			= c.nr_seq_conta_rec
	and	c.nr_seq_conta_mat		= d.nr_sequencia
	and	d.nr_sequencia			= e.nr_seq_conta_mat
	and	d.nr_seq_conta			= e.nr_seq_conta;

BEGIN

if (nr_seq_prot_rec_p IS NOT NULL AND nr_seq_prot_rec_p::text <> '') then
	for r_C01_w in C01 loop
		begin		
		SELECT * FROM pls_obter_evento_item(	r_C01_w.cd_procedimento, r_C01_w.ie_origem_proced, r_C01_w.nr_seq_material, cd_estabelecimento_p, r_C01_w.ie_tipo_guia, r_C01_w.ie_origem_conta, r_C01_w.nr_seq_tipo_atendimento, r_C01_w.ie_tipo_despesa, r_C01_w.nr_seq_segurado, r_C01_w.nr_seq_conta, r_C01_w.ie_taxa_coleta, null, nr_seq_evento_p, nr_seq_regra_p, 'G', r_C01_w.ie_regime_atendimento, r_C01_w.ie_saude_ocupacional) INTO STRICT nr_seq_evento_p, nr_seq_regra_p;	
		end;
	end loop;
end if;
		
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_se_evento_rec_glosa ( nr_seq_prot_rec_p pls_rec_glosa_protocolo.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_evento_p INOUT pls_evento.nr_sequencia%type, nr_seq_regra_p INOUT pls_evento_regra_producao.nr_sequencia%type) FROM PUBLIC;
