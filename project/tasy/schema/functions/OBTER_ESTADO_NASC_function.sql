-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estado_nasc (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_estado_w varchar(100);


BEGIN 
 
select SUBSTR(obter_valor_dominio(50, (select	obter_uf_localidade(a.nr_cep_cidade_nasc) 
	  				from	pessoa_fisica a, 
						atendimento_paciente b 
					where	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
					and	b.nr_atendimento = nr_atendimento_p)),1,100) 
into STRICT ds_estado_w
;
 
return	ds_estado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estado_nasc (nr_atendimento_p bigint) FROM PUBLIC;
