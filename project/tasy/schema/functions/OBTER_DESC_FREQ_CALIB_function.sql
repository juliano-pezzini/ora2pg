-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_freq_calib (nr_seq_frequencia_p text) RETURNS varchar AS $body$
DECLARE



retorno_w	varchar(255) := '';


BEGIN

if (nr_seq_frequencia_p > 0) then
	select	ds_frequencia
	into STRICT	retorno_w
	from	man_freq_calib
	where	nr_sequencia = nr_seq_frequencia_p;
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_freq_calib (nr_seq_frequencia_p text) FROM PUBLIC;

