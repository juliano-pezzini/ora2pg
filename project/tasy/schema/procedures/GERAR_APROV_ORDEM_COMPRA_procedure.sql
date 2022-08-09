-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_aprov_ordem_compra ( nr_ordem_compra_p bigint, cd_perfil_ativo_p bigint, ie_aprova_autom_usuario_p text, nm_usuario_p text) AS $body$
DECLARE



cd_material_w				integer;
nr_seq_aprovacao_w			bigint;
cd_processo_aprov_w			bigint;
cd_estabelecimento_w			smallint;
nr_item_oci_w				integer;
cd_cargo_w				bigint	:= 0;
cd_centro_custo_w				bigint	:= 0;
cd_responsavel_w				varchar(10);
ie_responsavel_w				varchar(01);
ie_urgente_w				varchar(01);
ie_tipo_ordem_w				varchar(01);
ie_tipo_processo_w				varchar(01);
nr_sequencia_w				bigint;
dt_liberacao_w				timestamp;
nr_items_sem_aprov_w			bigint;
nr_seq_proj_rec_w				bigint;
nm_usuario_regra_w			varchar(15);
cd_local_estoque_w			smallint;
nr_solic_compra_w				bigint;
nr_item_solic_compra_w			integer;
VarEscolherItensBaixados			varchar(1);
qt_itens_w				bigint;
nr_seq_proc_email_w			bigint;
cd_setor_atendimento_w			integer;
qt_existe_w				bigint;
ie_aprovacao_nivel_w			varchar(1);
nr_nivel_aprovacao_w			bigint;
nr_nivel_aprovacao_w2			bigint;
cd_condicao_pagamento_w			bigint;
ie_aprova_direto_w			varchar(1) := 'N';
ie_aprovar_oc_contrato_w		varchar(1) := 'N';
ie_aprova_contrato_direto_w		varchar(1) := 'N';
nr_contrato_w				bigint;
cd_conta_contabil_w			varchar(20);
cd_pessoa_fisica_w			varchar(10);
cd_cgc_fornecedor_w			varchar(14);
cd_perfil_w				perfil.cd_perfil%type;
ds_perfil_w				perfil.ds_perfil%type;
dt_ordem_compra_w			timestamp;
vl_minimo_w				processo_aprov_resp.vl_minimo%type;
vl_maximo_w				processo_aprov_resp.vl_maximo%type;
qt_minimo_aprovador_w			processo_aprov_resp.qt_minimo_aprovador%type;
qt_itens_regra_w			processo_aprov_resp.qt_itens_regra%type;
qt_intervalo_regra_w			processo_aprov_resp.qt_intervalo_regra%type;

c01 CURSOR FOR
SELECT	a.nr_seq_aprovacao,
	a.cd_material,
	a.nr_item_oci,
	a.cd_centro_custo,
	a.cd_local_estoque,
	a.nr_seq_proj_rec,
	a.nr_contrato,
	a.cd_conta_contabil
from	Estrutura_Material_v e,
	ordem_compra_item a
where	a.nr_ordem_compra		= nr_ordem_compra_p
and	a.cd_material		= e.cd_material
and	coalesce(a.dt_aprovacao::text, '') = ''
and	coalesce(a.nr_seq_aprovacao::text, '') = ''
order by	e.cd_grupo_material,
	e.cd_subgrupo_material,
	e.cd_classe_material,
	e.cd_material;

c02 CURSOR FOR
SELECT	nr_sequencia,
	ie_responsavel,
	cd_cargo,
	nm_usuario_regra,
	nr_nivel_aprovacao,
	vl_minimo,
	vl_maximo,
	qt_minimo_aprovador,
	qt_itens_regra,
	qt_intervalo_regra
from	processo_aprov_resp
where	cd_processo_Aprov		= cd_processo_aprov_w
and	ie_ordem_compra		= 'S'
and	ie_tipo_ordem_w		<> 'T'

union

SELECT	nr_sequencia,
	ie_responsavel,
	cd_cargo,
	nm_usuario_regra,
	nr_nivel_aprovacao,
	vl_minimo,
	vl_maximo,
	qt_minimo_aprovador,
	qt_itens_regra,
	qt_intervalo_regra
from	processo_aprov_resp
where	cd_processo_Aprov		= cd_processo_aprov_w
and	ie_ordem_compra_transf	= 'S'
and	ie_tipo_ordem_w		= 'T'

union

