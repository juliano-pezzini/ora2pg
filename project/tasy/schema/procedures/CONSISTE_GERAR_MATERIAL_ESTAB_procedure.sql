-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_gerar_material_estab ( cd_estabelecimento_p bigint, cd_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w		bigint;
cd_estabelecimento_w	smallint;
ie_estoque_lote_w		varchar(1);
ie_controla_serie_w		varchar(1);
ie_requisicao_w		varchar(1);
ie_prescricao_w		varchar(1);
ie_padronizado_w		varchar(1);
ie_ressuprimento_w		varchar(1);
ie_material_estoque_w	varchar(1);
ie_baixa_estoq_pac_w	varchar(1);
lista_estab_w		varchar(255);
cd_material_estoque_w   material.cd_material_estoque%type;

c01 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	((coalesce(lista_estab_w::text, '') = '') or
	((lista_estab_w IS NOT NULL AND lista_estab_w::text <> '') and (obter_se_contido(cd_estabelecimento, lista_estab_w) = 'S')));


BEGIN
lista_estab_w := Obter_Valor_Param_Usuario(132, 118, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

open c01;
loop
fetch c01 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	select	count(*)
	into STRICT	qt_existe_w
	from	material_estab
	where	cd_estabelecimento = cd_estabelecimento_w
	and	cd_material = cd_material_p;

	/*Estes campos nao podem ter o valor padrao para os outros estabelecimentos, ou seja:
	Nos outros estabelecimentos nao podem gerar estoque, ressuprimento, etc, etc*/
	ie_estoque_lote_w		:= 'N';
	ie_controla_serie_w		:= 'N';
	ie_requisicao_w		:= 'S';
	ie_prescricao_w		:= 'S';
	ie_padronizado_w		:= 'S';
	ie_ressuprimento_w		:= 'S';
	ie_material_estoque_w	:= 'S';
	ie_baixa_estoq_pac_w	:= 'S';
	if (cd_estabelecimento_w <> cd_estabelecimento_p) then
		ie_requisicao_w		:= 'N';
		ie_prescricao_w		:= 'N';
		ie_padronizado_w		:= 'N';
		ie_ressuprimento_w		:= 'N';
		ie_material_estoque_w	:= 'N';
		ie_baixa_estoq_pac_w	:= 'N';
	end if;

	if (qt_existe_w = 0) then
		cd_material_estoque_w := coalesce(obter_material_estoque(cd_material_p),cd_material_p);
		if (cd_material_estoque_w <> cd_material_p) then
			 ie_estoque_lote_w := substr(coalesce(obter_se_material_estoque_lote(cd_estabelecimento_w, cd_material_estoque_w),'N'),1,1);
		end if;
		
		insert into material_estab(
			nr_sequencia,		cd_estabelecimento,
			cd_material,		dt_atualizacao,
			nm_usuario,		ie_baixa_estoq_pac,
			ie_material_estoque,	qt_dia_interv_ressup,
			qt_dia_ressup_forn,		nr_minimo_cotacao,
			ie_ressuprimento,		dt_atualizacao_nrec,
			nm_usuario_nrec,		ie_classif_custo,
			ie_prescricao,		ie_padronizado,
			ie_estoque_lote,		ie_requisicao,
			ie_controla_serie)
		values (nextval('material_estab_seq'),	cd_estabelecimento_w,
			cd_material_p,		clock_timestamp(),	
			nm_usuario_p,		ie_baixa_estoq_pac_w,
			ie_material_estoque_w,	10,
			3,			1,
			ie_ressuprimento_w,	clock_timestamp(),
			nm_usuario_p,		'B',
			ie_prescricao_w,		ie_padronizado_w,
			ie_estoque_lote_w,		ie_requisicao_w,
			ie_controla_serie_w);
	end if;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_gerar_material_estab ( cd_estabelecimento_p bigint, cd_material_p bigint, nm_usuario_p text) FROM PUBLIC;
