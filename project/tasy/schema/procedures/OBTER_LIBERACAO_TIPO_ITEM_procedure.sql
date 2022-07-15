-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_liberacao_tipo_item (ie_tipo_item_p bigint, ie_liberacao_p INOUT text, ds_mensagem_p INOUT text) AS $body$
DECLARE


ie_liberacao_w	varchar(1);
ds_mensagem_w	varchar(255);

C01 CURSOR FOR
	SELECT	ie_liberacao,
		ds_mensagem
	from	regra_tipo_item_perfil
	where	ie_situacao = 'A'
	and 	ie_tipo_item = ie_tipo_item_p
	and 	coalesce(cd_perfil, coalesce(obter_perfil_ativo,0)) = coalesce(obter_perfil_ativo,0)
	order by coalesce(cd_perfil,0);


BEGIN

ie_liberacao_w	:= 'S';
ds_mensagem_w	:= '';

open C01;
loop
fetch C01 into
	ie_liberacao_w,
	ds_mensagem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_liberacao_w	:= ie_liberacao_w;
	ds_mensagem_w	:= ds_mensagem_w;
	end;
end loop;
close C01;

ie_liberacao_p	:= ie_liberacao_w;
ds_mensagem_p	:= '';
if (ie_liberacao_w = 'N') then
	ds_mensagem_p:= ds_mensagem_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_liberacao_tipo_item (ie_tipo_item_p bigint, ie_liberacao_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;

