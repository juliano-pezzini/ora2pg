-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cirurgia_prescricao ( nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE

nr_cirurgia_w	bigint:=0;

BEGIN

if (coalesce(nr_prescricao_p,0) > 0) then
	select	coalesce(max(nr_cirurgia),0)
	into STRICT	nr_cirurgia_w
	from 	cirurgia
	where	nr_prescricao = nr_prescricao_p;
end if;

return	nr_cirurgia_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cirurgia_prescricao ( nr_prescricao_p bigint) FROM PUBLIC;
