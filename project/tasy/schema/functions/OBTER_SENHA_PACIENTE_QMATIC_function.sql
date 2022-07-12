-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_senha_paciente_qmatic ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
nr_seq_pac_senha_fila_w	bigint;
ds_retorno_w		bigint;
				

BEGIN 
 
if (coalesce(nr_atendimento_p,0) > 0) then 
 
	select	coalesce(max(nr_seq_pac_senha_fila),0) 
	into STRICT	nr_seq_pac_senha_fila_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
	 
	if (nr_seq_pac_senha_fila_w > 0) then 
	 
		select	cd_senha_gerada 
		into STRICT	ds_retorno_w 
		from	paciente_senha_fila 
		where	nr_sequencia	= nr_seq_pac_senha_fila_w;			
	end if;
	 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_senha_paciente_qmatic ( nr_atendimento_p bigint) FROM PUBLIC;

