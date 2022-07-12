-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_desc_periodo (nr_seq_indicador_p bigint) RETURNS varchar AS $body$
DECLARE


ds_periodo_w			varchar(20);

BEGIN

select	substr(obter_valor_dominio(2303, coalesce(ie_periodo,'M')),1,20)
into STRICT	ds_periodo_w
from	bsc_indicador
where	nr_sequencia = nr_seq_indicador_p;

return ds_periodo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_desc_periodo (nr_seq_indicador_p bigint) FROM PUBLIC;

