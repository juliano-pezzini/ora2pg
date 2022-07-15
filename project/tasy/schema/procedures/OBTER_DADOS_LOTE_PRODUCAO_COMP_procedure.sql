-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_lote_producao_comp ( un_consumo_p INOUT text, un_estoque_p INOUT text, qt_estoq_consumo_p INOUT bigint, cd_material_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


un_consumo_w			varchar(15);
un_estoque_w			varchar(15);
qt_estoque_consumo_w		double precision;

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	un_consumo_w	:= substr(obter_dados_material_estab(cd_material_p,cd_estabelecimento_p,'UMS'),1,30);
	un_estoque_w	:= substr(obter_dados_material_estab(cd_material_p,cd_estabelecimento_p,'UME'),1,30);

	select	qt_conv_estoque_consumo
	into STRICT	qt_estoque_consumo_w
	from	material
	where	cd_material = cd_material_p;
	end;
end if;
commit;
un_consumo_p		:= un_consumo_w;
un_estoque_p		:= un_estoque_w;
qt_estoq_consumo_p 	:= qt_estoque_consumo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_lote_producao_comp ( un_consumo_p INOUT text, un_estoque_p INOUT text, qt_estoq_consumo_p INOUT bigint, cd_material_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

