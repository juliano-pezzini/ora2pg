-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_estornar_baixa_selec (nr_titulo_p bigint, nr_seq_baixa_p bigint, cd_tipo_baixa_p bigint, qt_registros_p INOUT bigint, ie_estornar_p INOUT text) AS $body$
DECLARE

qt_registros_w		bigint;
ie_estornar_w		varchar(1);

BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_baixa_p IS NOT NULL AND nr_seq_baixa_p::text <> '') then
	begin
	select 	count(*)
	into STRICT	qt_registros_w
	from    	titulo_pagar_baixa a
	where   	a.nr_titulo = nr_titulo_p
	and     	a.nr_seq_baixa_origem = nr_seq_baixa_p;
	end;
end if;
if (cd_tipo_baixa_p IS NOT NULL AND cd_tipo_baixa_p::text <> '') then
	begin
	select  	coalesce(max(a.ie_estornar),'S')
	into STRICT	ie_estornar_w
	from   	tipo_baixa_cpa a
	where  	a.cd_tipo_baixa   = cd_tipo_baixa_p;
	end;
end if;
qt_registros_p 	:= qt_registros_w;
ie_estornar_p	:= ie_estornar_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_estornar_baixa_selec (nr_titulo_p bigint, nr_seq_baixa_p bigint, cd_tipo_baixa_p bigint, qt_registros_p INOUT bigint, ie_estornar_p INOUT text) FROM PUBLIC;
