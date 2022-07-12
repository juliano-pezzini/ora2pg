-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_status_resp ( nr_seq_ordem_serv_p bigint) RETURNS varchar AS $body$
DECLARE


ds_solucao_w		varchar(50);
qt_min_resp_w		bigint;

BEGIN

qt_min_resp_w := sla_dashboard_pck.obter_min_solucao(nr_seq_ordem_serv_p);

if (qt_min_resp_w < 0 ) then
	ds_solucao_w :=	'Breached';
elsif (qt_min_resp_w < 390) then
	ds_solucao_w :=	'Critical';
elsif (qt_min_resp_w >= 390 ) and (qt_min_resp_w <= 1440 ) then
	ds_solucao_w :=	'Warning';
elsif (qt_min_resp_w > 1440) then
	ds_solucao_w :=	'Good';
end if;

return	ds_solucao_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_status_resp ( nr_seq_ordem_serv_p bigint) FROM PUBLIC;