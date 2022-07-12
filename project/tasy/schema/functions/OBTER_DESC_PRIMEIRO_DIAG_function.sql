-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_primeiro_diag (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_primeiro_diag_w varchar(255);
dt_primeiro_diag_w timestamp;
--procedure utilizada na integracao CROSS
BEGIN


select 	min(dt_diagnostico)
into STRICT	dt_primeiro_diag_w
from	diagnostico_medico
where	nr_atendimento = nr_atendimento_p;

if (dt_primeiro_diag_w IS NOT NULL AND dt_primeiro_diag_w::text <> '') then
	select	substr(ds_diagnostico,1,255)
	into STRICT	ds_primeiro_diag_w
	from	diagnostico_medico
	where	dt_diagnostico = dt_primeiro_diag_w
	and	nr_atendimento = nr_atendimento_p;
end if;


return ds_primeiro_diag_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_primeiro_diag (nr_atendimento_p bigint) FROM PUBLIC;

