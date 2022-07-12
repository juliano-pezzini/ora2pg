-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_os_complaint_duplic ( nr_seq_ordem_serv_p bigint, nr_versao_cliente_p text, nr_customer_requirement_p bigint ) RETURNS varchar AS $body$
DECLARE

	os_duplicadas_w varchar(1000) := null;

BEGIN
	if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') and man_obter_se_md(nr_customer_requirement_p) = 'S' then
		select 	rtrim(xmlagg(XMLELEMENT(name e, a.nr_sequencia || ', ') order by a.nr_sequencia).extract('//text()'), ', ')
		into STRICT 	os_duplicadas_w
		from 	man_ordem_servico a
		where 	a.ie_status_ordem 		<> '3'
		and 	a.nr_sequencia 		<> nr_seq_ordem_serv_p
		and 	a.nr_versao_cliente_abertura 	= nr_versao_cliente_p
		and 	a.nr_customer_requirement 	= nr_customer_requirement_p  LIMIT 99;
	end if;
	
	return os_duplicadas_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_os_complaint_duplic ( nr_seq_ordem_serv_p bigint, nr_versao_cliente_p text, nr_customer_requirement_p bigint ) FROM PUBLIC;
