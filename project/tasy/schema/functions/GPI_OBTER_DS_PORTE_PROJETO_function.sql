-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_ds_porte_projeto (nr_seq_porte bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);

BEGIN

select 	substr(ds_porte_projeto,1,255)
into STRICT	ds_retorno_w
from	gpi_porte_projeto
where	nr_sequencia = nr_seq_porte;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpi_obter_ds_porte_projeto (nr_seq_porte bigint) FROM PUBLIC;

