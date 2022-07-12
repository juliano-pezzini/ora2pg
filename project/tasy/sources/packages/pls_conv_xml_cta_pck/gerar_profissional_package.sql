-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Cadastra pessoa fisica e profissional



CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.gerar_profissional ( nr_seq_cons_prof_conv_p pls_conta_imp.nr_seq_cons_prof_exec_conv%type, nr_conselho_prof_conv_p pls_conta_imp.nr_cons_prof_exec_conv%type, sg_uf_conselho_conv_p pls_conta_imp.cd_uf_cons_prof_exec_conv%type, nm_profissional_p pls_conta_imp.nm_profissional_exec%type, nr_seq_cbo_saude_p pls_conta_imp.nr_seq_cbo_prof_exec_conv%type, cd_versao_tiss_p pls_protocolo_conta_imp.cd_versao_tiss%type, nr_cpf_p pessoa_fisica.nr_cpf%type, nm_usuario_p text, cd_pessoa_fisica_conv_p INOUT pessoa_fisica.cd_pessoa_fisica%type) AS $body$
DECLARE


cd_pessoa_fisica_w 	pessoa_fisica.cd_pessoa_fisica%type;
			

BEGIN
--Inicializa os parametros out

cd_pessoa_fisica_w := null;

--Insere os dados da pessoa fisica e retorna o c_digo da pessoa fisica cadastrada

insert into pessoa_fisica(
	cd_pessoa_fisica, nm_usuario, dt_atualizacao,
	nm_pessoa_fisica, ie_tipo_pessoa, nr_cpf,
	nr_seq_conselho, nm_usuario_nrec, dt_atualizacao_nrec
) values (
	nextval('pessoa_fisica_seq'), nm_usuario_p, clock_timestamp(),
	nm_profissional_p, 1, nr_cpf_p,
	nr_seq_cons_prof_conv_p, nm_usuario_p, clock_timestamp()
) returning cd_pessoa_fisica into cd_pessoa_fisica_w;

--Insere o profissional com o c_digo da pessoa fisica cadastrada

insert into medico(
	cd_pessoa_fisica,nr_crm, nm_guerra,
	ie_vinculo_medico, dt_atualizacao, nm_usuario,
	ie_corpo_clinico, ie_corpo_assist,uf_crm,
	ie_situacao, nm_usuario_nrec, dt_atualizacao_nrec
) values (
	cd_pessoa_fisica_w, nr_conselho_prof_conv_p, nm_profissional_p,
	9, clock_timestamp(), nm_usuario_p,
	'N', 'N', sg_uf_conselho_conv_p,
	'S', nm_usuario_p, clock_timestamp()
);

CALL pls_conv_xml_cta_pck.insere_espec_profissional( 	cd_pessoa_fisica_w, nr_seq_cbo_saude_p, cd_versao_tiss_p, nm_usuario_p);

commit;

--Retorna o c_digo da pessoa fisica cadastrada

cd_pessoa_fisica_conv_p := cd_pessoa_fisica_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.gerar_profissional ( nr_seq_cons_prof_conv_p pls_conta_imp.nr_seq_cons_prof_exec_conv%type, nr_conselho_prof_conv_p pls_conta_imp.nr_cons_prof_exec_conv%type, sg_uf_conselho_conv_p pls_conta_imp.cd_uf_cons_prof_exec_conv%type, nm_profissional_p pls_conta_imp.nm_profissional_exec%type, nr_seq_cbo_saude_p pls_conta_imp.nr_seq_cbo_prof_exec_conv%type, cd_versao_tiss_p pls_protocolo_conta_imp.cd_versao_tiss%type, nr_cpf_p pessoa_fisica.nr_cpf%type, nm_usuario_p text, cd_pessoa_fisica_conv_p INOUT pessoa_fisica.cd_pessoa_fisica%type) FROM PUBLIC;