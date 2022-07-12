-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_evento_sol (nr_seq_evento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(240);
ie_evento_w	smallint;
ds_infusao_w	varchar(22);
ds_evento_w	varchar(214);


BEGIN
if (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') then
	select	max(ie_alteracao) ie_evento,
		max(substr(obter_valor_dominio(1883,ie_forma_infusao),1,22)) ds_forma_infusao,
		max(substr(obter_valor_dominio(1662,ie_alteracao),1,214)) ds_evento
	into STRICT	ie_evento_w,
		ds_infusao_w,
		ds_evento_w
	from	prescr_solucao_evento
	where	nr_sequencia = nr_seq_evento_p;

	if (ie_evento_w = 1) and (ds_infusao_w IS NOT NULL AND ds_infusao_w::text <> '') then
		ds_retorno_w := ds_evento_w || ' (' || ds_infusao_w || ') ';
	else
		ds_retorno_w := ds_evento_w;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_evento_sol (nr_seq_evento_p bigint) FROM PUBLIC;

