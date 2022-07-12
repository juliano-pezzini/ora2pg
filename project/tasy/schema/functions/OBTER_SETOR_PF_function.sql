-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_pf ( cd_pessoa_fisica_p text ) RETURNS varchar AS $body$
DECLARE

			 
			 
ds_setor_atendimento_w		varchar(200);
			

BEGIN 
	select	max(b.ds_setor_atendimento) 
	into STRICT	ds_setor_atendimento_w 
	from	setor_atendimento b, 
		atendimento_paciente a 
	where	b.cd_setor_atendimento = obter_setor_atendimento(a.nr_atendimento) 
	and	a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	a.nr_atendimento = (	SELECT 	max(nr_atendimento) 
					from	atendimento_paciente c 
					where	c.cd_pessoa_fisica = cd_pessoa_fisica_p);
 
Return ds_setor_atendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_pf ( cd_pessoa_fisica_p text ) FROM PUBLIC;

