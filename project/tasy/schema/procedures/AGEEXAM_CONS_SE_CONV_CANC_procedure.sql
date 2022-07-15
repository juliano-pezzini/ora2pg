-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageexam_cons_se_conv_canc ( cd_convenio_p bigint, dt_agenda_p timestamp) AS $body$
DECLARE



dt_cancelamento_w	timestamp;
dt_agenda_w		timestamp;
ds_retorno_w		varchar(1) := 'N';


BEGIN
dt_agenda_w	:= trunc(dt_agenda_p);

if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
	select	trunc(a.dt_cancelamento)
	into STRICT	dt_cancelamento_w
	from	convenio a
	where	a.cd_convenio	= cd_convenio_p;

if (dt_cancelamento_w IS NOT NULL AND dt_cancelamento_w::text <> '') and (dt_agenda_w >= dt_cancelamento_w) then
	ds_retorno_w	:= 'S';

end if;

if (ds_retorno_w = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1001155);
end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageexam_cons_se_conv_canc ( cd_convenio_p bigint, dt_agenda_p timestamp) FROM PUBLIC;

