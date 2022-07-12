-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_medic_agenda (nr_seq_medic_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);
ds_medicamento_w	varchar(100);


BEGIN
if (nr_seq_medic_p IS NOT NULL AND nr_seq_medic_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then

	select	max(ds_medicamento)
	into STRICT	ds_medicamento_w
	from	agenda_medic
	where	nr_sequencia = nr_seq_medic_p;

	ds_retorno_w := ds_medicamento_w;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_medic_agenda (nr_seq_medic_p bigint, ie_opcao_p text) FROM PUBLIC;
