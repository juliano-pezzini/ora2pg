-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_um_dispositivo_solucao ( ie_bomba_infusao_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_tipo_dosagem_w	varchar(10);


BEGIN

if (ie_opcao_p	= 'S') then
	select	max(ie_tipo_dosagem)
	into STRICT	ie_tipo_dosagem_w
	from	rep_dispositivo
	where	ie_bomba_infusao	= ie_bomba_infusao_p
	and	ie_tipo_item		= 1;
end if;

return	ie_tipo_dosagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_um_dispositivo_solucao ( ie_bomba_infusao_p text, ie_opcao_p text) FROM PUBLIC;
