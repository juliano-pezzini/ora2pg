-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_profissional_atend ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

qt_reg_w	bigint;
ds_erro_w	varchar(255);

BEGIN
select	count(*)
into STRICT	qt_reg_w
from	atend_enfermagem_resp
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and		nr_atendimento   = nr_atendimento_p
and		clock_timestamp() between dt_inicio_resp and coalesce(dt_final_resp,clock_timestamp());

if (qt_reg_w = 0) then
	select	count(*)
	into STRICT	qt_reg_w
	from	atend_profissional
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and		nr_atendimento   = nr_atendimento_p
	and		dt_inicio_vigencia < clock_timestamp();
	if (qt_reg_w = 0) then
		ds_erro_w := wheb_mensagem_pck.get_texto(278152);
	else
		ds_erro_w := null;
	end if;
else
	ds_erro_w := null;
end if;

ds_erro_p := ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_profissional_atend ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

