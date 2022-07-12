-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_nivel_etapa ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w			bigint	:= nr_sequencia_p;
nr_seq_superior_w			bigint;
qt_nivel_w			bigint	:= 1;


BEGIN


select	max(nr_seq_superior)
into STRICT	nr_seq_superior_w
from	gpi_cron_etapa
where	nr_sequencia		= nr_sequencia_w;

while(nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') loop
	begin
	qt_nivel_w		:= qt_nivel_w + 1;
	nr_sequencia_w		:= nr_seq_superior_w;

	select	max(nr_seq_superior)
	into STRICT	nr_seq_superior_w
	from	gpi_cron_etapa
	where	nr_sequencia	= nr_sequencia_w;

	end;
end loop;

return	qt_nivel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpi_obter_nivel_etapa ( nr_sequencia_p bigint) FROM PUBLIC;
