-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ag_cir_encaixe (ie_tipo_classif_p text, ie_status_agenda_p text) RETURNS varchar AS $body$
DECLARE


ie_encaixe_w	varchar(1)	:= 'N';


BEGIN

if (ie_tipo_classif_p = 'E') and (ie_status_agenda_p not in ('E','C')) then
	ie_encaixe_w	:= 'S';
end if;

return	ie_encaixe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ag_cir_encaixe (ie_tipo_classif_p text, ie_status_agenda_p text) FROM PUBLIC;
