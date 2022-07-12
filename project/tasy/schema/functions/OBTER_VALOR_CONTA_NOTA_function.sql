-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_conta_nota (nr_sequencia_p bigint, cd_procedimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
			 
ds_retorno_w		double precision;	
 

BEGIN 
 
 
SELECT	DISTINCT 
	a.vl_conta 
INTO STRICT	ds_retorno_w				 
FROM	conta_paciente_desc_item a, 
	Conta_Paciente_Desconto b, 
	conta_paciente c, 
	nota_fiscal d, 
	nota_fiscal_item f 
WHERE	b.nr_sequencia = a.nr_seq_desconto 
AND	b.nr_interno_conta = c.nr_interno_conta 
AND	c.nr_interno_conta = d.nr_interno_conta 		 
AND	d.nr_sequencia = nr_sequencia_p 
AND	d.nr_sequencia = f.nr_sequencia 
and	a.cd_procedimento = f.cd_procedimento 
and	f.cd_procedimento = cd_procedimento_p;		
 
 
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_conta_nota (nr_sequencia_p bigint, cd_procedimento_p bigint) FROM PUBLIC;

