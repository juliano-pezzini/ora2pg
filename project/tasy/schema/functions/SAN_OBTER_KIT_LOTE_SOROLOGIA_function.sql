-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_kit_lote_sorologia ( nr_Seq_lote_kit_p bigint, dt_referencia_p timestamp, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w	bigint;
ds_kit_w	varchar(255);
dt_vencimento_w	timestamp;
ds_fabricante_w	san_kit_exame.ds_fabricante%type;
			
ds_retorno_w	varchar(255);
			

BEGIN

if (nr_Seq_lote_kit_p IS NOT NULL AND nr_Seq_lote_kit_p::text <> '') then

	select	max(nr_sequencia),
		max(ds_kit),
		max(dt_vigencia_final),
		max(ds_fabricante)
	into STRICT 	nr_Sequencia_w,
		ds_kit_w,
		dt_vencimento_w,
    ds_fabricante_w
	from	san_kit_exame
	where	nr_sequencia = nr_Seq_lote_kit_p
	and	dt_referencia_p between dt_vigencia_ini and dt_vigencia_final;
	
	if (ie_tipo_p = 'C') then
		ds_retorno_w := nr_sequencia_w;
	elsif (ie_tipo_p = 'D') then
		ds_retorno_w := ds_kit_w;
	elsif (ie_tipo_p = 'T') then
		ds_retorno_w := to_char(dt_vencimento_w,'dd/mm/yyyy hh24:mi:ss');
	elsif (ie_tipo_p = 'F') then
		ds_retorno_w := ds_fabricante_w;
	end if;
	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_kit_lote_sorologia ( nr_Seq_lote_kit_p bigint, dt_referencia_p timestamp, ie_tipo_p text) FROM PUBLIC;

