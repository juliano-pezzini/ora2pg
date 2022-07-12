-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_prop_online_agenda_pck.obter_se_feriado ( dt_referencia_p timestamp, cd_estabelecimento_p pls_solic_prop_on_agenda.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE

	
	ie_feriado_w		varchar(1);
	
	
BEGIN
	
	select	coalesce(max('S'), 'N')
	into STRICT	ie_feriado_w
	from 	feriado
	where 	dt_feriado		= dt_referencia_p
	and	cd_estabelecimento	= cd_estabelecimento_p;
	
	return	ie_feriado_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_prop_online_agenda_pck.obter_se_feriado ( dt_referencia_p timestamp, cd_estabelecimento_p pls_solic_prop_on_agenda.cd_estabelecimento%type) FROM PUBLIC;