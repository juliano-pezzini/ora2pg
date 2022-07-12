-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_diag_oftalmo ( nr_seq_diagnostico_p bigint) RETURNS varchar AS $body$
DECLARE


ds_diagnostico_w	varchar(80);


BEGIN
if (nr_seq_diagnostico_p IS NOT NULL AND nr_seq_diagnostico_p::text <> '') then
	begin
	select	max(substr(ds_diagnostico,1,80))
	into STRICT	ds_diagnostico_w
	from	oft_tipo_diagnostico
	where	nr_sequencia = nr_seq_diagnostico_p;
	end;
end if;

return substr(ds_diagnostico_w,1,80);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_diag_oftalmo ( nr_seq_diagnostico_p bigint) FROM PUBLIC;
