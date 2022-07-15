-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_regra_controle_sc ( nr_solic_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		solic_compra.cd_estabelecimento%type;
cd_local_estoque_w			solic_compra.cd_local_estoque%type;
cd_centro_custo_w		solic_compra.cd_centro_custo%type;
cd_setor_atendimento_w		solic_compra.cd_setor_atendimento%type;
ie_tipo_servico_w		solic_compra.ie_tipo_servico%type;
ie_tipo_solicitacao_w		solic_compra.ie_tipo_solicitacao%type;
nr_seq_forma_compra_w		solic_compra.nr_seq_forma_compra%type;
ie_urgente_w			solic_compra.ie_urgente%type;
nr_seq_motivo_urgente_w		solic_compra.nr_seq_motivo_urgente%type;
cd_grupo_material_w		grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w		subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w		classe_material.cd_classe_material%type;
cd_material_w			material.cd_material%type;
nr_seq_regra_w			regra_controle_qtde_sc.nr_sequencia%type;
ie_periodicidade_w		regra_controle_qtde_sc.ie_periodicidade%type;
ie_dia_semana_w			regra_controle_qtde_sc.ie_dia_semana%type;
ie_mes_w			regra_controle_qtde_sc.ie_mes%type;
qt_maximo_w			regra_controle_qtde_sc.qt_maximo%type;
qt_material_acumulado_w		solic_compra_item.qt_material%type;
cd_local_estoque_regra_w	regra_controle_qtde_sc.cd_local_estoque%type;
cd_centro_custo_regra_w		regra_controle_qtde_sc.cd_centro_custo%type;
cd_setor_atendimento_regra_w	regra_controle_qtde_sc.cd_setor_atendimento%type;
ie_tipo_servico_regra_w		regra_controle_qtde_sc.ie_tipo_servico%type;
ie_tipo_solicitacao_regra_w	regra_controle_qtde_sc.ie_tipo_solicitacao%type;
nr_seq_forma_compra_regra_w	regra_controle_qtde_sc.nr_seq_forma_compra%type;
nr_seq_motivo_urgente_regra_w	regra_controle_qtde_sc.nr_seq_motivo_urgente%type;
cd_grupo_material_regra_w	regra_controle_qtde_sc.cd_grupo_material%type;
cd_subgrupo_material_regra_w	regra_controle_qtde_sc.cd_subgrupo_material%type;
cd_classe_material_regra_w	regra_controle_qtde_sc.cd_classe_material%type;
cd_material_regra_w		regra_controle_qtde_sc.cd_material%type;
ie_urgente_regra_w		regra_controle_qtde_sc.ie_urgente%type;
qt_material_solic_w		solic_compra_item.qt_material%type;

c01 CURSOR FOR
SELECT	cd_estabelecimento,
	cd_local_estoque,
	cd_centro_custo,
	cd_setor_atendimento,
	coalesce(ie_tipo_servico,'ES'),
	ie_tipo_solicitacao,
	nr_seq_forma_compra,
	ie_urgente,
	nr_seq_motivo_urgente,
	b.cd_material,
	b.qt_material
from	solic_compra a,
	solic_compra_item b
where	a.nr_solic_compra = b.nr_solic_compra
and	a.nr_solic_compra = nr_solic_compra_p;

c02 CURSOR FOR
SELECT	nr_sequencia,
	cd_local_estoque,
	cd_centro_custo,
	cd_setor_atendimento,
	ie_tipo_servico,
	ie_tipo_solicitacao,
	nr_seq_forma_compra,
	nr_seq_motivo_urgente,
	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material,
	cd_material,
	ie_urgente,	
	ie_periodicidade,
	ie_dia_semana,
	somente_numero(ie_mes),
	qt_maximo
from	regra_controle_qtde_sc
where	cd_estabelecimento = cd_estabelecimento_w
and (coalesce(cd_local_estoque::text, '') = '' or cd_local_estoque = cd_local_estoque_w)
and (coalesce(cd_centro_custo::text, '') = '' or cd_centro_custo = cd_centro_custo_w)
and (coalesce(cd_setor_atendimento::text, '') = '' or cd_setor_atendimento = cd_setor_atendimento_w)
and (coalesce(ie_tipo_servico::text, '') = '' or ie_tipo_servico = ie_tipo_servico_w)
and (coalesce(ie_tipo_solicitacao::text, '') = '' or ie_tipo_solicitacao = ie_tipo_solicitacao_w)
and (coalesce(nr_seq_forma_compra::text, '') = '' or nr_seq_forma_compra = nr_seq_forma_compra_w)
and (coalesce(nr_seq_motivo_urgente::text, '') = '' or nr_seq_motivo_urgente = nr_seq_motivo_urgente_w)
and (coalesce(cd_grupo_material::text, '') = '' or cd_grupo_material = cd_grupo_material_w)
and (coalesce(cd_subgrupo_material::text, '') = '' or cd_subgrupo_material = cd_subgrupo_material_w)
and (coalesce(cd_classe_material::text, '') = '' or cd_classe_material = cd_classe_material_w)
and (coalesce(cd_material::text, '') = '' or cd_material = cd_material_w)
and	((ie_urgente = 'A') or (ie_urgente = ie_urgente_w))
and	obter_se_aplica_controle_sc(nr_sequencia, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_cd_setor_atendimento, nm_usuario_p) = 'S'
order by	coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(cd_local_estoque,0),
		coalesce(cd_centro_custo,0);
		

BEGIN

/*Faz um cursor dos itens da solicitação de compras*/

open C01;
loop
fetch C01 into	
	cd_estabelecimento_w,
	cd_local_estoque_w,
	cd_centro_custo_w,
	cd_setor_atendimento_w,
	ie_tipo_servico_w,
	ie_tipo_solicitacao_w,
	nr_seq_forma_compra_w,
	ie_urgente_w,
	nr_seq_motivo_urgente_w,
	cd_material_w,
	qt_material_solic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w
	from	estrutura_material_v
	where	cd_material = cd_material_w;
	
	/*Faz um cursor pra encontrar qual é a regra que se encaixa no item da solicitação de compras*/

	
	nr_seq_regra_w := 0;
	
	open C02;
	loop
	fetch C02 into	
		nr_seq_regra_w,
		cd_local_estoque_regra_w,
		cd_centro_custo_regra_w,
		cd_setor_atendimento_regra_w,
		ie_tipo_servico_regra_w,
		ie_tipo_solicitacao_regra_w,
		nr_seq_forma_compra_regra_w,
		nr_seq_motivo_urgente_regra_w,
		cd_grupo_material_regra_w,
		cd_subgrupo_material_regra_w,
		cd_classe_material_regra_w,
		cd_material_regra_w,
		ie_urgente_regra_w,	
		ie_periodicidade_w,
		ie_dia_semana_w,
		ie_mes_w,
		qt_maximo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		nr_seq_regra_w 		:= nr_seq_regra_w;
		
		end;
	end loop;
	close C02;
	
	qt_material_acumulado_w := 0;
	
	if (nr_seq_regra_w > 0) and (qt_maximo_w >= 0) and (ie_periodicidade_w = 'D') then /*Diário*/

			
		/*Select para buscar o acumulado de solicitações quando o período é Diário. Esse acumulado será usado para consistir a quantidade máxima de solicitações do dia*/

		select	coalesce(sum(qt_material),0)
		into STRICT	qt_material_acumulado_w
		from	solic_compra a,
			solic_compra_item b,
			estrutura_material_v e
		where	a.nr_solic_compra = b.nr_solic_compra
		and	b.cd_material = e.cd_material
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
		and	coalesce(b.nr_seq_motivo_cancel::text, '') = ''
		and	cd_estabelecimento = cd_estabelecimento_w
		and (coalesce(cd_local_estoque_regra_w::text, '') = '' or a.cd_local_estoque = cd_local_estoque_regra_w)
		and (coalesce(cd_centro_custo_regra_w::text, '') = '' or a.cd_centro_custo = cd_centro_custo_regra_w)
		and (coalesce(cd_setor_atendimento_regra_w::text, '') = '' or a.cd_setor_atendimento = cd_setor_atendimento_regra_w)
		and (coalesce(ie_tipo_servico_regra_w::text, '') = '' or coalesce(a.ie_tipo_servico,'ES') = ie_tipo_servico_regra_w)
		and (coalesce(ie_tipo_solicitacao_regra_w::text, '') = '' or a.ie_tipo_solicitacao = ie_tipo_solicitacao_regra_w)
		and (coalesce(nr_seq_forma_compra_regra_w::text, '') = '' or a.nr_seq_forma_compra = nr_seq_forma_compra_regra_w)
		and (coalesce(nr_seq_motivo_urgente_regra_w::text, '') = '' or a.nr_seq_motivo_urgente = nr_seq_motivo_urgente_regra_w)
		and (coalesce(cd_grupo_material_regra_w::text, '') = '' or e.cd_grupo_material = cd_grupo_material_regra_w)
		and (coalesce(cd_subgrupo_material_regra_w::text, '') = '' or e.cd_subgrupo_material = cd_subgrupo_material_regra_w)
		and (coalesce(cd_classe_material_regra_w::text, '') = '' or e.cd_classe_material = cd_classe_material_regra_w)
		and (coalesce(cd_material_regra_w::text, '') = '' or b.cd_material = cd_material_regra_w)
		and	((ie_urgente_regra_w = 'A') or (a.ie_urgente = ie_urgente_regra_w))
		and	b.cd_material = cd_material_w
		and	pkg_date_utils.start_of(dt_solicitacao_compra, 'DD', null) = pkg_date_utils.start_of(clock_timestamp(), 'DD', null)
		and	((coalesce(ie_dia_semana_w::text, '') = '') or
			((ie_dia_semana_w IS NOT NULL AND ie_dia_semana_w::text <> '') and (ie_dia_semana_w = 9) and (substr(obter_cod_dia_semana(dt_solicitacao_compra), 1,1) in (2,3,4,5,6))) or
			((ie_dia_semana_w IS NOT NULL AND ie_dia_semana_w::text <> '') and (ie_dia_semana_w <> 9) and (substr(obter_cod_dia_semana(dt_solicitacao_compra), 1,1) = ie_dia_semana_w)));
			
		
		if	((qt_material_acumulado_w + qt_material_solic_w) > qt_maximo_w) then
		
			CALL gravar_solic_compra_consist(
				nr_solic_compra_p, '1',
				WHEB_MENSAGEM_PCK.get_texto(687759,'CD_MATERIAL_W='||CD_MATERIAL_W),/*A quantidade do material #@CD_MATERIAL_W#@ atingiu a quantidade máxima diária permitida.*/
				'C',
				WHEB_MENSAGEM_PCK.get_texto(687760), /*Verifique a regra de controle de solicitações de compras por quantidade, que existe na função Cadastros Gerais >> Suprimentos >> Cadastros Compras.*/
				nm_usuario_p);
		
		end if;			
	end if;
	
	
		
	if (nr_seq_regra_w > 0) and (qt_maximo_w >= 0) and (ie_periodicidade_w = 'M') then /*Mensal*/
		
		
		
		/*Select para buscar o acumulado de solicitações quando o período é Mensal. Esse acumulado será usado para consistir a quantidade máxima de solicitações do mês*/

		select	coalesce(sum(qt_material),0)
		into STRICT	qt_material_acumulado_w
		from	solic_compra a,
			solic_compra_item b,
			estrutura_material_v e
		where	a.nr_solic_compra = b.nr_solic_compra
		and	b.cd_material = e.cd_material
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
		and	coalesce(b.nr_seq_motivo_cancel::text, '') = ''
		and	cd_estabelecimento = cd_estabelecimento_w
		and (coalesce(cd_local_estoque_regra_w::text, '') = '' or a.cd_local_estoque = cd_local_estoque_regra_w)
		and (coalesce(cd_centro_custo_regra_w::text, '') = '' or a.cd_centro_custo = cd_centro_custo_regra_w)
		and (coalesce(cd_setor_atendimento_regra_w::text, '') = '' or a.cd_setor_atendimento = cd_setor_atendimento_regra_w)
		and (coalesce(ie_tipo_servico_regra_w::text, '') = '' or coalesce(a.ie_tipo_servico,'ES') = ie_tipo_servico_regra_w)
		and (coalesce(ie_tipo_solicitacao_regra_w::text, '') = '' or a.ie_tipo_solicitacao = ie_tipo_solicitacao_regra_w)
		and (coalesce(nr_seq_forma_compra_regra_w::text, '') = '' or a.nr_seq_forma_compra = nr_seq_forma_compra_regra_w)
		and (coalesce(nr_seq_motivo_urgente_regra_w::text, '') = '' or a.nr_seq_motivo_urgente = nr_seq_motivo_urgente_regra_w)
		and (coalesce(cd_grupo_material_regra_w::text, '') = '' or e.cd_grupo_material = cd_grupo_material_regra_w)
		and (coalesce(cd_subgrupo_material_regra_w::text, '') = '' or e.cd_subgrupo_material = cd_subgrupo_material_regra_w)
		and (coalesce(cd_classe_material_regra_w::text, '') = '' or e.cd_classe_material = cd_classe_material_regra_w)
		and (coalesce(cd_material_regra_w::text, '') = '' or b.cd_material = cd_material_regra_w)
		and	((ie_urgente_regra_w = 'A') or (a.ie_urgente = ie_urgente_regra_w))
		and	b.cd_material = cd_material_w
		and	pkg_date_utils.start_of(dt_solicitacao_compra, 'MM', null) = pkg_date_utils.start_of(clock_timestamp(), 'MM', null)
		and	((ie_mes_w = 0) or
			((ie_mes_w <> 0) and (PKG_DATE_UTILS.extract_field('MONTH',dt_solicitacao_compra) = ie_mes_w)));
		
		
		if	((qt_material_acumulado_w + qt_material_solic_w) > qt_maximo_w) then
		
			CALL gravar_solic_compra_consist(
				nr_solic_compra_p, '1',
				WHEB_MENSAGEM_PCK.get_texto(687761,'CD_MATERIAL_W='||CD_MATERIAL_W),/*A quantidade do material #@CD_MATERIAL_W#@ atingiu a quantidade máxima mensal permitida.*/
				'C',
				WHEB_MENSAGEM_PCK.get_texto(687760), /*Verifique a regra de controle de solicitações de compras por quantidade, que existe na função Cadastros Gerais >> Suprimentos >> Cadastros Compras.*/
				nm_usuario_p);
		
		end if;
	
	end if;
		
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_regra_controle_sc ( nr_solic_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

