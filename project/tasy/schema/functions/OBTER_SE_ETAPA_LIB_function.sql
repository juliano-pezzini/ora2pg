-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_etapa_lib ( nr_seq_etapa_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

SELECT	coalesce(max(ie_liberado),'N')
into STRICT	ds_retorno_w
FROM	etapa_checkup_lib_dia
where	nr_seq_etapa = nr_seq_etapa_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_etapa_lib ( nr_seq_etapa_p bigint) FROM PUBLIC;

