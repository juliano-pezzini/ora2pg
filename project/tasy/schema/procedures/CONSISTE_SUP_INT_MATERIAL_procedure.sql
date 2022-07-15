-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_sup_int_material ( nr_sequencia_p bigint, cd_material_generico_p bigint, cd_material_estoque_p bigint, cd_material_conta_p bigint, cd_classe_material_p bigint, cd_unidade_medida_compra_p text, cd_unidade_medida_estoque_p text, cd_unidade_medida_consumo_p text, cd_unidade_medida_solic_p text, nr_seq_localizacao_p bigint, nr_seq_familia_p bigint, ie_via_aplicacao_p text, ie_tipo_material_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



cd_material_w				integer;
cd_material_generico_w			integer;
cd_material_estoque_w			integer;
cd_material_conta_w			integer;
cd_classe_material_w			integer;
nr_seq_localizacao_w			varchar(10);
nr_seq_familia_w				varchar(10);
qt_existe_w				bigint;
cd_unidade_medida_compra_w		varchar(30);
cd_unidade_medida_consumo_w		varchar(30);
cd_unidade_medida_estoque_w		varchar(30);
cd_unidade_medida_solic_w			varchar(30);
ie_de_para_unid_med_w			varchar(15);


BEGIN
cd_material_generico_w		:= coalesce(cd_material_generico_p,0);
cd_material_estoque_w		:= coalesce(cd_material_estoque_p,0);
cd_material_conta_w		:= coalesce(cd_material_conta_p,0);
nr_seq_localizacao_w		:= coalesce(nr_seq_localizacao_p,0);
nr_seq_familia_w		:= coalesce(nr_seq_familia_p,0);

/* Verificar se classe do material existe*/

if (cd_classe_material_p > 0) then
	begin
	select	count(*)
	into STRICT	qt_existe_w
	from	classe_material
	where	cd_classe_material = cd_classe_material_p;

	if (qt_existe_w = 0) then
		CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313455));
	end if;
	end;
end if;

select	obter_ie_de_para_sup_integr('CM','R','UNIDADE_MEDIDA')
into STRICT	ie_de_para_unid_med_w
;

/*Verificar as unidades de medida existem*/

/*Conversao para unidade de medida*/

cd_unidade_medida_compra_w 	:= cd_unidade_medida_compra_p;
cd_unidade_medida_consumo_w	:= cd_unidade_medida_consumo_p;
cd_unidade_medida_estoque_w	:= cd_unidade_medida_estoque_p;
cd_unidade_medida_solic_w	:= cd_unidade_medida_solic_p;
if (ie_de_para_unid_med_w = 'C') then
	cd_unidade_medida_compra_w	:= coalesce(Obter_Conversao_interna(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_compra_p),cd_unidade_medida_compra_p);
	cd_unidade_medida_consumo_w	:= coalesce(Obter_Conversao_interna(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_consumo_p),cd_unidade_medida_consumo_p);
	cd_unidade_medida_estoque_w	:= coalesce(Obter_Conversao_interna(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_estoque_p),cd_unidade_medida_estoque_p);
	cd_unidade_medida_solic_w	:= coalesce(Obter_Conversao_interna(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_solic_p),cd_unidade_medida_solic_p);

elsif (ie_de_para_unid_med_w = 'S') then
	cd_unidade_medida_compra_w	:= coalesce(obter_unid_med_sist_ant(cd_unidade_medida_compra_p),cd_unidade_medida_compra_p);
	cd_unidade_medida_consumo_w	:= coalesce(obter_unid_med_sist_ant(cd_unidade_medida_consumo_p),cd_unidade_medida_consumo_p);
	cd_unidade_medida_estoque_w	:= coalesce(obter_unid_med_sist_ant(cd_unidade_medida_estoque_p),cd_unidade_medida_estoque_p);
	cd_unidade_medida_solic_w	:= coalesce(obter_unid_med_sist_ant(cd_unidade_medida_solic_p),cd_unidade_medida_solic_p);
end if;
/*Fim*/

select	count(*)
into STRICT	qt_existe_w
from	unidade_medida
where	upper(cd_unidade_medida) = upper(cd_unidade_medida_compra_w);

if (qt_existe_w = 0) then
	CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313531));
end if;

select	count(*)
into STRICT	qt_existe_w
from	unidade_medida
where	upper(cd_unidade_medida) = upper(cd_unidade_medida_estoque_w);

if (qt_existe_w = 0) then
	CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313532));
end if;

select	count(*)
into STRICT	qt_existe_w
from	unidade_medida
where	upper(cd_unidade_medida) = upper(cd_unidade_medida_consumo_w);

if (qt_existe_w = 0) then
	CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313533));
end if;

if (cd_unidade_medida_solic_p IS NOT NULL AND cd_unidade_medida_solic_p::text <> '') then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	unidade_medida
	where	upper(cd_unidade_medida) = upper(cd_unidade_medida_solic_w);

	if (qt_existe_w = 0) then
		CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313534));
	end if;

	end;
end if;

if (nr_seq_localizacao_w > 0) then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	material_local
	where	nr_sequencia = nr_seq_localizacao_w;

	if (qt_existe_w = 0) then
		CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313535));
	end if;

	end;
end if;

if (nr_seq_familia_w > 0) then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	material_familia
	where	nr_sequencia = nr_seq_familia_w;

	if (qt_existe_w = 0) then
		CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313536));
	end if;

	end;
end if;

select	count(*)
into STRICT	qt_existe_w
from	valor_dominio
where	cd_dominio = 29
and	vl_dominio = ie_tipo_material_p;

if (qt_existe_w = 0) then
	CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313537));
end if;

if (ie_via_aplicacao_p IS NOT NULL AND ie_via_aplicacao_p::text <> '') then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	via_aplicacao
	where	ie_via_aplicacao = ie_via_aplicacao_p;

	if (qt_existe_w = 0) then
		CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313539));
	end if;

	end;
end if;

select	count(*)
into STRICT	qt_existe_w
from	estabelecimento_v
where	cd_estabelecimento = cd_estabelecimento_p;

if (qt_existe_w = 0) then
	CALL grava_sup_int_material_consist(nr_sequencia_p,wheb_mensagem_pck.get_texto(313540));
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_sup_int_material ( nr_sequencia_p bigint, cd_material_generico_p bigint, cd_material_estoque_p bigint, cd_material_conta_p bigint, cd_classe_material_p bigint, cd_unidade_medida_compra_p text, cd_unidade_medida_estoque_p text, cd_unidade_medida_consumo_p text, cd_unidade_medida_solic_p text, nr_seq_localizacao_p bigint, nr_seq_familia_p bigint, ie_via_aplicacao_p text, ie_tipo_material_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

