-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_lote_pag_duplicado ( dt_mes_competencia_p timestamp, nr_seq_periodo_p bigint, nr_seq_lote_pag_p INOUT text) AS $body$
DECLARE


nr_seq_lote_pag_w	varchar(10)	:= null;


BEGIN
if (nr_seq_periodo_p IS NOT NULL AND nr_seq_periodo_p::text <> '') and (dt_mes_competencia_p IS NOT NULL AND dt_mes_competencia_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_lote_pag_w
	from	pls_lote_pagamento a
	where	trunc(a.dt_mes_competencia,'month')	= trunc(dt_mes_competencia_p,'month')
	and	a.nr_seq_periodo			= nr_seq_periodo_p;

	nr_seq_lote_pag_p	:= nr_seq_lote_pag_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_lote_pag_duplicado ( dt_mes_competencia_p timestamp, nr_seq_periodo_p bigint, nr_seq_lote_pag_p INOUT text) FROM PUBLIC;