select	nr_sequencia,
	ie_responsavel,
	cd_cargo,
	nm_usuario_regra,
	nr_nivel_aprovacao,
	vl_minimo,
	vl_maximo,
	qt_minimo_aprovador,
	qt_itens_regra,
	qt_intervalo_regra
from	processo_aprov_resp
where	cd_processo_Aprov		= cd_processo_aprov_w
and	ie_transf_pcs	= 'S'
and	ie_tipo_ordem_w		= 'Z'
order by 1;

c03 CURSOR FOR
SELECT	distinct nr_seq_aprovacao
from	ordem_compra_item a
where	nr_ordem_compra	= nr_ordem_compra_p
and	coalesce(dt_aprovacao::text, '') = '';

c04 CURSOR FOR
SELECT	distinct
	a.nr_solic_compra,
	a.nr_item_solic_compra
from	ordem_compra_item a,
	solic_compra_item b
where	a.nr_solic_compra = b.nr_solic_compra
and	a.nr_item_solic_compra = b.nr_item_solic_compra
and	a.nr_ordem_compra = nr_ordem_compra_p
and	coalesce(b.dt_baixa::text, '') = ''
and	qt_itens_solic_em_cotacao(a.nr_solic_compra,a.nr_item_solic_compra) >= b.qt_material;


BEGIN

ie_aprova_direto_w		:= 'N';
cd_perfil_w			:= cd_perfil_ativo_p;

if (coalesce(cd_perfil_w,0) = 0) then
	select 	obter_perfil_ativo
	into STRICT 	cd_perfil_w
	;
	
	if (cd_perfil_w = 0) then
		cd_perfil_w := null;
	end if;
end if;

if (coalesce(cd_perfil_w,0) > 0) then
	select	max(ds_perfil)
	into STRICT	ds_perfil_w
	from	perfil
	where	cd_perfil = cd_perfil_w;
end if;

update	ordem_compra
set	dt_liberacao	= clock_timestamp(),
	nm_usuario_lib	= nm_usuario_p
where	nr_ordem_compra	= nr_ordem_compra_p;

CALL inserir_historico_ordem_compra(
	nr_ordem_compra_p,
	'S',		
	WHEB_MENSAGEM_PCK.get_texto(301394),	
	WHEB_MENSAGEM_PCK.get_texto(301393,'CD_PERFIL_W=' || cd_perfil_w || ';' || 'DS_PERFIL_W=' || ds_perfil_w),
	nm_usuario_p);

update	ordem_compra_item
set	qt_original	= qt_material
where	nr_ordem_compra	= nr_ordem_compra_p
and	coalesce(qt_original::text, '') = '';

update	ordem_compra_item
set	vl_unit_mat_original = vl_unitario_material
where	nr_ordem_compra	= nr_ordem_compra_p
and	coalesce(vl_unit_mat_original::text, '') = '';

select	max(cd_estabelecimento),
	coalesce(max(ie_urgente),'N'),
	coalesce(max(ie_tipo_ordem),'N'),
	max(cd_setor_atendimento),
	max(cd_cgc_fornecedor),
	max(cd_pessoa_fisica),
	max(dt_ordem_compra)
into STRICT	cd_estabelecimento_w,
	ie_urgente_w,
	ie_tipo_ordem_w,
	cd_setor_atendimento_w,
	cd_cgc_fornecedor_w,
	cd_pessoa_fisica_w,
	dt_ordem_compra_w
from	ordem_compra
where	nr_ordem_compra	= nr_ordem_compra_p;

if (cd_cgc_fornecedor_w IS NOT NULL AND cd_cgc_fornecedor_w::text <> '') then
	cd_pessoa_fisica_w	:= null;
end if;

select	coalesce(max(ie_aprovar_oc_contrato),'N')
into STRICT	ie_aprovar_oc_contrato_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_w;

if (ie_tipo_ordem_w = 'T') then
	begin
	select	count(*)
	into STRICT	qt_itens_w
	from	ordem_compra_item
	where	nr_ordem_compra = nr_ordem_compra_p;

	CALL inserir_historico_ordem_compra(
		nr_ordem_compra_p,
		'S',
		WHEB_MENSAGEM_PCK.get_texto(301389),
		WHEB_MENSAGEM_PCK.get_texto(301391,'QT_ITENS_W=' || to_char(qt_itens_w)),
		nm_usuario_p);
	end;
end if;

select	Obter_Valor_Param_Usuario(917, 95, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)
into STRICT	VarEscolherItensBaixados
;

calcular_Liquido_ordem_compra(nr_ordem_compra_p, nm_usuario_p);
CALL gerar_conta_financ_oc(nr_ordem_compra_p);

