-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_local_acha_per (nr_seq_localizacao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_localizacao_w	varchar(255);

BEGIN

if (nr_seq_localizacao_p > 0) then

	select	substr(ds_local_armazenamento,1,255)
	into STRICT	ds_localizacao_w
	from	local_achado_perdido
	where	nr_sequencia = nr_seq_localizacao_p;
end if;

return	ds_localizacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_local_acha_per (nr_seq_localizacao_p bigint) FROM PUBLIC;
