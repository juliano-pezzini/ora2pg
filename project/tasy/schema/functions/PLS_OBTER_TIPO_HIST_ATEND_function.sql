-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_hist_atend ( nr_seq_tipo_hist_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(150);


BEGIN

select	ds_tipo_historico
into STRICT	ds_retorno_w
from	pls_tipo_historico_atend
where	nr_sequencia = nr_seq_tipo_hist_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_hist_atend ( nr_seq_tipo_hist_p bigint) FROM PUBLIC;

