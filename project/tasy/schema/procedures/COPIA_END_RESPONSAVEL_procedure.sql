-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_end_responsavel ( cd_pessoa_origem_p text, cd_pessoa_destino_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

delete FROM compl_pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_destino_p
and	ie_tipo_complemento	= 1;

CALL gravar_log_exclusao('COMPL_PESSOA_FISICA',nm_usuario_p,substr('CD_PESSOA_FISICA=' || cd_pessoa_destino_p ||
			', IE_TIPO_COMPLEMENTO=1' || ' - COPIA_END_RESPONSAVEL',1,255),'N');

select coalesce(max(nr_sequencia),0) + 1
into STRICT nr_sequencia_w
from compl_pessoa_fisica
where cd_pessoa_fisica = cd_pessoa_destino_p;

insert into compl_pessoa_fisica(
	cd_pessoa_fisica,
	nr_sequencia,
	ie_tipo_complemento,
	dt_atualizacao,
	nm_usuario,
	nm_contato,
	ds_endereco,
	cd_cep,
	nr_endereco,
	ds_complemento,
	ds_bairro,
	ds_municipio,
	sg_estado,
	nr_telefone,
	nr_ramal,
	ds_observacao,
	ds_email,
	cd_municipio_ibge,
	cd_pessoa_fisica_ref,
	cd_tipo_logradouro)
SELECT
	cd_pessoa_destino_p,
	nr_sequencia_w,
	ie_tipo_complemento,
	clock_timestamp(),
	nm_usuario_p,
	nm_contato,
	ds_endereco,
	cd_cep,
	nr_endereco,
	ds_complemento,
	ds_bairro,
	ds_municipio,
	sg_estado,
	nr_telefone,
	nr_ramal,
	ds_observacao,
	ds_email,
	cd_municipio_ibge,
	cd_pessoa_fisica_ref,
	cd_tipo_logradouro
from	compl_pessoa_fisica a
where	cd_pessoa_fisica	= cd_pessoa_origem_p
and	ie_tipo_complemento	= 1
and	not exists (	SELECT 1
			from compl_pessoa_fisica x
			where x.cd_pessoa_fisica	= cd_pessoa_destino_p
			  and x.ie_tipo_complemento	= 1);
	
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_end_responsavel ( cd_pessoa_origem_p text, cd_pessoa_destino_p text, nm_usuario_p text) FROM PUBLIC;
