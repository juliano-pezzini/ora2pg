-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_obriga_lado_exame ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ie_obriga_w	varchar(1) := 'N';

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	select	coalesce(max(ie_lado),'N')
	into STRICT	ie_obriga_w
	from	med_exame_padrao
	where	nr_sequencia = nr_sequencia_p;
	end;
end if;

return	ie_obriga_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_obriga_lado_exame ( nr_sequencia_p bigint) FROM PUBLIC;

