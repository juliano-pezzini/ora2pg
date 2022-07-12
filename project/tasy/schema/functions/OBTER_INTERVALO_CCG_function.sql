-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_intervalo_ccg (nr_seq_prot_glic_p bigint) RETURNS varchar AS $body$
DECLARE


cd_intervalo_w	varchar(7);


BEGIN
if (nr_seq_prot_glic_p IS NOT NULL AND nr_seq_prot_glic_p::text <> '') then
	select	max(cd_intervalo)
	into STRICT	cd_intervalo_w
	from	pep_protocolo_glicemia
	where	nr_sequencia = nr_seq_prot_glic_p;
end if;

return cd_intervalo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_intervalo_ccg (nr_seq_prot_glic_p bigint) FROM PUBLIC;

