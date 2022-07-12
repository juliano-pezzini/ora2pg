-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION oncotech_obter_se_pac_quimio (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
qt_quimio_w	bigint;
ie_quimio_w	varchar(1) := 'N';
			

BEGIN 
 
select count(*) 
into STRICT	qt_quimio_w 
from  atendimento_paciente 
where cd_pessoa_fisica = cd_pessoa_fisica_p 
and	ie_tipo_atendimento in (7,8) 
and	ie_clinica = '5' 
and	nr_seq_classificacao = '5';
 
if (qt_quimio_w > 0) then 
	ie_quimio_w := 'S';
end if;
 
return	ie_quimio_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION oncotech_obter_se_pac_quimio (cd_pessoa_fisica_p text) FROM PUBLIC;
