-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_cliente_valor_prop_parc ( nr_seq_prop_item_p bigint, vl_parcela_total_p INOUT bigint, ie_total_p INOUT text) AS $body$
DECLARE


vl_total_item_w		double precision;
vl_parcela_total_w	double precision;
vl_total_parc_w		double precision;
ie_total_w		varchar(1);


BEGIN

vl_parcela_total_w	:= 0;
ie_total_w		:= 'N';
if (nr_seq_prop_item_p IS NOT NULL AND nr_seq_prop_item_p::text <> '') then
	begin
	select	coalesce(vl_item,0)
	into STRICT	vl_total_item_w
	from	com_cliente_prop_item
	where	nr_sequencia = nr_seq_prop_item_p;

	if (vl_total_item_w > 0) then
		begin
		select	coalesce(vl_total_item_w,0) - sum(coalesce(vl_parcela,0)),
			sum(coalesce(vl_parcela,0))
		into STRICT	vl_parcela_total_w,
			vl_total_parc_w
		from	com_cliente_prop_parc
		where	nr_seq_prop_item = nr_seq_prop_item_p;

		if	(vl_parcela_total_w = 0 AND vl_total_parc_w = vl_total_item_w)then
			begin
			ie_total_w := 'S';
			end;
		end if;
		end;
	end if;
	end;
end if;
vl_parcela_total_p	:= vl_parcela_total_w;
ie_total_p		:= ie_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_cliente_valor_prop_parc ( nr_seq_prop_item_p bigint, vl_parcela_total_p INOUT bigint, ie_total_p INOUT text) FROM PUBLIC;
