-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hl7_oru_quati_obter_seq_obx ( nr_seq_prescricao_p bigint, nr_seq_resultado_p bigint, nr_seq_result_item_p bigint) RETURNS bigint AS $body$
DECLARE


ds_restorno_w	bigint	:= 0;


BEGIN

if (nr_seq_resultado_p IS NOT NULL AND nr_seq_resultado_p::text <> '') and (nr_seq_result_item_p IS NOT NULL AND nr_seq_result_item_p::text <> '') then

	select	coalesce(max(id),-1) id
	into STRICT	ds_restorno_w
	from (SELECT	nr_seq_result_item,
			nr_seq_resultado,
			row_number() OVER () - 1 id,
			a.ie_tipo
		from  	hl7_dixtar_quati_obx_v a
		where  	a.nr_seq_resultado = nr_seq_resultado_p
		and	a.nr_seq_prescr = nr_seq_prescricao_p) a
	where	a.ie_tipo = 1
	and	a.nr_seq_result_item = nr_seq_result_item_p
	and	a.nr_seq_resultado = nr_seq_resultado_p;

end if;

return	ds_restorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hl7_oru_quati_obter_seq_obx ( nr_seq_prescricao_p bigint, nr_seq_resultado_p bigint, nr_seq_result_item_p bigint) FROM PUBLIC;

