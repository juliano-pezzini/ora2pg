-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_proced_princ ( nr_atendimento_p bigint, ie_opcao_p bigint default 1) RETURNS bigint AS $body$
DECLARE

 
ie_tipo_atendimento_w			bigint;
cd_procedimento_w				bigint;
ie_origem_proced_w				bigint;

/* ie_opcao_p: 
 
	1 (ou nulo)- Procedimento 
	2 - Origem Proced 
 
*/
 
 

BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	select	ie_tipo_atendimento 
	into STRICT	ie_tipo_atendimento_w 
	from	atendimento_paciente 
	where	nr_atendimento		= nr_atendimento_p;
 
	SELECT * FROM obter_proc_princ_interno(nr_atendimento_p, ie_tipo_atendimento_w, cd_procedimento_w, ie_origem_proced_w, 0) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
 
end if;
if (ie_opcao_p = 1) then 
	return cd_procedimento_w;
elsif (ie_opcao_p = 2) then 
	return ie_origem_proced_w;
else 
	return cd_procedimento_w;
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_proced_princ ( nr_atendimento_p bigint, ie_opcao_p bigint default 1) FROM PUBLIC;

