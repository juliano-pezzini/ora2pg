-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_glos_oco_permite ( cd_codigo_p text, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


ie_fechar_conta_w	varchar(1);


BEGIN

if (ie_tipo_p = 'G') then

	select	max(coalesce(ie_fechar_conta,'S'))
	into STRICT	ie_fechar_conta_w
	from	tiss_motivo_glosa
	where	cd_motivo_tiss = cd_codigo_p;

elsif (ie_tipo_p = 'O') then

	select	max(coalesce(ie_fechar_conta,'S'))
	into STRICT	ie_fechar_conta_w
	from	pls_ocorrencia
	where	cd_ocorrencia = cd_codigo_p;

end if;

return	ie_fechar_conta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_glos_oco_permite ( cd_codigo_p text, ie_tipo_p text) FROM PUBLIC;
