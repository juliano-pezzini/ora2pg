-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_hist_unidade ( nr_seq_unidade_p bigint, ie_status_unidade_p text) RETURNS varchar AS $body$
DECLARE



dt_historico_w		timestamp;
ie_status_unidade_w	varchar(1);
ds_retorno_w		varchar(1000);
nr_Seq_interd_w		bigint;


BEGIN

select	max(ie_status_unidade)
into STRICT	ie_status_unidade_w
from	unidade_atendimento
where	nr_seq_interno	= nr_seq_unidade_p;


if (nr_seq_unidade_p IS NOT NULL AND nr_seq_unidade_p::text <> '') and (ie_status_unidade_w = 'I') then

	select 	max(NR_SEQUENCIA)
	into STRICT	nr_Seq_interd_w
	from	unidade_atend_hist
	where	nr_seq_unidade		= nr_seq_unidade_p
	and	ie_status_unidade	= ie_status_unidade_p;


	select	max(dt_historico)
	into STRICT	dt_historico_w
	from	unidade_atend_hist
	where	nr_seq_unidade		= nr_seq_unidade_p
	and	ie_status_unidade	= ie_status_unidade_p
	and	nr_sequencia		= nr_Seq_interd_w;

	ds_retorno_w := to_char(dt_historico_w,'dd/mm/yyyy hh24:mi:ss');
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_hist_unidade ( nr_seq_unidade_p bigint, ie_status_unidade_p text) FROM PUBLIC;

