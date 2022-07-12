-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_con_ativa_ipasgo ( cd_inconsistencia_p ipasgo_consistencia.cd_inconsistencia%type) RETURNS boolean AS $body$
DECLARE


ie_ativa_w		boolean := false;
nr_sequencia_w		ipasgo_consistencia.nr_sequencia%type := 0;
ie_situacao_w		ipasgo_consistencia.ie_situacao%type := 'N';


BEGIN

begin
select	nr_sequencia
into STRICT	nr_sequencia_w
from	ipasgo_consistencia
where	cd_inconsistencia = cd_inconsistencia_p  LIMIT 1;
exception
when others then
	nr_sequencia_w := 0;
end;

if (nr_sequencia_w > 0) then
	begin

	select	ie_situacao
	into STRICT	ie_situacao_w
	from	ipasgo_consistencia
	where	nr_sequencia = nr_sequencia_w;

	if (ie_situacao_w = 'A') then
		ie_ativa_w := true;
	else
		ie_ativa_w := false;
	end if;
	end;
end if;

return	ie_ativa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_con_ativa_ipasgo ( cd_inconsistencia_p ipasgo_consistencia.cd_inconsistencia%type) FROM PUBLIC;

