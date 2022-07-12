-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_carteira_convenio_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(255);
				

BEGIN 
 
select	max(a.ds_arquivo) 
into STRICT	ds_retorno_w 
from	pessoa_documentacao a, 
		tipo_documentacao b, 
		atendimento_paciente c 
where	c.nr_atendimento = nr_atendimento_p 
and		a.cd_pessoa_fisica = c.cd_pessoa_fisica 
and		a.nr_seq_documento = b.nr_sequencia 
and		b.ie_cart_convenio = 'S';
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_carteira_convenio_atend (nr_atendimento_p bigint) FROM PUBLIC;
