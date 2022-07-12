-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_auxiliar_proc_paciente ( nr_sequencia_p bigint, ie_funcao_medico_p text) RETURNS varchar AS $body$
DECLARE

 
 
ds_retorno_w				varchar(2000);
nm_medico_w				varchar(200);

c01 CURSOR FOR 
	SELECT	SUBSTR(obter_nome_pessoa_fisica(b.cd_pessoa_fisica,null),1,100) nm_medico 
	from 	procedimento_participante	b, 
		procedimento_paciente	a 
	where	a.nr_sequencia		= nr_sequencia_p 
	and	b.ie_funcao	 	= ie_funcao_medico_p 
	and	a.nr_sequencia 		= b.nr_sequencia;
				

BEGIN 
 
open c01;
loop 
fetch c01 into	nm_medico_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	ds_retorno_w	:=	ds_retorno_w || nm_medico_w || '; ';
end loop;
 
close c01;
 
RETURN ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_auxiliar_proc_paciente ( nr_sequencia_p bigint, ie_funcao_medico_p text) FROM PUBLIC;

