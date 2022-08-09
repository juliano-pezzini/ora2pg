-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_cruz_evolucao (dt_evolucao_p timestamp, cd_medico_p text, ie_tipo_evolucao_p text, cd_pessoa_fisica_p text, ds_evolucao_p text, cd_evolucao_p INOUT text) AS $body$
DECLARE


cd_evolucao_w	bigint;



BEGIN

select	nextval('evolucao_paciente_seq')
into STRICT	cd_evolucao_w
;

insert	into evolucao_paciente(cd_evolucao,
	dt_evolucao,
	ie_tipo_evolucao,
	cd_pessoa_fisica,
	nm_usuario,
	dt_atualizacao,
	ds_evolucao,
	cd_medico,
	ie_evolucao_clinica)
values (cd_evolucao_w,
	dt_evolucao_p,
	'1',
	cd_pessoa_fisica_p,
	'IMPORTCRUZ',
	clock_timestamp(),
	ds_evolucao_p,
	cd_medico_p,
	'E');

commit;

cd_evolucao_p	:= cd_evolucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_cruz_evolucao (dt_evolucao_p timestamp, cd_medico_p text, ie_tipo_evolucao_p text, cd_pessoa_fisica_p text, ds_evolucao_p text, cd_evolucao_p INOUT text) FROM PUBLIC;
