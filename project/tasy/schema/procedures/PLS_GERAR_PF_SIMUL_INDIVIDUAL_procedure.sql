-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_pf_simul_individual ( nm_pessoa_fisica_p text, dt_nascimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, cd_pessoa_fisica_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);


BEGIN

select	nextval('pessoa_fisica_seq')
into STRICT	cd_pessoa_fisica_w
;

insert	into	pessoa_fisica(	cd_pessoa_fisica, nm_pessoa_fisica, dt_nascimento,
		ie_tipo_pessoa, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec)
	values (	cd_pessoa_fisica_w, nm_pessoa_fisica_p, dt_nascimento_p,
		2, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p);



cd_pessoa_fisica_p	:= cd_pessoa_fisica_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pf_simul_individual ( nm_pessoa_fisica_p text, dt_nascimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, cd_pessoa_fisica_p INOUT text) FROM PUBLIC;