select	coalesce(max(cd_condicao_pagamento),0)
into STRICT	cd_condicao_pagamento_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_p;

if (cd_condicao_pagamento_w > 0) then
	select	coalesce(ie_aprova_direto,'N')
	into STRICT	ie_aprova_direto_w
	from	condicao_pagamento
	where	cd_condicao_pagamento = cd_condicao_pagamento_w;
end if;

open c01;
loop
fetch c01 into
	nr_seq_aprovacao_w,
	cd_material_w,
	nr_item_oci_w,
	cd_centro_custo_w,
	cd_local_estoque_w,
	nr_seq_proj_rec_w,
	nr_contrato_w,
	cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ie_tipo_processo_w		:= 'O';	
	ie_aprova_contrato_direto_w	:= 'N';
	
	if (ie_aprovar_oc_contrato_w = 'S') and (nr_contrato_w > 0) then
		ie_aprova_contrato_direto_w := 'S';
	end if;
	
	if (ie_tipo_ordem_w = 'T') then
		ie_tipo_processo_w	:= 'T';
	elsif (ie_tipo_ordem_w = 'Z') then
		ie_tipo_processo_w	:= 'Z';		
	end if;

	if (coalesce(nr_seq_aprovacao_w::text, '') = '') and (ie_aprova_direto_w = 'N') and (ie_aprova_contrato_direto_w = 'N') then
		
		cd_processo_aprov_w := obter_processo_aprovacao(
			cd_material_w, cd_centro_custo_w, cd_setor_atendimento_w, cd_local_estoque_w, null,  -- cd_local_estoque_destino_p - Usado somente na requisicao
			null,  -- cd_operacao_estoque_p       - Usado somente na requisicao
			cd_conta_contabil_w, cd_cgc_fornecedor_w, cd_pessoa_fisica_w, ie_tipo_processo_w, ie_urgente_w, cd_estabelecimento_w, cd_perfil_w, nr_seq_proj_rec_w, nr_ordem_compra_p, cd_processo_aprov_w);
	end if;
	
	if (coalesce(cd_processo_aprov_w::text, '') = '') then
		update	ordem_compra_item
		set	dt_aprovacao	= clock_timestamp()
		where	nr_ordem_compra	= nr_ordem_compra_p
		and	nr_item_oci	= nr_item_oci_w;
	else
		begin
		
		select	coalesce(max(b.nr_sequencia),0)
		into STRICT 	nr_seq_aprovacao_w
		from 	processo_aprov_compra a,
			processo_compra b
		where 	b.nr_sequencia = a.nr_sequencia
		and 	b.cd_processo_aprov = cd_processo_aprov_w
		and 	a.nr_documento = nr_ordem_compra_p
		and 	a.cd_estabelecimento = cd_estabelecimento_w
		and	a.ie_tipo = 'O';
		
		if (nr_seq_aprovacao_w = 0) then		
			begin
			
			select	nextval('processo_compra_seq')
			into STRICT	nr_seq_aprovacao_w
			;
			
			insert into processo_compra(
				nr_sequencia,
				cd_processo_aprov,
				dt_atualizacao,
				nm_usuario)
			values (	nr_seq_aprovacao_w,
				cd_processo_aprov_w, 
				clock_timestamp(),
				nm_usuario_p);
		
			dt_liberacao_w			:= clock_timestamp();
			
			open c02;
			loop
			fetch C02 into
				nr_sequencia_w,
				ie_responsavel_w,
				cd_cargo_w,
				nm_usuario_regra_w,
				nr_nivel_aprovacao_w,
				vl_minimo_w,
				vl_maximo_w,
				qt_minimo_aprovador_w,
				qt_itens_regra_w,
				qt_intervalo_regra_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				
				cd_responsavel_w	:= '';
				
				if (coalesce(nr_nivel_aprovacao_w2::text, '') = '') then
					nr_nivel_aprovacao_w2 := nr_nivel_aprovacao_w;
				end if;
				
				if (ie_responsavel_w = 'R') then				
					select	coalesce(max(cd_cargo),null)
					into STRICT	cd_cargo_w
					from	cargo_centro_custo
					where	cd_centro_custo = cd_centro_custo_w;
				end if;
				
				if (ie_responsavel_w <> 'F') then
				
					if (nr_nivel_aprovacao_w IS NOT NULL AND nr_nivel_aprovacao_w::text <> '')
						and (coalesce(dt_liberacao_w::text, '') = '') then
						
						select	obter_se_proc_por_nivel(nr_seq_aprovacao_w, cd_estabelecimento_w)
						into STRICT	ie_aprovacao_nivel_w
						;
						
						if (ie_aprovacao_nivel_w = 'S') and (nr_nivel_aprovacao_w2 = nr_nivel_aprovacao_w) then
							dt_liberacao_w	:= clock_timestamp();
						else
							dt_liberacao_w	:= null;
						end if;
					end if;
				
					insert into processo_aprov_compra(
						nr_sequencia,
						nr_seq_proc_aprov,
						dt_atualizacao,
						nm_usuario,
						nm_usuario_nrec,
						cd_pessoa_fisica,
						cd_cargo,
						dt_liberacao,
						dt_definicao,
						ie_aprov_reprov,
						cd_estabelecimento,
						ie_urgente,
						nr_documento,
						ie_tipo,
						dt_documento,
						nr_nivel_aprovacao,
						cd_processo_aprov,
						ie_responsavel,
						vl_minimo,
						vl_maximo,
						qt_minimo_aprovador,
						nm_usuario_regra,
						qt_itens_regra,
						qt_intervalo_regra)
					values (	nr_seq_aprovacao_w,
						nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						nm_usuario_p,
						cd_responsavel_w,
						cd_cargo_w,
						dt_liberacao_w,
						CASE WHEN coalesce(cd_cargo_w::text, '') = '' THEN clock_timestamp()  ELSE null END ,
						'P',
						cd_estabelecimento_w,
						ie_urgente_w,
						nr_ordem_compra_p,
						'O',
						dt_ordem_compra_w,
						nr_nivel_aprovacao_w,
						cd_processo_aprov_w,
						ie_responsavel_w,
						vl_minimo_w,
						vl_maximo_w,
						qt_minimo_aprovador_w,
						nm_usuario_regra_w,
						qt_itens_regra_w,
						qt_intervalo_regra_w);
					
					if (cd_cargo_w IS NOT NULL AND cd_cargo_w::text <> '') then
						dt_liberacao_w	:= null;
					end if;

					
				elsif (ie_responsavel_w = 'F') then
				
					select	obter_pessoa_fisica_usuario(nm_usuario_regra_w,'C')
					into STRICT	cd_responsavel_w
					;
					
					if (coalesce(cd_responsavel_w::text, '') = '') then
						/*(-20011,'O usuario aprovador ' || nm_usuario_regra_w || 'nao possui nenhuma pessoa fisica vinculada. Favor ajustar o cadastro deste usuario');*/

						CALL wheb_mensagem_pck.exibir_mensagem_abort(212871,'NM_USUARIO_REGRA=' || nm_usuario_regra_w);
					end if;
					
					if (nr_nivel_aprovacao_w IS NOT NULL AND nr_nivel_aprovacao_w::text <> '')
						and (coalesce(dt_liberacao_w::text, '') = '') then
						
						select	obter_se_proc_por_nivel(nr_seq_aprovacao_w, cd_estabelecimento_w)
						into STRICT	ie_aprovacao_nivel_w
						;
						
						if (ie_aprovacao_nivel_w = 'S') and (nr_nivel_aprovacao_w2 = nr_nivel_aprovacao_w) then
							dt_liberacao_w	:= clock_timestamp();
						else
							dt_liberacao_w	:= null;
						end if;
					end if;
					
					insert into processo_aprov_compra(
						nr_sequencia,
						nr_seq_proc_aprov,
						dt_atualizacao,
						nm_usuario,
						nm_usuario_nrec,
						cd_pessoa_fisica,
						cd_cargo,
						dt_liberacao,
						dt_definicao,
						ie_aprov_reprov,
						cd_estabelecimento,
						ie_urgente,
						nr_documento,
						ie_tipo,
						dt_documento,
						nr_nivel_aprovacao,
						cd_processo_aprov,
						ie_responsavel,
						vl_minimo,
						vl_maximo,
						qt_minimo_aprovador,
						nm_usuario_regra,
						qt_itens_regra,
						qt_intervalo_regra)
					values (	nr_seq_aprovacao_w,
						nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						nm_usuario_p,
						cd_responsavel_w,
						null,
						dt_liberacao_w,
						null,
						'P',
						cd_estabelecimento_w,
						ie_urgente_w,
						nr_ordem_compra_p,
						'O',
						dt_ordem_compra_w,
						nr_nivel_aprovacao_w,
						cd_processo_aprov_w,
						ie_responsavel_w,
						vl_minimo_w,
						vl_maximo_w,
						qt_minimo_aprovador_w,
						nm_usuario_regra_w,
						qt_itens_regra_w,
						qt_intervalo_regra_w);
					
					if (cd_responsavel_w IS NOT NULL AND cd_responsavel_w::text <> '') then
						dt_liberacao_w	:= null;
					end if;

				end if;				
				end;
			end loop;
			close c02;
			end;		
		end if;		
		update	ordem_compra_item
		set	nr_seq_aprovacao	= nr_seq_Aprovacao_w
		where	nr_ordem_compra	= nr_ordem_compra_p
		and	nr_item_oci	= nr_item_oci_w;

		end;
	end if;	
	end;
