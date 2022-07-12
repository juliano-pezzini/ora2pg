-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_via_aplicacao (ie_via_aplicacao_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
D - Descrição
V - Via
*/
ds_via_aplicacao_w	varchar(80);
ds_retorno_w		varchar(80);
ie_via_aplicacao_w	varchar(5);


BEGIN
if (ie_via_aplicacao_p IS NOT NULL AND ie_via_aplicacao_p::text <> '') then
	select	ds_via_aplicacao,
			ie_via_aplicacao
	into STRICT	ds_via_aplicacao_w,
			ie_via_aplicacao_w
	from	via_aplicacao
	where	ie_via_aplicacao	= ie_via_aplicacao_p
	and	ie_situacao		= 'A';

	if (coalesce(ie_opcao_p,'D') = 'D') then
		ds_retorno_w	:= ds_via_aplicacao_w;
	end if;

	if (coalesce(ie_opcao_p,'V') = 'V') then
		ds_retorno_w	:= ie_via_aplicacao_w;
	end if;
end if;

RETURN	ds_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_via_aplicacao (ie_via_aplicacao_p text, ie_opcao_p text) FROM PUBLIC;
