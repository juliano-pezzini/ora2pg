-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_obter_se_existe_cultura ( nr_ficha_ocorrencia_p bigint, nr_seq_cultura_p bigint) RETURNS bigint AS $body$
DECLARE

qt_retorno_w	bigint;

BEGIN
if (nr_ficha_ocorrencia_p IS NOT NULL AND nr_ficha_ocorrencia_p::text <> '') and (nr_seq_cultura_p IS NOT NULL AND nr_seq_cultura_p::text <> '') then
	begin
	select	count(*)
	into STRICT	qt_retorno_w
	from   	CIH_CULTURA_MEDIC
	where  	nr_ficha_ocorrencia = nr_ficha_ocorrencia_p
	and	nr_seq_cultura = nr_seq_cultura_p;
	end;
end if;
return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_obter_se_existe_cultura ( nr_ficha_ocorrencia_p bigint, nr_seq_cultura_p bigint) FROM PUBLIC;
