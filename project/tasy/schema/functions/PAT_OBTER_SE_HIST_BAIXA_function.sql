-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_se_hist_baixa (nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(5);
ds_valor_w		varchar(5);


BEGIN

ds_retorno_w := 'N';

select	max(ie_valor)
into STRICT	ds_valor_W
from	pat_tipo_historico
where	nr_sequencia	= nr_seq_tipo_p
and	ie_transferencia= 'N';

if (coalesce(ds_valor_w,'x') = 'B') then
	ds_retorno_w := 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_se_hist_baixa (nr_seq_tipo_p bigint) FROM PUBLIC;

