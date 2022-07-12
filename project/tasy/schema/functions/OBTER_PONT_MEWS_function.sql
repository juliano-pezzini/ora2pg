-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_mews ( nr_seq_sinal_vital_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w bigint;


BEGIN

if (nr_seq_sinal_vital_p > 0) then

select max(QT_PONTUACAO)
into STRICT nr_retorno_w
from escala_mews
where nr_seq_sinal_vital = nr_seq_sinal_vital_p;

end if;

return nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_mews ( nr_seq_sinal_vital_p bigint) FROM PUBLIC;

