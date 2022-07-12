-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atendimento_cih (nr_ficha_ocorrencia_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		bigint;


BEGIN

if (nr_ficha_ocorrencia_p IS NOT NULL AND nr_ficha_ocorrencia_p::text <> '') then

select	max(nr_atendimento)
into STRICT	ds_retorno_w
from	cih_ficha_ocorrencia
where	nr_ficha_ocorrencia = nr_ficha_ocorrencia_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atendimento_cih (nr_ficha_ocorrencia_p bigint) FROM PUBLIC;

