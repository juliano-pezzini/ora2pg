-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_modelo_manutencao (nr_seq_modelo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(255);


BEGIN

if (nr_seq_modelo_p IS NOT NULL AND nr_seq_modelo_p::text <> '') then
begin

	select	substr(ds_modelo,1,255)
	into STRICT	ds_retorno_w
	from	hd_modelo_maquina
	where	nr_sequencia = nr_seq_modelo_p;

end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_modelo_manutencao (nr_seq_modelo_p bigint) FROM PUBLIC;
