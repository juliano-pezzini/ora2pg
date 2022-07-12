-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE audc_auditoria_concorrente_pck.audc_atualizar_atend_imp ( nr_seq_lote_atend_imp_p audc_lote_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE
				

					
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
nr_seq_guia_w		pls_guia_plano.nr_sequencia%type;
cd_medico_solic_w	pessoa_fisica.cd_pessoa_fisica%type;
ie_home_care_w		varchar(2);


C01 CURSOR(  nr_seq_lote_atend_imp_pc	audc_lote_atendimento_imp.nr_sequencia%type ) FOR	
	SELECT  nr_sequencia,
	        cd_guia_operadora,
	        cd_cartao_beneficiario,
		cd_conselho_prof_solic,
        	cd_uf_crm_prof_solic,
        	nr_crm_prof_solic,
		pls_obter_prestador_imp(nr_cnpj_prestador_solic, nr_cpf_prestador_solic, cd_prestador_solic, null, null,null,'G', cd_estabelecimento, null) nr_seq_prest_solic,
		pls_obter_prestador_imp(nr_cnpj_prestador_exec, nr_cpf_prestador_exec, cd_prestador_exec, null, null,null,'G', cd_estabelecimento, null) nr_seq_prest_exec
	from    audc_atendimento_imp
	where	nr_seq_lote_atend_imp = nr_seq_lote_atend_imp_pc;
	
	
BEGIN


for c01_w in C01( nr_seq_lote_atend_imp_p ) loop


	select	max(b.nr_seq_segurado)
	into STRICT	nr_seq_segurado_w
	from	pls_segurado_carteira b
	where	b.cd_usuario_plano = c01_w.cd_cartao_beneficiario;

	if ( coalesce(nr_seq_segurado_w::text, '') = '' ) then
		select	max(b.nr_seq_segurado)
		into STRICT	nr_seq_segurado_w
		from	pls_segurado_carteira b
		where	b.nr_cartao_intercambio = c01_w.cd_cartao_beneficiario;
	end if;


	select	max(a.nr_sequencia)
	into STRICT	nr_seq_guia_w
	from	pls_guia_plano a
	where	a.nr_seq_segurado = nr_seq_segurado_w
	and	a.cd_guia 	  = c01_w.cd_guia_operadora;
	
	select 	CASE WHEN count(1)=1 THEN  'S'  ELSE 'N' END
	into STRICT	ie_home_care_w
	from 	pls_segurado a,
		paciente_home_care b 
	where	a.cd_pessoa_fisica = b.cd_pessoa_fisica 	
	and	coalesce(b.dt_final::text, '') = '' 
	and	a.nr_sequencia = nr_seq_segurado_w;
	
	
	select	max(a.cd_pessoa_fisica)
	into STRICT	cd_medico_solic_w
	from	medico 			a,
		pessoa_fisica 		b,
		conselho_profissional	c
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	b.nr_seq_conselho	= c.nr_sequencia
	and	a.nr_crm		= c01_w.nr_crm_prof_solic
	and	a.uf_crm		= c01_w.cd_uf_crm_prof_solic
	and	c.ie_conselho_prof_tiss	= c01_w.cd_conselho_prof_solic;
	

	update 	audc_atendimento_imp
	set	dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		nr_seq_prestador_solic = coalesce(nr_seq_prestador_solic, c01_w.nr_seq_prest_solic),
		nr_seq_prestador_exec  = coalesce(nr_seq_prestador_exec, c01_w.nr_seq_prest_exec),
		nr_seq_guia = coalesce(nr_seq_guia, nr_seq_guia_w),
		nr_seq_segurado = coalesce(nr_seq_segurado, nr_seq_segurado_w),
		cd_medico_solicitante = coalesce(cd_medico_solicitante,cd_medico_solic_w),
		ie_benef_home_care = coalesce(ie_benef_home_care, ie_home_care_w)
	where	nr_sequencia = c01_w.nr_sequencia;
	
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE audc_auditoria_concorrente_pck.audc_atualizar_atend_imp ( nr_seq_lote_atend_imp_p audc_lote_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;