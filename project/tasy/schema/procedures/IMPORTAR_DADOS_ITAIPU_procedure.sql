-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_dados_itaipu (cd_usuario_convenio_p text, nm_pessoa_fisica_p text, dt_nascimento_p text, dt_admissao_p text, dt_desligamento_p text) AS $body$
DECLARE


dt_nascimento_w		varchar(10);
dt_admissao_w		varchar(10);
dt_desligamento_w	varchar(10);


BEGIN

if (dt_nascimento_p = '  /  /') then
   dt_nascimento_w 	:= '';
else
   dt_nascimento_w 	:= dt_nascimento_p;
end if;

if (dt_admissao_p = '  /  /') then
   dt_admissao_w 	:= '';
else
   dt_admissao_w 	:= dt_admissao_p;
end if;

if (dt_desligamento_p = '  /  /') then
   dt_desligamento_w 	:= '';
else
   dt_desligamento_w 	:= dt_desligamento_p;
end if;


insert into w_usuario_convenio(
	cd_usuario_convenio,
	nm_pessoa_fisica,
	dt_nascimento,
	dt_admissao,
	dt_desligamento)
values (
	cd_usuario_convenio_p,
	nm_pessoa_fisica_p,
	to_date(dt_nascimento_w,'dd/mm/yyyy'),
	to_date(dt_admissao_w,'dd/mm/yyyy'),
	to_date(dt_desligamento_w,'dd/mm/yyyy'));

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_dados_itaipu (cd_usuario_convenio_p text, nm_pessoa_fisica_p text, dt_nascimento_p text, dt_admissao_p text, dt_desligamento_p text) FROM PUBLIC;
