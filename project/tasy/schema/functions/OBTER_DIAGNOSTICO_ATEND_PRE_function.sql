-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_diagnostico_atend_pre ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


dt_diagnostico_w		timestamp;
ds_diagnostico_w		varchar(240);


BEGIN

begin
select	max(dt_diagnostico)
into STRICT 	dt_diagnostico_w
from 	diagnostico_medico a
where	nr_atendimento	= nr_atendimento_p
and	exists (	SELECT	1
			from	diagnostico_doenca x
			where	x.nr_atendimento	= a.nr_atendimento
			and	x.dt_diagnostico	= a.dt_diagnostico
			and	x.ie_tipo_diagnostico = 1);
exception
	when no_data_found then
		dt_diagnostico_w := null;
end;

if (dt_diagnostico_w IS NOT NULL AND dt_diagnostico_w::text <> '') then
	select coalesce(max(ds_doenca_cid),null)
	into STRICT	ds_diagnostico_w
	from 	cid_doenca
	where	cd_doenca_cid = (	SELECT max(cd_doenca)
					from	diagnostico_doenca
					where	nr_atendimento	= nr_atendimento_p
					  and	dt_diagnostico =	dt_diagnostico_w
					  and	ie_tipo_diagnostico = 1);

	if (coalesce(ds_diagnostico_w::text, '') = '') then
		select SUBSTR(ds_diagnostico,1,240)
		into STRICT ds_diagnostico_w
		from diagnostico_medico
		where nr_atendimento = nr_atendimento_p
		  and dt_diagnostico = dt_diagnostico_w;
	end if;

end if;

RETURN ds_diagnostico_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_diagnostico_atend_pre ( nr_atendimento_p bigint) FROM PUBLIC;
