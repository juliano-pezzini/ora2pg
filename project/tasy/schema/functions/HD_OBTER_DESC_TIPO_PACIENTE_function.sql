-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_desc_tipo_paciente ( ie_tipo_paciente_p text) RETURNS varchar AS $body$
DECLARE


ds_tipo_paciente_w	varchar(255);


BEGIN

select	substr(obter_desc_expressao(CASE WHEN ie_tipo_paciente_p='S' THEN 302551 WHEN ie_tipo_paciente_p='N' THEN  315354 WHEN ie_tipo_paciente_p='A' THEN 308326  ELSE 705383 END ),1,255)
into STRICT	ds_tipo_paciente_w
;

return	ds_tipo_paciente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_desc_tipo_paciente ( ie_tipo_paciente_p text) FROM PUBLIC;

