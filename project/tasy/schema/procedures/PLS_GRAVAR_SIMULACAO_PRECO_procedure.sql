-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_simulacao_preco ( ie_tipo_simulacao_p text, nm_benef_p text, dt_nasc_p text, nr_telefone_p text, ds_email_p text, nr_ddi_p text, nr_ddd_p text, sg_estado_p text, cd_municipio_ibge_p text, nr_seq_simulacao_p INOUT bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_simulacao_w      bigint:= 0;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;


BEGIN
nr_seq_simulacao_w 	:= nr_seq_simulacao_p;
cd_estabelecimento_w	:= coalesce(cd_estabelecimento_p, pls_parametro_operadora_web('EST'));

if ( coalesce(nr_seq_simulacao_w::text, '') = '') then
	select	nextval('pls_simulacao_preco_seq')
	into STRICT	nr_seq_simulacao_w
	;

	insert into pls_simulacao_preco(
			    nr_sequencia,
			    dt_simulacao,
			    ie_tipo_contratacao,
			    ie_tipo_processo,
			    nm_pessoa,
			    dt_nascimento,
			    nr_telefone,
			    ds_email,
			    cd_estabelecimento,
			    nm_usuario,
			    dt_atualizacao,
			    nm_usuario_nrec,
			    dt_atualizacao_nrec,
			    nr_ddi,
			    nr_ddd,
			    sg_estado,
			    cd_municipio_ibge
	) values (
			    nr_seq_simulacao_w,
			    clock_timestamp(),
			    ie_tipo_simulacao_p,
			    'W',
			    nm_benef_p,
			    dt_nasc_p,
			    nr_telefone_p,
			    ds_email_p,
			    coalesce(cd_estabelecimento_w,1),
			    'OPS - Portal',
			    clock_timestamp(),
			    'OPS - Portal',
			    clock_timestamp(),
			    nr_ddi_p,
			    nr_ddd_p,
			    sg_estado_p,
			    cd_municipio_ibge_p
	);
else
	update  pls_simulacao_preco set
		    nm_pessoa 		= nm_benef_p,
		    dt_nascimento 		= dt_nasc_p,
		    nr_telefone 		= nr_telefone_p,
		    ds_email 		= ds_email_p,
		    nr_ddi 			= nr_ddi_p,
		    nr_ddd 		= nr_ddd_p,
		    sg_estado 		= sg_estado_p,
		    cd_municipio_ibge 	= cd_municipio_ibge_p
	where   nr_sequencia = nr_seq_simulacao_w;
end if;

commit;

nr_seq_simulacao_p := nr_seq_simulacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_simulacao_preco ( ie_tipo_simulacao_p text, nm_benef_p text, dt_nasc_p text, nr_telefone_p text, ds_email_p text, nr_ddi_p text, nr_ddd_p text, sg_estado_p text, cd_municipio_ibge_p text, nr_seq_simulacao_p INOUT bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
