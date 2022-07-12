-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_rp_classif_tratamento (nr_seq_classif_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);


BEGIN

select	ds_classificacao
into STRICT	ds_retorno_w
from	rp_classif_tratamento
where	nr_sequencia = nr_seq_classif_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_rp_classif_tratamento (nr_seq_classif_p bigint) FROM PUBLIC;

