-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION apresentar_item_res_grafico ( nr_seq_item_p bigint, qt_resultado_p text) RETURNS varchar AS $body$
DECLARE


ie_grafico_res_w	varchar(1) := 'S';



BEGIN

begin
	select	coalesce(ie_grafico_res,'S')
	into STRICT	ie_grafico_res_w
	from	med_item_avaliar_res
	where	nr_seq_item	= nr_seq_item_p
	and	nr_seq_res	= qt_resultado_p;

exception
when others then
	ie_grafico_res_w	:= 'S';
end;

return	ie_grafico_res_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION apresentar_item_res_grafico ( nr_seq_item_p bigint, qt_resultado_p text) FROM PUBLIC;
