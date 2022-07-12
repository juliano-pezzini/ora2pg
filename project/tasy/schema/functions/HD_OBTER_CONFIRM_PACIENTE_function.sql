-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_confirm_paciente ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_status_w  varchar(10);


BEGIN

begin
select max(ie_status)
into STRICT ie_status_w
from hd_status_recepcao
where cd_pessoa_fisica = cd_pessoa_fisica_p
and ie_situacao = 'A'
and	trunc(dt_status) = trunc(clock_timestamp());
exception
 when others then
 ie_status_w  := 'N';
end;

return ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_confirm_paciente ( cd_pessoa_fisica_p text) FROM PUBLIC;
