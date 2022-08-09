-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_solic_alteracao_aut_benef ( cd_pessoa_fisica_p text, nr_ddd_celular_p text, nr_telef_celular_benef_p text, nr_ddd_telef_benef_p text, nr_telef_beneficiario_p text, ds_email_beneficiario_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

					 
ds_email_w		varchar(255);
nr_ddd_telefone_w	varchar(2);
nr_telefone_w		varchar(15);
nr_ddd_celular_w	varchar(2);
nr_telefone_celular_w	varchar(15);

nr_seq_solicitacao_w	bigint;

 

BEGIN 
begin 
	select		a.ds_email, 
			a.nr_ddd_telefone, 
			a.nr_telefone, 
			b.nr_ddd_celular, 
			b.nr_telefone_celular 
	into STRICT		ds_email_w, 
			nr_ddd_telefone_w, 
			nr_telefone_w, 
			nr_ddd_celular_w, 
			nr_telefone_celular_w 
	from 		compl_pessoa_fisica a, 
			pessoa_fisica b 
	where 	b.cd_pessoa_fisica = a.cd_pessoa_fisica 
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and	a.ie_tipo_complemento = 1;
exception 
when others then 
	ds_email_w		:= null;
	nr_ddd_telefone_w	:= null;
	nr_telefone_w		:= null;
	nr_ddd_celular_w	:= null;
	nr_telefone_celular_w	:= null;
end;
 
if (ds_email_beneficiario_p IS NOT NULL AND ds_email_beneficiario_p::text <> '') then 
	nr_seq_solicitacao_w := pls_gravar_solic_alt_analise(	ds_email_w, ds_email_beneficiario_p, 'DS_EMAIL', 'COMPL_PESSOA_FISICA', cd_pessoa_fisica_p, nm_usuario_p, 'B', Null, 'T', 1, cd_estabelecimento_p, 1270, nr_seq_solicitacao_w);
end if;
 
if (nr_ddd_telef_benef_p IS NOT NULL AND nr_ddd_telef_benef_p::text <> '') then 
	nr_seq_solicitacao_w := pls_gravar_solic_alt_analise(	nr_ddd_telefone_w, nr_ddd_telef_benef_p, 'NR_DDD_TELEFONE', 'COMPL_PESSOA_FISICA', cd_pessoa_fisica_p, nm_usuario_p, 'B', Null, 'T', 1, cd_estabelecimento_p, 1270, nr_seq_solicitacao_w);
end if;
 
if (nr_telef_beneficiario_p IS NOT NULL AND nr_telef_beneficiario_p::text <> '') then 
	nr_seq_solicitacao_w := pls_gravar_solic_alt_analise(	nr_telefone_w, nr_telef_beneficiario_p, 'NR_TELEFONE', 'COMPL_PESSOA_FISICA', cd_pessoa_fisica_p, nm_usuario_p, 'B', Null, 'T', 1, cd_estabelecimento_p, 1270, nr_seq_solicitacao_w);
end if;	
 
if (nr_ddd_celular_p IS NOT NULL AND nr_ddd_celular_p::text <> '') then 
	nr_seq_solicitacao_w := pls_gravar_solic_alt_analise(	nr_ddd_celular_w, nr_ddd_celular_p, 'NR_DDD_CELULAR', 'PESSOA_FISICA', cd_pessoa_fisica_p, nm_usuario_p, 'B', Null, 'T', Null, cd_estabelecimento_p, 1270, nr_seq_solicitacao_w);
end if;		
 
if (nr_telef_celular_benef_p IS NOT NULL AND nr_telef_celular_benef_p::text <> '') then 
	nr_seq_solicitacao_w := pls_gravar_solic_alt_analise(	nr_telefone_celular_w, nr_telef_celular_benef_p, 'NR_TELEFONE_CELULAR', 'PESSOA_FISICA', cd_pessoa_fisica_p, nm_usuario_p, 'B', Null, 'T', Null, cd_estabelecimento_p, 1270, nr_seq_solicitacao_w);
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_solic_alteracao_aut_benef ( cd_pessoa_fisica_p text, nr_ddd_celular_p text, nr_telef_celular_benef_p text, nr_ddd_telef_benef_p text, nr_telef_beneficiario_p text, ds_email_beneficiario_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
