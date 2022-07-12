-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Apos as validacoes, essa rotina e chamada para inserir o anexo em uma das tabelas definitivas....
CREATE OR REPLACE PROCEDURE pls_ger_envio_anexos_ans_pck.efetivar_insercao_anexo ( nr_seq_anexo_imp_p pls_anexo_imp.nr_sequencia%type, ds_anexo_p pls_conta_anexo.ds_anexo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

									
nr_seq_conta_w		pls_conta.nr_sequencia%type;
nr_seq_guia_w		pls_guia_plano.nr_sequencia%type;
nr_seq_protocolo_w	pls_protocolo_conta.nr_sequencia%type;
nr_seq_prot_rec_w	pls_rec_glosa_protocolo.nr_sequencia%type;		
ds_observacao_w		pls_anexo_imp.ds_observacao%type;				
cd_tipo_documento_w	pls_anexo_imp.cd_tipo_documento%type;		
									

BEGIN
	
	select 	max(a.nr_seq_conta),
			max(a.nr_seq_guia_plano),
			max(a.nr_seq_protocolo),
			max(a.nr_seq_rec_protocolo),
			max(a.ds_observacao),
			max(a.cd_tipo_documento)
	into STRICT	nr_seq_conta_w,
			nr_seq_guia_w,			
			nr_seq_protocolo_w,
			nr_seq_prot_rec_w,
			ds_observacao_w,
			cd_tipo_documento_w
	from	pls_anexo_imp a
	where 	a.nr_sequencia = nr_seq_anexo_imp_p;
	
	if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
		
		insert into pls_conta_anexo( nr_sequencia, nr_seq_conta, dt_anexo,
									ds_anexo, dt_atualizacao, nm_usuario,
									dt_atualizacao_nrec, nm_usuario_nrec, ie_origem_anexo,
									ds_observacao, cd_tipo_documento)
				values ( nextval('pls_conta_anexo_seq'), nr_seq_conta_w, clock_timestamp(),
						ds_anexo_p, clock_timestamp(), nm_usuario_p,
						clock_timestamp(), nm_usuario_p, 3,
						ds_observacao_w, cd_tipo_documento_w);
		
	elsif (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then
		
		insert into pls_protocolo_conta_anexo( nr_sequencia, cd_estabelecimento, dt_atualizacao,
												nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
												dt_anexo, ds_anexo, cd_tipo_documento,
												ie_origem_anexo, nr_seq_protocolo)
				values ( nextval('pls_protocolo_conta_anexo_seq'), cd_estabelecimento_p, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						clock_timestamp(), ds_anexo_p, cd_tipo_documento_w,
						3, nr_seq_protocolo_w);
		
	elsif (nr_seq_prot_rec_w IS NOT NULL AND nr_seq_prot_rec_w::text <> '') then
		
		insert into pls_rec_glosa_anexo( nr_sequencia, nr_seq_protocolo_rec, dt_atualizacao,
										nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
										dt_arquivo, ds_arquivo, ds_observacao,
										ie_origem_anexo, cd_tipo_documento)
				values ( nextval('pls_rec_glosa_anexo_seq'), nr_seq_prot_rec_w, clock_timestamp(),
						nm_usuario_p, clock_timestamp(), nm_usuario_p,
						clock_timestamp(), ds_anexo_p, ds_observacao_w,
						3, cd_tipo_documento_w);
		
	elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
	
		insert into pls_guia_plano_anexo( nr_sequencia, nr_seq_guia, dt_anexo,
										ds_anexo, dt_atualizacao, nm_usuario,
										dt_atualizacao_nrec, nm_usuario_nrec, ie_origem_anexo,
										cd_tipo_documento, ds_observacao)
				values ( nextval('pls_guia_plano_anexo_seq'), nr_seq_guia_w, clock_timestamp(),
						ds_anexo_p, clock_timestamp(), nm_usuario_p, 
						clock_timestamp(), nm_usuario_p, 3, 
						cd_tipo_documento_w, ds_observacao_w);
	
	end if;

END;									

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ger_envio_anexos_ans_pck.efetivar_insercao_anexo ( nr_seq_anexo_imp_p pls_anexo_imp.nr_sequencia%type, ds_anexo_p pls_conta_anexo.ds_anexo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
