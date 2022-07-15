-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_preco_venda (CD_ESTABELECIMENTO_P bigint, CD_TAB_PRECO_MAT_P bigint, CD_MATERIAL_P bigint, DT_INICIO_VIGENCIA_P timestamp, VL_PRECO_VENDA_P bigint, CD_MOEDA_P bigint, NR_SEQUENCIA_NF_P bigint, NR_ITEM_NF_P bigint, IE_ACAO_NF_P text, nm_usuario_p text) AS $body$
DECLARE


dt_atualizacao_w        	timestamp 			:= clock_timestamp();
ie_preco_maior_w		varchar(1)		:= 'N';
ie_preco_maior_tab_w		varchar(1)		:= 'N';
nr_seq_estorno_w		bigint		:= 0;
vl_preco_atual_w		double precision		:= 0;
ie_grava_w			varchar(1)		:= 'S';
qt_dependente_w			bigint		:= 0;
ie_situacao_w			varchar(1)		:= 'A';
atualiza_conversao_w		varchar(1)		:= 'N';
qt_conversao_w			double precision		:= null;
cd_cgc_emitente_w		varchar(14);
ie_gravar_cgc_fornec_w		varchar(1);

BEGIN
ie_grava_w				:= 'S';
atualiza_conversao_w	:= coalesce(obter_valor_param_usuario(3110,49,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'N');
ie_gravar_cgc_fornec_w	:= coalesce(obter_valor_param_usuario(40,293,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'N');
/* Parâmetro que define se grava somente quando preço maior que último informado */

begin
select	coalesce(vl_parametro,vl_parametro_padrao)
into STRICT	ie_preco_maior_w
from	funcao_parametro
where	cd_funcao	= 40
and	nr_sequencia	= 2;
exception
      	when others then
           	ie_preco_maior_w := 'S';
end;

select	coalesce(max(ie_ultima_compra), 'S')
into STRICT	ie_preco_maior_tab_w
from	tabela_preco_material
where	cd_tab_preco_mat	= cd_tab_preco_mat_p
and 	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_preco_maior_w	= 'T') then
	ie_preco_maior_w	:= ie_preco_maior_tab_w;
end if;

if (ie_gravar_cgc_fornec_w = 'S') then
	select	max(cd_cgc_emitente)
	into STRICT	cd_cgc_emitente_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_nf_p;
else
	cd_cgc_emitente_w	:= '';
end if;

/* Atualiza estorno */

if (ie_acao_nf_p in (2,3)) then
	BEGIN
	begin
	select	nr_sequencia_ref
	into STRICT	nr_seq_estorno_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_nf_p;
	exception
      		when others then
           		nr_seq_estorno_w := 0;
 	end;

	if (nr_seq_estorno_w > 0) then
			begin
			update	preco_material
			set	ie_situacao = 'I'
			where	cd_estabelecimento	= cd_estabelecimento_p
			and	cd_tab_preco_mat		= cd_tab_preco_mat_p
			and	cd_material			= cd_material_p
			and	nr_sequencia_nf		= nr_seq_estorno_w;
			exception
      				when others then
           				nr_seq_estorno_w := nr_seq_estorno_w;
 			end;
	end if;
	END;
end if;


/* INCLUSÃO NORMAL */

if (ie_acao_nf_p  = 1 ) 		and (ie_preco_maior_w	= 'S') 	then
		begin
		select	a.vl_preco_venda
		into STRICT	vl_preco_atual_w
		from	preco_material a
		where	a.cd_estabelecimento	= cd_estabelecimento_p
		and	a.cd_tab_preco_mat	= cd_tab_preco_mat_p
		and	a.cd_material		= cd_material_p
		and	a.ie_situacao		= 'A'
		and	a.dt_inicio_vigencia	= (
				SELECT	max(x.dt_inicio_vigencia)
				from	preco_material x
				where	x.cd_estabelecimento	= cd_estabelecimento_p
				and	x.cd_tab_preco_mat	= cd_tab_preco_mat_p
				and	x.cd_material		= cd_material_p
				and	x.ie_situacao		= 'A');
		exception
      			when others then
           			vl_preco_atual_w := 0;
		end;
end if;

if (ie_acao_nf_p  = 1 ) 				and (ie_preco_maior_w	= 'S') 			and (vl_preco_atual_w >= vl_preco_venda_p)	then
		ie_grava_w	:= 'N';
end if;

if (ie_acao_nf_p  = 1 ) 				and (ie_grava_w	= 'S') 				then
		BEGIN

		if (coalesce(atualiza_conversao_w,'N') = 'S') then
			begin
			select	qt_conversao
			into STRICT	qt_conversao_w
			from	preco_material
			where	cd_estabelecimento	= cd_estabelecimento_p
			and	cd_tab_preco_mat	= cd_tab_preco_mat_p
			and	cd_material		= cd_material_p
			and	ie_situacao		= 'A'
			and	dt_inicio_vigencia	= (
					SELECT	max(x.dt_inicio_vigencia)
					from	preco_material x
					where	x.cd_estabelecimento	= cd_estabelecimento_p
					and	x.cd_tab_preco_mat	= cd_tab_preco_mat_p
					and	x.cd_material		= cd_material_p
					and	x.ie_situacao		= 'A');
			exception
				when others then
				qt_conversao_w:=null;
			end;
		end if;


		insert	into preco_material(cd_estabelecimento,cd_tab_preco_mat,cd_material,
				dt_inicio_vigencia,vl_preco_venda,cd_moeda,
				ie_brasindice,dt_atualizacao,nm_usuario,
				cd_unidade_medida,ie_situacao,
				nr_sequencia_nf,nr_item_nf, qt_conversao, cd_cgc_fornecedor)
		values (cd_estabelecimento_p,cd_tab_preco_mat_p,cd_material_p,
				dt_inicio_vigencia_p,vl_preco_venda_p,cd_moeda_p,
				'N',dt_atualizacao_w,nm_usuario_p,null,'A',
				nr_sequencia_nf_p,nr_item_nf_p, qt_conversao_w, cd_cgc_emitente_w);
          exception
             when others then
				begin
				update	preco_material
				set	vl_preco_venda	= vl_preco_venda_p,
					dt_atualizacao	= dt_atualizacao_w,
					nr_sequencia_nf	= nr_sequencia_nf_p,
					nr_item_nf		= nr_item_nf_p,
					cd_cgc_fornecedor	= cd_cgc_emitente_w,
 					ie_situacao 	= 'A',
					nm_usuario	= nm_usuario_p
				where	cd_estabelecimento	= cd_estabelecimento_p
				and	cd_tab_preco_mat		= cd_tab_preco_mat_p
				and	cd_material			= cd_material_p
				and	dt_inicio_vigencia	= dt_inicio_vigencia_p;
				exception
      					when others then
           					ie_grava_w := ie_grava_w;

				end;
		END;
end if;

/* atualiza materiais dependentes */

qt_dependente_w	:= 0;
select	count(*)
into STRICT	qt_dependente_w
from	material_preco_nf
where	cd_material_pai	= cd_material_p;

if (qt_dependente_w	> 0) then
	begin
	if (ie_acao_nf_p in (2,3)) and (nr_seq_estorno_w > 0) then
		begin
		CALL Atualiza_Preco_Venda_Result(
			cd_material_p,
			cd_estabelecimento_p,
			cd_tab_preco_mat_p,
			dt_inicio_vigencia_p,
			vl_preco_venda_p,
			cd_moeda_p,
			'N',
			null,
			'I',
			nr_seq_estorno_w,
			nr_item_nf_p,
			cd_cgc_emitente_w,
			nm_usuario_p);
		end;
	end if;
	if (ie_acao_nf_p  = 1 ) 	and (ie_grava_w	= 'S') 	then
		begin
		CALL Atualiza_Preco_Venda_Result(
			cd_material_p,
			cd_estabelecimento_p,
			cd_tab_preco_mat_p,
			dt_inicio_vigencia_p,
			vl_preco_venda_p,
			cd_moeda_p,
			'N',
			null,
			'A',
			nr_sequencia_nf_p,
			nr_item_nf_p,
			cd_cgc_emitente_w,
			nm_usuario_p);
		end;
	end if;
	end;
end if;

begin
delete	from material_preco_dia
where	cd_material = cd_material_p;
exception
      	when others then
           	ie_grava_w := ie_grava_w;
end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_preco_venda (CD_ESTABELECIMENTO_P bigint, CD_TAB_PRECO_MAT_P bigint, CD_MATERIAL_P bigint, DT_INICIO_VIGENCIA_P timestamp, VL_PRECO_VENDA_P bigint, CD_MOEDA_P bigint, NR_SEQUENCIA_NF_P bigint, NR_ITEM_NF_P bigint, IE_ACAO_NF_P text, nm_usuario_p text) FROM PUBLIC;

