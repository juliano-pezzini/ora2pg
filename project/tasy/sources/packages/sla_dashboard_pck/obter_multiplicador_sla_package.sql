-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_multiplicador_sla ( ie_tipo_contrato text) RETURNS bigint AS $body$
DECLARE

				
qt_retorno_w	varchar(10);

BEGIN
		/* 1 Contrato com multa*/


	if (ie_tipo_contrato	= 'CSFP') then 
		qt_retorno_w := 2;
		/* Customer Start Finish with Penalty'*/


		
		/* 1 Contrato com multa*/


	elsif (ie_tipo_contrato	= 'COSP') then
		qt_retorno_w := 1;
		/* Customer Only Finish with Penalty'*/


		
		/* 2 Contrato sem multa*/


	elsif (ie_tipo_contrato = 'CSFNP') then
		qt_retorno_w := 2;
		/* Customer Start Finish No Penalty'*/


		
		/* 2 Contrato sem multa*/


	elsif (ie_tipo_contrato	= 'COSNP') then
		qt_retorno_w :=  1;
		/* Customer Only Start No Penalty'*/


		
		/*  3 Sem Contrato */


	elsif (ie_tipo_contrato	= 'PSFNP') then
		qt_retorno_w := 2;
		/* Philips Start Finish No Penalty'*/


	elsif (ie_tipo_contrato	= 'NCSFCC') then
		qt_retorno_w := 1;
		/* Philips Start Finish No Penalty'*/


	elsif (ie_tipo_contrato	= 'CSPFC') then
		qt_retorno_w := 1;
		/* Philips Start Finish No Penalty'*/


	end if;
	
	return qt_retorno_w;	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_multiplicador_sla ( ie_tipo_contrato text) FROM PUBLIC;
