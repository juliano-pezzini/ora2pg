-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_motivo_cancel ( nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);


BEGIN

select	coalesce(max(ds_motivo_cancelamento),'')
into STRICT	ds_retorno_w
from	pls_motivo_cancelamento
where	nr_sequencia	= nr_seq_motivo_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_motivo_cancel ( nr_seq_motivo_p bigint) FROM PUBLIC;

