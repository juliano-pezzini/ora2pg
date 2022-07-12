-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_guia_conta_heg ( nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_autorizacao_w	varchar(20)	:= '';
nr_atendimento_w	bigint;


BEGIN 
 
select	coalesce(max(nr_atendimento),'') 
into STRICT	nr_atendimento_w 
from	conta_paciente 
where	nr_interno_conta	= nr_interno_conta_p;
 
select	coalesce(max(a.cd_autorizacao),'') 
into STRICT	cd_autorizacao_w 
from 	autorizacao_convenio a 
where	exists (SELECT	1 
		from 	procedimento_Paciente p 
		where	p.cd_procedimento = a.cd_procedimento_principal 
		and 	p.ie_origem_proced = a.ie_origem_proced 
		and 	p.nr_interno_conta = nr_interno_conta_p) 
and a.nr_Atendimento = nr_atendimento_w;
 
Return	cd_autorizacao_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_guia_conta_heg ( nr_interno_conta_p bigint) FROM PUBLIC;

