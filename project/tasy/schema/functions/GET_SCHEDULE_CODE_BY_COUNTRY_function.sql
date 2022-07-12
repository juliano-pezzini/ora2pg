-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_schedule_code_by_country ( ie_tipo_agenda_p text) RETURNS bigint AS $body$
DECLARE


cd_wcp_w			bigint;
cd_pais_w			bigint;


BEGIN
if (ie_tipo_agenda_p = 'C') then
	cd_wcp_w	:= 404624;
elsif (ie_tipo_agenda_p = 'E') then
	cd_wcp_w	:= 404810;
elsif (ie_tipo_agenda_p = 'S') then
	cd_wcp_w	:= 404832;
elsif (ie_tipo_agenda_p = 'CH') then
	cd_wcp_w	:= 404854;
end if;

cd_pais_w 	:= obter_nr_seq_locale(wheb_usuario_pck.get_nm_usuario);

if (cd_pais_w > 1) then
	select	nr_seq_objeto_ref
	into STRICT	cd_wcp_w
	from	dic_objeto_pais
	where	nr_seq_objeto	= cd_wcp_w
	and	cd_pais		= cd_pais_w;
end if;

return cd_wcp_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_schedule_code_by_country ( ie_tipo_agenda_p text) FROM PUBLIC;