end loop;
close c01;

begin
CALL avisar_liberacao_oc_reg_preco(nr_ordem_compra_p,cd_estabelecimento_w,nm_usuario_p);
exception
when others then
	cd_estabelecimento_w	:= cd_estabelecimento_w;
end;


if (coalesce(ie_aprova_autom_usuario_p,'S') = 'S') then

	open c03;
	loop
	fetch c03 into
		nr_seq_aprovacao_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		CALL aprovacao_automatica_compra(nr_seq_aprovacao_w, nm_usuario_p);
	end loop;
	close c03;
end if;
	
select	count(*)
into STRICT	nr_items_sem_aprov_w
from	ordem_compra_item
where	coalesce(dt_aprovacao::text, '') = ''
and	nr_ordem_compra = nr_ordem_compra_p;

if (nr_items_sem_aprov_w = 0) then
	
	update	ordem_compra
	set	dt_aprovacao	= clock_timestamp(),
		nm_usuario_aprov	= nm_usuario_p
	where	nr_ordem_compra	= nr_ordem_compra_p;
	
	/*Se aprovou a ordem de compra, ainda verifica para ver se nao ficou nenhum processo de aprovacao pendente*/

	select	count(*)
	into STRICT	qt_existe_w
	from	processo_aprov_compra
	where	ie_aprov_reprov <> 'A'
	and	nr_sequencia in (
		SELECT	distinct nr_seq_aprovacao
		from	ordem_compra_item
		where	nr_ordem_compra = nr_ordem_compra_p);
	
	if (qt_existe_w > 0) then
		update	processo_aprov_compra
		set 	dt_definicao 		= clock_timestamp(),
			ie_aprov_reprov 	= 'A',
			nm_usuario		= nm_usuario_p,
			nm_usuario_aprov 	= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			dt_liberacao		= clock_timestamp()
		where	ie_aprov_reprov	<> 'A'
		and	nr_sequencia in (
			SELECT	distinct nr_seq_aprovacao
			from	ordem_compra_item
			where	nr_ordem_compra = nr_ordem_compra_p);
	end if;	
	
	CALL gerar_comunic_aviso_adiant_oc(nr_ordem_compra_p, nm_usuario_p);
