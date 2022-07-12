-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_peso_liq_residuo (nr_seq_equipamento_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_peso_liq_w		double precision := 0;
qt_peso_equipamento_w	double precision := 0;
qt_peso_residuo_item_w	double precision := 0;


BEGIN

select	coalesce(max(qt_peso),0)
into STRICT	qt_peso_equipamento_w
from	man_equipamento
where	nr_sequencia = nr_seq_equipamento_p;

select 	coalesce(max(qt_peso),0)
into STRICT	qt_peso_residuo_item_w
from	setor_residuo_item
where	nr_sequencia = nr_sequencia_p;

if (nr_seq_equipamento_p IS NOT NULL AND nr_seq_equipamento_p::text <> '') then
	begin
	if (qt_peso_residuo_item_w > qt_peso_equipamento_w) then
		qt_peso_liq_w	:= qt_peso_residuo_item_w - qt_peso_equipamento_w;
	elsif (qt_peso_equipamento_w > qt_peso_residuo_item_w) then
		qt_peso_liq_w	:= qt_peso_residuo_item_w;
	end if;
	end;
else
	begin
	qt_peso_liq_w	:= qt_peso_residuo_item_w;
	end;
end if;

return	qt_peso_liq_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_peso_liq_residuo (nr_seq_equipamento_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
