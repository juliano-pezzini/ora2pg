-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_ata_confir_partic ( nr_seq_ata_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
qt_partic_ata_w			bigint;
qt_partic_ciente_ata_w		bigint;


BEGIN


select	count(*)
into STRICT	qt_partic_ata_w
from	proj_ata_participante
where	(cd_pessoa_participante IS NOT NULL AND cd_pessoa_participante::text <> '')
and	nr_seq_ata = nr_seq_ata_p;

if (qt_partic_ata_w > 0) then
	begin
	select	count(*)
	into STRICT	qt_partic_ciente_ata_w
	from	proj_ata_participante
	where	(cd_pessoa_participante IS NOT NULL AND cd_pessoa_participante::text <> '')
	and	(dt_ciente_ata IS NOT NULL AND dt_ciente_ata::text <> '')
	and	nr_seq_ata = nr_seq_ata_p;

	if (qt_partic_ata_w = qt_partic_ciente_ata_w) then
		ds_retorno_w := 'S';
	elsif (qt_partic_ata_w > qt_partic_ciente_ata_w) and (qt_partic_ciente_ata_w > 0) then
		ds_retorno_w := 'P';
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_ata_confir_partic ( nr_seq_ata_p bigint) FROM PUBLIC;

