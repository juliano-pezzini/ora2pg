-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_reg_baixa_abatimento (nr_titulo_p bigint, nr_seq_baixa_p bigint, qt_registros_receberliq_p INOUT bigint, qt_registros_pagarbaixa_p INOUT bigint) AS $body$
DECLARE

qt_registros_receberliq_w	bigint;
qt_registros_pagarbaixa_w	bigint;

BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_baixa_p IS NOT NULL AND nr_seq_baixa_p::text <> '') then 
	begin 
	select	count(*) 
	into STRICT	qt_registros_receberliq_w 
	from 	titulo_receber_liq a 
	where  	a.nr_tit_pagar 		= nr_titulo_p 
	and   	a.nr_seq_baixa_pagar  	= nr_seq_baixa_p;
	select 	count(*) 
	into STRICT	qt_registros_pagarbaixa_w 
	from  	titulo_pagar_baixa a 
	where  	a.nr_titulo       		= nr_titulo_p 
	and   	a.nr_seq_baixa_origem  	= nr_seq_baixa_p;
	end;
end if;
qt_registros_receberliq_p 	:= qt_registros_receberliq_w;
qt_registros_pagarbaixa_p 	:= qt_registros_pagarbaixa_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_reg_baixa_abatimento (nr_titulo_p bigint, nr_seq_baixa_p bigint, qt_registros_receberliq_p INOUT bigint, qt_registros_pagarbaixa_p INOUT bigint) FROM PUBLIC;

