-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION holding_pck.get_estabelecimento_matriz (cd_empresa_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estabelecimento_matriz_w	estabelecimento.cd_estabelecimento%type;


BEGIN
	begin
		select	cd_estabelecimento
		into STRICT		cd_estabelecimento_matriz_w
		from		estabelecimento
		where	cd_empresa	= cd_empresa_p
		and		ie_tipo_estab	= 'M';
	exception
	when others then
		cd_estabelecimento_matriz_w	:= null;
	end;

return	cd_estabelecimento_matriz_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION holding_pck.get_estabelecimento_matriz (cd_empresa_p bigint) FROM PUBLIC;
