-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agecons_cons_se_dia_feriado ( dt_agenda_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


ie_feriado_w	integer;


BEGIN

select	coalesce(max(Obter_Se_Feriado(cd_estabelecimento_p, dt_agenda_p)), 0)
into STRICT	ie_feriado_w
;

if (ie_feriado_w > 0) then
	ds_retorno_p := 'S';
else
	ds_retorno_p := 'N';
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agecons_cons_se_dia_feriado ( dt_agenda_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
