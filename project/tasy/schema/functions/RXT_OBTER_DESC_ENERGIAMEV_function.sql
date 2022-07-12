-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_desc_energiamev ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);


BEGIN

SELECT	MAX(b.qt_energia_radiacao)
INTO STRICT	ds_retorno_w
FROM	rxt_campo a, rxt_energia_equip b
WHERE   a.nr_seq_energia_rad = b.nr_sequencia
AND a.nr_sequencia	= nr_sequencia_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_desc_energiamev ( nr_sequencia_p bigint) FROM PUBLIC;