end if;

if (nr_items_sem_aprov_w > 0) then
	begin

	select	coalesce(max(nr_seq_proc_aprov),0)
	into STRICT	nr_seq_proc_email_w
	from	processo_aprov_compra
	where	nr_sequencia = nr_seq_aprovacao_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

	CALL envia_email_proximo_aprov(nr_seq_aprovacao_w,nr_seq_proc_email_w,cd_estabelecimento_w,nm_usuario_p);

	end;
end if;

if (VarEscolherItensBaixados = 'N') then
	CALL baixar_solic_compra_com_ordem(nr_ordem_compra_p);
else
	open C04;
	loop
	fetch C04 into	
		nr_solic_compra_w,
		nr_item_solic_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		CALL baixar_item_sc_com_ordem(nr_ordem_compra_p, nr_solic_compra_w, nr_item_solic_compra_w, nm_usuario_p);
		end;
	end loop;
	close C04;	
end if;	

if (ie_tipo_ordem_w = 'T') then
	CALL gerar_comunic_solic_transf(nr_ordem_compra_p,null,30,nm_usuario_p);
	CALL gerar_email_solic_transf(nr_ordem_compra_p,null,40,nm_usuario_p);
end if;

begin
CALL avisar_liberacao_ordem_compra(nr_ordem_compra_p,cd_estabelecimento_w,nm_usuario_p);
exception when others then
	cd_estabelecimento_w	:= cd_estabelecimento_w;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_aprov_ordem_compra ( nr_ordem_compra_p bigint, cd_perfil_ativo_p bigint, ie_aprova_autom_usuario_p text, nm_usuario_p text) FROM PUBLIC;
