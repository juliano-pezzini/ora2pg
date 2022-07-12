-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_mp_patient_name ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(150);


BEGIN
	select (substr(obter_titulo_academico_pf(OBTER_PESSOA_PERSON_NAME(a.nr_sequencia), 'S'),0,20)
			|| chr(32) || substr(a.ds_given_name, 1, 45)
			|| chr(32) || substr(a.ds_component_name_3, 0 , 20)
			|| chr(32) || substr(a.ds_component_name_1, 0 , 20)
			|| chr(32) || substr(a.ds_family_name, 1, 45))
	into STRICT ds_retorno_w
	from person_name a, pessoa_fisica b 
	where a.nr_sequencia = b.nr_seq_person_name
		and b.cd_pessoa_fisica = cd_pessoa_fisica_p;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_mp_patient_name ( cd_pessoa_fisica_p text) FROM PUBLIC;
