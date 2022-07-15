-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprovar_solic_ordem_compra ( nr_seq_aprovacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_documento_w			bigint;
ie_aprov_reprov_w			varchar(1);
cd_estabelecimento_w		smallint;
ie_comunic_aprovacao_w		varchar(1);
nr_seq_classif_w			bigint;
ds_fornecedor_w			varchar(30);
ds_titulo_oc_w			varchar(80);
ds_titulo_solic_w			varchar(80);
ds_titulo_cot_w			varchar(80);
ds_titulo_req_w			varchar(80);
ds_comunic_req_w			varchar(4000);
ds_comunic_oc_w			varchar(4000);
ds_comunic_oc_ww		varchar(4000);
ds_comunic_solic_w		varchar(4000);
ds_comunic_cot_w			varchar(4000);
dt_entrega_w			timestamp;
ds_itens_w			varchar(4000);
nr_solic_compra_w			bigint;
nr_solic_compra_ww		bigint;
nm_usuario_destino_w		varchar(2000);
nr_seq_comunic_w			bigint;
nr_itens_sem_aprov_w		ordem_compra_item.nr_ordem_compra%type;
qt_regra_usuario_w			varchar(10);
qt_existe_padronizado_w		bigint;
nr_seq_regra_w			bigint := 0;
cd_setor_atendimento_w		integer;
nr_ordem_compra_w		bigint;
qt_existe_w			bigint := 0;
qt_existe_regra_w		bigint := 0;
cd_evento_w			smallint;
cd_perfil_w			varchar(10);
nr_seq_reg_preco_w		bigint;
cd_material_w			integer;
ds_material_w			varchar(255);
ie_vigente_w			varchar(1);
ie_ci_lida_w			varchar(1);
qt_existe_contrato_w		bigint;
ie_forma_compra_w			varchar(10);
ie_gera_cot_oc_aprov_solic_w	varchar(1);
nr_seq_mes_ref_w			bigint;
cd_empresa_w			bigint;
ie_gerar_insp_aprov_oc_w		varchar(1);
nr_seq_licitacao_w			bigint;
nr_seq_lic_item_w			bigint;
qt_material_w			double precision;
qt_saldo_registro_w			double precision;
ie_tipo_documento_w		varchar(15);
cd_perfil_ativo_w			bigint;
ie_norma_compra_w		varchar(1);
qt_rateio_w			bigint;
nr_seq_regra_rateio_w		bigint;

/* Se tiver setor na regra, envia CI para os setores */

ds_setor_adicional_w		varchar(2000) := '';

/* Campos da regra Usuario da Regra */

cd_setor_regra_usuario_w	integer;
ie_empenho_orcamento_w		varchar(10);

c00 CURSOR FOR
SELECT	b.nr_sequencia,
	b.cd_perfil
from	regra_envio_comunic_compra a,
	regra_envio_comunic_evento b
where	a.nr_sequencia = b.nr_seq_regra
and	a.cd_funcao = 267
and	b.cd_evento = cd_evento_w
and	b.ie_situacao = 'A'
and	a.cd_estabelecimento = cd_estabelecimento_w
and	((cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '' AND b.cd_setor_destino = cd_setor_atendimento_w) or
	((coalesce(cd_setor_atendimento_w::text, '') = '') and (coalesce(b.cd_setor_destino::text, '') = '')) or (coalesce(b.cd_setor_destino::text, '') = ''))
and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_documento_w,ie_tipo_documento_w,obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

c01 CURSOR FOR
SELECT	substr(obter_desc_material(a.cd_material),1,50),
	coalesce(b.dt_real_entrega,b.dt_prevista_entrega)
from	ordem_compra_item_entrega b,
	ordem_compra_item a
where	a.nr_ordem_compra = b.nr_ordem_compra
and	a.nr_item_oci = b.nr_item_oci
and	a.nr_ordem_compra = nr_documento_w
and	substr(obter_se_material_estoque(cd_estabelecimento_w,cd_estabelecimento_w,a.cd_material),1,1) = CASE WHEN ie_comunic_aprovacao_w='E' THEN 'S' WHEN ie_comunic_aprovacao_w='M' THEN 'N' END;

c02 CURSOR FOR
SELECT	distinct
	a.cd_material,
	substr(obter_desc_material(a.cd_material),1,255),
	lic_obter_registro_preco(b.nr_seq_licitacao, b.nr_seq_lic_item)
from	solic_compra_item a,
	reg_lic_item_solic b
where	a.nr_solic_compra = b.nr_solic_compra
and	a.nr_item_solic_compra = b.nr_item_solic_compra
and	a.nr_solic_compra = nr_solic_compra_ww
and	(lic_obter_registro_preco(b.nr_seq_licitacao, b.nr_seq_lic_item) IS NOT NULL AND (lic_obter_registro_preco(b.nr_seq_licitacao, b.nr_seq_lic_item))::text <> '')
and	a.nr_seq_aprovacao = nr_seq_aprovacao_p;

c05 CURSOR FOR
SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento
from	regra_envio_comunic_usu a
where	a.nr_seq_evento = nr_seq_regra_w;

c06 CURSOR FOR
SELECT	a.cd_centro_custo,
	b.cd_conta_contabil
from	solic_compra a,
	solic_compra_item b
where	a.nr_solic_compra	= b.nr_solic_compra
and	a.nr_solic_compra	= nr_solic_compra_w;

c07 CURSOR FOR
SELECT	a.nr_seq_licitacao,
	coalesce(b.nr_seq_reg_lic_item,b.nr_seq_lic_item),
	b.cd_material,
	substr(obter_desc_material(b.cd_material),1,255),
	b.qt_material
from	ordem_compra a,
	ordem_compra_item b
where	a.nr_ordem_compra = b.nr_ordem_compra
and	a.nr_ordem_compra = nr_ordem_compra_w
and	(a.nr_seq_licitacao IS NOT NULL AND a.nr_seq_licitacao::text <> '')
and	(coalesce(b.nr_seq_reg_lic_item,b.nr_seq_lic_item) IS NOT NULL AND (coalesce(b.nr_seq_reg_lic_item,b.nr_seq_lic_item))::text <> '');

c08 CURSOR FOR
SELECT	b.nr_sequencia,
	b.cd_perfil
from	regra_envio_comunic_compra a,
	regra_envio_comunic_evento b
where	a.nr_sequencia = b.nr_seq_regra
and	a.cd_funcao = 267
and	b.cd_evento = cd_evento_w
and	b.ie_situacao = 'A'
and	a.cd_estabelecimento = cd_estabelecimento_w
and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_documento_w,ie_tipo_documento_w,obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

vet06	C06%RowType;


BEGIN

cd_perfil_ativo_w	:= obter_perfil_ativo;

select	max(ie_aprov_reprov)
into STRICT	ie_aprov_reprov_w
from	processo_aprov_compra
where 	nr_sequencia = nr_seq_aprovacao_p;

/* Caso nao existam itens pendentes aprovar a ordem de compra */

select	count(*)
into STRICT	nr_itens_sem_aprov_w
from	ordem_compra_item
where (coalesce(coalesce(dt_aprovacao, dt_reprovacao)::text, '') = '')
and	nr_ordem_compra in (
		SELECT	distinct nr_ordem_compra
		from	ordem_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

select	coalesce(max(nr_ordem_compra),0)
into STRICT	nr_documento_w
from	ordem_compra_item
where	nr_seq_aprovacao = nr_seq_aprovacao_p;

select	obter_classif_comunic('F')
into STRICT	nr_seq_classif_w
;

if (nr_itens_sem_aprov_w = 0) and (nr_documento_w > 0) then

	select	coalesce(max(nr_ordem_compra),0)
	into STRICT	nr_ordem_compra_w
	from	ordem_compra
	where	nr_ordem_compra in (
		SELECT	distinct nr_ordem_compra
		from	ordem_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	if (nr_ordem_compra_w > 0) then

		select	cd_estabelecimento,
			cd_setor_atendimento
		into STRICT	cd_estabelecimento_w,
			cd_setor_atendimento_w
		from	ordem_compra
		where	nr_ordem_compra = nr_ordem_compra_w;
	end if;

	select	coalesce(max(nr_solic_compra),0)
	into STRICT	nr_solic_compra_ww
	from	ordem_compra_item
	where	nr_ordem_compra = nr_documento_w;

	if (nr_solic_compra_ww > 0) then

		select	count(*)
		into STRICT	qt_existe_w
		from	reg_lic_item_solic
		where	nr_solic_compra = nr_solic_compra_ww;

		if (qt_existe_w > 0) then

			open C02;
			loop
			fetch C02 into
				cd_material_w,
				ds_material_w,	
				nr_seq_reg_preco_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				select	lic_obter_se_reg_preco_vigente(nr_seq_reg_preco_w)
				into STRICT	ie_vigente_w
				;

				if (ie_vigente_w = 'N') and (ie_aprov_reprov_w = 'A') then
					/*(-20011,'O registro de preco vinculado no material ' || cd_material_w || ' - ' || ds_material_w || ', esta fora da vigencia.');*/

					CALL wheb_mensagem_pck.exibir_mensagem_abort(189956,'CD_MATERIAL=' || cd_material_w || ';DS_MATERIAL=' || ds_material_w);				
				end if;
				end;
			end loop;
			close C02;

		end if;
	end if;	

	if (nr_ordem_compra_w > 0) and (ie_aprov_reprov_w = 'A') then

		open C07;
		loop
		fetch C07 into	
			nr_seq_licitacao_w,
			nr_seq_lic_item_w,		
			cd_material_w,
			ds_material_w,
			qt_material_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
			begin
			qt_saldo_registro_w	:= lic_obter_saldo_item_solic(nr_seq_licitacao_w, nr_seq_lic_item_w);

			if (qt_material_w > qt_saldo_registro_w) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(192417,'CD_MATERIAL=' || cd_material_w || ';DS_MATERIAL=' || ds_material_w);			
			end if;		
			end;
		end loop;
		close C07;
	end if;

	update	ordem_compra
	set	dt_aprovacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_ordem_compra in (
		SELECT	distinct nr_ordem_compra
		from	ordem_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	select	coalesce(max(ie_gerar_insp_aprov_oc),'N')
	into STRICT	ie_gerar_insp_aprov_oc_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (ie_gerar_insp_aprov_oc_w = 'S') then	
		CALL gera_inspecao_aprov_ordem(nr_documento_w,nm_usuario_p);
	end if;

	update	processo_aprov_compra
	set 	dt_definicao 	= clock_timestamp(),
		ie_aprov_reprov 	= 'A',
		nm_usuario	= nm_usuario_p,
		nm_usuario_aprov 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_liberacao	= clock_timestamp(),
		ie_automatico	= 'S'
	where	nr_sequencia	= nr_seq_aprovacao_p
	and	ie_aprov_reprov	not in ('A','R');

	CALL gerar_comunic_aviso_adiant_oc(nr_ordem_compra_w, nm_usuario_p);

	/*Envia email conforme regra de email do compras ( Aprovacoes pendentes - Ao aprovar ordem de compra (Avisa comprador resp. compras) )*/

	select	count(*)
	into STRICT	qt_existe_w
	from	regra_envio_email_compra
	where	ie_tipo_mensagem in (38,64)
	and 	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_w;

	if (ie_aprov_reprov_w = 'A' and qt_existe_w > 0) then
		CALL envia_email_aprov_ordem_comp(nr_documento_w, cd_estabelecimento_w, nm_usuario_p);
	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	ordem_compra_item a
	where	nr_seq_aprovacao = nr_seq_aprovacao_p
	and	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');

	if (qt_existe_w > 0) then
		CALL gerar_seq_doc_interno_oc(nr_ordem_compra_w,nm_usuario_p);
	end if;

	ie_tipo_documento_w	:= 'OC';	
	cd_evento_w := 1;

	select	count(*)
	into STRICT	qt_existe_w
	from	regra_envio_comunic_compra a,
		regra_envio_comunic_evento b
	where	a.nr_sequencia = b.nr_seq_regra
	and	a.cd_funcao = 267
	and	b.cd_evento = 1
	and	b.ie_situacao = 'A'
	and	a.cd_estabelecimento = cd_estabelecimento_w;

	if (qt_existe_w > 0) then
		open C00;
		loop
		fetch C00 into	
			nr_seq_regra_w,
			cd_perfil_w;
		EXIT WHEN NOT FOUND; /* apply on C00 */
			begin

			open C05;
			loop
			fetch C05 into	
				cd_setor_regra_usuario_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then
					ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
				end if;
				end;
			end loop;
			close C05;

			select	max(substr(obter_usuario_pessoa(cd_pessoa_solicitante),1,15))
			into STRICT	nm_usuario_destino_w
			from	ordem_compra
			where 	nr_ordem_compra	= nr_ordem_compra_w;		

			select	ie_comunic_aprovacao
			into STRICT 	ie_comunic_aprovacao_w
			from	parametro_compras
			where	cd_estabelecimento = cd_estabelecimento_w;

			if (ie_comunic_aprovacao_w in ('E','M')) then
				open C01;
				loop
				fetch C01 into
					ds_itens_w,
					dt_entrega_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
					ds_itens_w 		:= substr(rpad(/*Data entrega: */
wheb_mensagem_pck.get_texto(297388) || dt_entrega_w,30,' ') || ds_itens_w || chr(10),1,4000);
					ds_comunic_oc_ww 	:= substr(ds_comunic_oc_w || ds_itens_w, 1, 4000);
				end loop;
				close C01;
			end if;

			if (ie_aprov_reprov_w = 'A') and (ie_comunic_aprovacao_w in ('S','E','M')) then

				select	substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 1 , nr_seq_regra_w,'T'),1,2000) ds_titulo,
					substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 1, nr_seq_regra_w, 'M'),1,2000) ds_comunicacao
				into STRICT	ds_titulo_oc_w,
					ds_comunic_oc_w
				;

				select	coalesce(ie_ci_lida,'N')
				into STRICT	ie_ci_lida_w
				from 	regra_envio_comunic_evento
				where 	nr_sequencia = nr_seq_regra_w;

				select	count(*)
				into STRICT	qt_regra_usuario_w
				from	regra_envio_comunic_compra a,
					regra_envio_comunic_evento b,
					regra_envio_comunic_usu c
				where	a.nr_sequencia = b.nr_seq_regra
				and	b.nr_sequencia = c.nr_seq_evento
				and	b.nr_sequencia = nr_seq_regra_w;

				if (qt_regra_usuario_w > 0) then
					nm_usuario_destino_w := obter_usuarios_comunic_compras(nr_seq_aprovacao_p,null,1,nr_seq_regra_w,'');
				end if;	



				if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then

					select	nextval('comunic_interna_seq')
					into STRICT	nr_seq_comunic_w
					;

					if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
						cd_perfil_w := cd_perfil_w ||',';
					end if;

					insert	into comunic_interna(
						dt_comunicado,		ds_titulo,			ds_comunicado,
						nm_usuario,		dt_atualizacao,		ie_geral,
						nm_usuario_destino,	nr_sequencia,		ie_gerencial,
						nr_seq_classif,		dt_liberacao,		ds_perfil_adicional,
						ds_setor_adicional)
					values (	clock_timestamp(),			ds_titulo_oc_w,		substr(ds_comunic_oc_ww || ds_comunic_oc_w,1,4000),
						nm_usuario_p,		clock_timestamp(),			'N',
						nm_usuario_destino_w,	nr_seq_comunic_w,		'N',
						nr_seq_classif_w,		clock_timestamp(),			cd_perfil_w,
						ds_setor_adicional_w);

					/*Para que a comunicacao seja gerada como lida ao proprio usuario que esta fazendo a aprovacao*/

					if (ie_ci_lida_w = 'S') then
						insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao) values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
					end if;

				end if;
			end if;
			end;
		end loop;
		close C00;
	end if;

	if (ie_aprov_reprov_w = 'A') and (ie_comunic_aprovacao_w in ('S','E','M')) then

		ie_tipo_documento_w	:= 'OC';
		cd_evento_w := 11;

		select	count(*)
		into STRICT	qt_existe_w
		from	regra_envio_comunic_compra a,
			regra_envio_comunic_evento b
		where	a.nr_sequencia = b.nr_seq_regra
		and	a.cd_funcao = 267
		and	b.cd_evento = 11
		and	b.ie_situacao = 'A'
		and	a.cd_estabelecimento = cd_estabelecimento_w;

		if (qt_existe_w > 0) then
			open C00;
			loop
			fetch C00 into	
				nr_seq_regra_w,
				cd_perfil_w;
			EXIT WHEN NOT FOUND; /* apply on C00 */
				begin

				select	count(*)
				into STRICT	qt_existe_padronizado_w
				from	ordem_compra_item
				where	nr_ordem_compra = nr_documento_w
				and	obter_se_material_padronizado(cd_estabelecimento_w,cd_material) = 'N';	

				if (qt_existe_padronizado_w > 0) then

					ds_titulo_oc_w := '';
					ds_comunic_oc_w := '';

					select	substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 11, nr_seq_regra_w,'T'),1,2000) ds_titulo,
						substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 11, nr_seq_regra_w, 'M'),1,2000) ds_comunicacao
					into STRICT	ds_titulo_oc_w,
						ds_comunic_oc_w
					;

					select	count(*)
					into STRICT	qt_regra_usuario_w
					from	regra_envio_comunic_compra a,
						regra_envio_comunic_evento b,
						regra_envio_comunic_usu c
					where	a.nr_sequencia = b.nr_seq_regra
					and	b.nr_sequencia = c.nr_seq_evento
					and	b.nr_sequencia = nr_seq_regra_w;

					select	coalesce(ie_ci_lida,'N')
					into STRICT	ie_ci_lida_w
					from 	regra_envio_comunic_evento
					where 	nr_sequencia = nr_seq_regra_w;

					nm_usuario_destino_w := '';

					if (qt_regra_usuario_w > 0) then
						nm_usuario_destino_w := obter_usuarios_comunic_compras(nr_seq_aprovacao_p,null,11,nr_seq_regra_w,'');
					end if;

					if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then

						select	nextval('comunic_interna_seq')
						into STRICT	nr_seq_comunic_w
						;

						if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
							cd_perfil_w := cd_perfil_w ||',';
						end if;

						insert	into comunic_interna(		
							dt_comunicado,			ds_titulo,				ds_comunicado,
							nm_usuario,			dt_atualizacao,			ie_geral,
							nm_usuario_destino,		nr_sequencia,			ie_gerencial,
							nr_seq_classif,			dt_liberacao,			ds_perfil_adicional)
						values (	clock_timestamp(),				ds_titulo_oc_w,			ds_comunic_oc_w,
							nm_usuario_p,			clock_timestamp(),				'N',
							nm_usuario_destino_w,		nr_seq_comunic_w,			'N',
							nr_seq_classif_w,			clock_timestamp(),			cd_perfil_w);

						/*Para que a comunicacao seja gerada como lida ao proprio usuario que esta fazendo a aprovacao*/

						if (ie_ci_lida_w = 'S') then
							insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao) values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
						end if;

					end if;
				end if;
			end;
			end loop;
			close C00;
		end if;
	end if;

end if;

/* Caso nao existam itens pendentes Autorizar a Solicitacao de compra */

select	count(*)
into STRICT	nr_itens_sem_aprov_w
from	solic_compra_item
where (coalesce(coalesce(dt_autorizacao, dt_reprovacao)::text, '') = '')
and	nr_solic_compra = (
		SELECT	distinct nr_solic_compra
		from	Solic_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

select	coalesce(max(nr_solic_compra),0)
into STRICT	nr_documento_w
from	solic_compra_item
where	nr_seq_aprovacao = nr_seq_aprovacao_p;

if (nr_itens_sem_aprov_w = 0) and (nr_documento_w > 0) then

	select	nr_solic_compra,
		cd_estabelecimento,
		cd_setor_atendimento
	into STRICT	nr_solic_compra_w,
		cd_estabelecimento_w,
		cd_setor_atendimento_w
	from	solic_compra
	where	nr_solic_compra	in (
		SELECT	distinct nr_solic_compra
		from	Solic_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	update	solic_compra
	set	dt_autorizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_solic_compra	in (
		SELECT	distinct nr_solic_compra
		from	Solic_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	select	coalesce((max(obter_valor_param_usuario(267, 53, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_w))),'N')
	into STRICT	ie_norma_compra_w
	;

	if (ie_norma_compra_w = 'S') then
		CALL atualizar_norma_compra_solic(nr_solic_compra_w, 'A', nm_usuario_p);
	end if;

	update	processo_aprov_compra
	set 	dt_definicao 	= clock_timestamp(),
		ie_aprov_reprov 	= 'A',
		nm_usuario	= nm_usuario_p,
		nm_usuario_aprov 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_liberacao	= clock_timestamp(),
		ie_automatico	= 'S'
	where	nr_sequencia	= nr_seq_aprovacao_p
	and	ie_aprov_reprov	not in ('A','R');

	select	ie_comunic_aprovacao,
		ie_gera_cot_oc_aprov_solic
	into STRICT 	ie_comunic_aprovacao_w,
		ie_gera_cot_oc_aprov_solic_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_w;

	select	coalesce(max(ie_empenho_orcamento),'N')
	into STRICT	ie_empenho_orcamento_w
	from	parametro_estoque
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (ie_empenho_orcamento_w = 'S') then
		begin
		CALL gerar_empenho_solic_compra(nr_solic_compra_w, nm_usuario_p);
		end;
	end if;

	if (ie_gera_cot_oc_aprov_solic_w = 'S') then

		select	lic_obter_tipo_forma_compra(nr_seq_forma_compra)
		into STRICT	ie_forma_compra_w
		from	solic_compra
		where	nr_solic_compra = nr_solic_compra_w;

		select	count(*)
		into STRICT	qt_existe_contrato_w
		from	solic_compra_item
		where	nr_solic_compra = nr_solic_compra_w
		and	(nr_contrato IS NOT NULL AND nr_contrato::text <> '');

		if (qt_existe_contrato_w > 0) and (ie_forma_compra_w = 'C') then

			CALL gerar_cot_ordem_sc_contrato(	nr_seq_aprovacao_p,
							nr_solic_compra_w,
							nm_usuario_p);	
		end if;
	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	solic_compra_item
	where	nr_solic_compra = nr_documento_w
	and	(nr_seq_aprovacao IS NOT NULL AND nr_seq_aprovacao::text <> '')
	and	(dt_autorizacao IS NOT NULL AND dt_autorizacao::text <> '');

	select	count(*)
	into STRICT	qt_existe_regra_w
	from	regra_envio_email_compra
	where	ie_tipo_mensagem = 56
	and	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_w;

	if (qt_existe_w > 0) and (qt_existe_regra_w > 0) then
		begin

		sup_avisa_fim_aprovacao(nr_documento_w,nm_usuario_p);

		end;
	end if;	

	select	count(*)
	into STRICT	qt_existe_w
	from	solic_compra_item
	where	nr_solic_compra = nr_documento_w
	and	(nr_seq_aprovacao IS NOT NULL AND nr_seq_aprovacao::text <> '')
	and	(dt_autorizacao IS NOT NULL AND dt_autorizacao::text <> '');

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_regra_rateio_w
	from	regra_envio_email_compra
	where	ie_tipo_mensagem in (75)
	and 	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_w;

	if (nr_seq_regra_rateio_w > 0) then	

		select	count(*)
		into STRICT	qt_rateio_w
		from	solic_compra a,
			solic_compra_item_rateio b,
			centro_custo_resp c
		where	a.nr_solic_compra = b.nr_solic_compra
		and	b.cd_centro_custo = c.cd_centro_custo
		and	(b.vl_rateio IS NOT NULL AND b.vl_rateio::text <> '')
		and	(b.cd_centro_custo IS NOT NULL AND b.cd_centro_custo::text <> '')
		and	a.nr_solic_compra = nr_documento_w
		and	ie_tipo_servico in ('SP','SR')
		and	(a.dt_autorizacao IS NOT NULL AND a.dt_autorizacao::text <> '');
	end if;

	select	count(*)
	into STRICT	qt_existe_regra_w
	from	regra_envio_email_compra
	where	ie_tipo_mensagem = 57
	and	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_w;

	if (qt_existe_regra_w > 0) and (qt_existe_w > 0) and (coalesce(qt_rateio_w,0) = 0) then
		begin	
		CALL sup_avisa_aprov_solic_regra(nr_documento_w,nm_usuario_p);
		end;
	end if;	

	ie_tipo_documento_w	:= 'SC';
	cd_evento_w := 1;

	select	count(*)
	into STRICT	qt_existe_w
	from	regra_envio_comunic_compra a,
		regra_envio_comunic_evento b
	where	a.nr_sequencia = b.nr_seq_regra
	and	a.cd_funcao = 267
	and	b.cd_evento = 1
	and	b.ie_situacao = 'A'
	and	a.cd_estabelecimento = cd_estabelecimento_w;

	if (qt_existe_w > 0) then

		open C00;
		loop
		fetch C00 into	
			nr_seq_regra_w,
			cd_perfil_w;
		EXIT WHEN NOT FOUND; /* apply on C00 */
			begin

			select	substr(obter_usuario_pessoa(cd_pessoa_solicitante),1,15)
			into STRICT  	nm_usuario_destino_w
			from	solic_compra
			where	nr_solic_compra	= nr_solic_compra_w;		

			if (ie_aprov_reprov_w = 'A') and (ie_comunic_aprovacao_w in ('S','E','M')) then

				ds_titulo_oc_w := '';
				ds_comunic_oc_w := '';

				select	substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 1, nr_seq_regra_w,'T'),1,80) ds_titulo,
					substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 1, nr_Seq_regra_w,'M'),1,2000) ds_comunicacao
				into STRICT	ds_titulo_solic_w,
					ds_comunic_solic_w
				;

				select	count(*)
				into STRICT	qt_regra_usuario_w
				from	regra_envio_comunic_compra a,
					regra_envio_comunic_evento b,
					regra_envio_comunic_usu c
				where	a.nr_sequencia = b.nr_seq_regra
				and	b.nr_sequencia = c.nr_seq_evento
				and	b.nr_sequencia = nr_seq_regra_w;

				select	coalesce(ie_ci_lida,'N')
				into STRICT	ie_ci_lida_w
				from 	regra_envio_comunic_evento
				where 	nr_sequencia = nr_seq_regra_w;

				if (qt_regra_usuario_w > 0) then
					nm_usuario_destino_w := obter_usuarios_comunic_compras(nr_seq_aprovacao_p,null,1,nr_seq_regra_w,'');
				end if;

				if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then

					select	nextval('comunic_interna_seq')
					into STRICT	nr_seq_comunic_w
					;

					if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
						cd_perfil_w := cd_perfil_w ||',';
					end if;

					insert	into comunic_interna(
						dt_comunicado,			ds_titulo,			ds_comunicado,
						nm_usuario,			dt_atualizacao,		ie_geral,
						nm_usuario_destino,		nr_sequencia,		ie_gerencial,
						nr_seq_classif,			dt_liberacao,		ds_perfil_adicional)
					values (	clock_timestamp(),				ds_titulo_solic_w,		ds_comunic_solic_w,
						nm_usuario_p,			clock_timestamp(),			'N',
						nm_usuario_destino_w,		nr_seq_comunic_w,		'N',
						nr_seq_classif_w,			clock_timestamp(),			cd_perfil_w);

					/*Para que a comunicacao seja gerada como lida ao proprio usuario que esta fazendo a aprovacao*/

					if (ie_ci_lida_w = 'S') then
						insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao) values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
					end if;

				end if;
			end if;		
			end;
		end loop;
		close C00;
	end if;
end if;

/* Caso nao existam itens pendentes Autorizar a requisicao*/

select	count(*)
into STRICT	nr_itens_sem_aprov_w
from	item_requisicao_material
where (coalesce(coalesce(dt_aprovacao, dt_reprovacao)::text, '') = '')
and	nr_requisicao = (
		SELECT	distinct nr_requisicao
		from	item_requisicao_material
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

begin
	select	coalesce(max(nr_requisicao),0),
		max(cd_estabelecimento)
	into STRICT	nr_documento_w,
		cd_estabelecimento_w
	from	item_requisicao_material
	where	nr_seq_aprovacao = nr_seq_aprovacao_p;
exception when others then
	nr_documento_w := 0;
end;

if (cd_estabelecimento_w > 0) then

	select	ie_comunic_aprovacao
	into STRICT 	ie_comunic_aprovacao_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_w;
end if;

if (nr_itens_sem_aprov_w = 0) and (nr_documento_w > 0) then

	update	requisicao_material
	set	dt_aprovacao = clock_timestamp(),
		nm_usuario_aprov = nm_usuario_p
	where	nr_requisicao	in (
		SELECT	distinct nr_requisicao
		from	item_requisicao_material
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	update	processo_aprov_compra
	set 	dt_definicao 	= clock_timestamp(),
		ie_aprov_reprov 	= 'A',
		nm_usuario	= nm_usuario_p,
		nm_usuario_aprov 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_liberacao	= clock_timestamp(),
		ie_automatico	= 'S'
	where	nr_sequencia	= nr_seq_aprovacao_p
	and	ie_aprov_reprov	not in ('A','R');

	cd_evento_w := 1;


	open C00;
	loop
	fetch C00 into	
		nr_seq_regra_w,
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C00 */
		begin

		if (ie_aprov_reprov_w = 'A') and (ie_comunic_aprovacao_w in ('S','E','M')) then

			ds_titulo_req_w := '';
			ds_comunic_req_w := '';

			select	substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 1, nr_seq_regra_w,'T'),1,80) ds_titulo,
				substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 1, nr_Seq_regra_w,'M'),1,2000) ds_comunicacao
			into STRICT	ds_titulo_req_w,
				ds_comunic_req_w
			;

			select	count(*)
			into STRICT	qt_regra_usuario_w
			from	regra_envio_comunic_compra a,
				regra_envio_comunic_evento b,
				regra_envio_comunic_usu c
			where	a.nr_sequencia = b.nr_seq_regra
			and	b.nr_sequencia = c.nr_seq_evento
			and	b.nr_sequencia = nr_seq_regra_w;

			select	coalesce(ie_ci_lida,'N')
			into STRICT	ie_ci_lida_w
			from 	regra_envio_comunic_evento
			where 	nr_sequencia = nr_seq_regra_w;

			if (qt_regra_usuario_w > 0) then
				nm_usuario_destino_w := obter_usuarios_comunic_compras(nr_seq_aprovacao_p,null,1,nr_seq_regra_w,'');
			end if;

			if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then

				select	nextval('comunic_interna_seq')
				into STRICT	nr_seq_comunic_w
				;

				if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
					cd_perfil_w := cd_perfil_w ||',';
				end if;

				insert	into comunic_interna(
					dt_comunicado,			ds_titulo,		ds_comunicado,
					nm_usuario,			dt_atualizacao,		ie_geral,
					nm_usuario_destino,		nr_sequencia,		ie_gerencial,
					nr_seq_classif,			dt_liberacao,		ds_perfil_adicional)
				values (	clock_timestamp(),			ds_titulo_req_w,	ds_comunic_req_w,
					nm_usuario_p,			clock_timestamp(),		'N',
					nm_usuario_destino_w,		nr_seq_comunic_w,	'N',
					nr_seq_classif_w,		clock_timestamp(),		cd_perfil_w);

				/*Para que a comunicacao seja gerada como lida ao proprio usuario que esta fazendo a aprovacao*/

				if (ie_ci_lida_w = 'S') then
					insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao) values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
				end if;

			end if;
		end if;		
		end;
	end loop;
	close C00;


end if;

/* Caso nao existam itens pendentes Autorizar a cotacao de compras*/

select	count(*)
into STRICT	nr_itens_sem_aprov_w
from	cot_compra_item
where (coalesce(coalesce(dt_aprovacao, dt_reprovacao)::text, '') = '')
and	nr_cot_compra = (
		SELECT	distinct nr_cot_compra
		from	cot_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p)
and	(nr_seq_aprovacao IS NOT NULL AND nr_seq_aprovacao::text <> '');

select	coalesce(max(nr_cot_compra),0)
into STRICT	nr_documento_w
from	cot_compra_item
where	nr_seq_aprovacao = nr_seq_aprovacao_p;

if (nr_itens_sem_aprov_w = 0) and (nr_documento_w > 0) then

	update	cot_compra
	set	dt_aprovacao = clock_timestamp(),
		nm_usuario_aprov = nm_usuario_p
	where	nr_cot_compra	in (
		SELECT	distinct nr_cot_compra
		from	cot_compra_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	update	processo_aprov_compra
	set 	dt_definicao 	= clock_timestamp(),
		ie_aprov_reprov 	= 'A',
		nm_usuario	= nm_usuario_p,
		nm_usuario_aprov 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_liberacao	= clock_timestamp(),
		ie_automatico	= 'S'
	where	nr_sequencia	= nr_seq_aprovacao_p
	and	ie_aprov_reprov	not in ('A','R');

	select	substr(obter_usuario_pessoa(cd_pessoa_solicitante),1,15),
		cd_estabelecimento
	into STRICT  	nm_usuario_destino_w,
		cd_estabelecimento_w
	from	cot_compra
	where	nr_cot_compra = nr_documento_w;

	select	ie_comunic_aprovacao
	into STRICT 	ie_comunic_aprovacao_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_w;

	ie_tipo_documento_w	:= 'CC';
	cd_evento_w := 71;

	open C08;
	loop
	fetch C08 into	
		nr_seq_regra_w,
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
		begin

		if (ie_aprov_reprov_w = 'A') and (ie_comunic_aprovacao_w in ('S','E','M')) then

			ds_titulo_cot_w := '';
			ds_comunic_cot_w := '';

			select	substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 71, nr_seq_regra_w,'T'),1,80) ds_titulo,
				substr(obter_dados_regra_com_compra(nr_seq_aprovacao_p, null, 267, 71, nr_Seq_regra_w,'M'),1,2000) ds_comunicacao
			into STRICT	ds_titulo_cot_w,
				ds_comunic_cot_w
			;

			select	count(*)
			into STRICT	qt_regra_usuario_w
			from	regra_envio_comunic_compra a,
				regra_envio_comunic_evento b,
				regra_envio_comunic_usu c
			where	a.nr_sequencia = b.nr_seq_regra
			and	b.nr_sequencia = c.nr_seq_evento
			and	b.nr_sequencia = nr_seq_regra_w;

			select	coalesce(ie_ci_lida,'N')
			into STRICT	ie_ci_lida_w
			from 	regra_envio_comunic_evento
			where 	nr_sequencia = nr_seq_regra_w;

			if (qt_regra_usuario_w > 0) then
				nm_usuario_destino_w := obter_usuarios_comunic_compras(nr_seq_aprovacao_p,null,71,nr_seq_regra_w,'');
			end if;

			if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then

				select	nextval('comunic_interna_seq')
				into STRICT	nr_seq_comunic_w
				;

				if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
					cd_perfil_w := cd_perfil_w ||',';
				end if;

				insert	into comunic_interna(
					dt_comunicado,			ds_titulo,		ds_comunicado,
					nm_usuario,			dt_atualizacao,		ie_geral,
					nm_usuario_destino,		nr_sequencia,		ie_gerencial,
					nr_seq_classif,			dt_liberacao,		ds_perfil_adicional)
				values (	clock_timestamp(),			ds_titulo_cot_w,	ds_comunic_cot_w,
					nm_usuario_p,			clock_timestamp(),		'N',
					nm_usuario_destino_w,		nr_seq_comunic_w,	'N',
					nr_seq_classif_w,		clock_timestamp(),		cd_perfil_w);

				/*Para que a comunicacao seja gerada como lida ao proprio usuario que esta fazendo a aprovacao*/

				if (ie_ci_lida_w = 'S') then
					insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao) values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
				end if;

			end if;
		end if;		
		end;
	end loop;
	close C08;

	select	count(*)
	into STRICT	qt_existe_w
	from	regra_envio_email_compra
	where	ie_tipo_mensagem = 81
	and	ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_w;

	if (qt_existe_w > 0) then	
		CALL avisa_aprovacao_cot_compra(nr_documento_w,nm_usuario_p);
	end if;
end if;

/* Caso nao existam itens pendentes Autorizar a nota fiscal*/

select	count(*)
into STRICT	nr_itens_sem_aprov_w
from	nota_fiscal_item
where (coalesce(coalesce(dt_aprovacao, dt_reprovacao)::text, '') = '')
and	nr_sequencia in (
		SELECT	distinct nr_sequencia
		from	nota_fiscal_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p)
and	(nr_seq_aprovacao IS NOT NULL AND nr_seq_aprovacao::text <> '');
/*and	nr_sequencia = (
		select	distinct nr_sequencia
		from	nota_fiscal
		where	nr_seq_aprovacao = nr_seq_aprovacao_p)*/
		

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_documento_w
from	nota_fiscal_item
where	nr_seq_aprovacao = nr_seq_aprovacao_p;

if (nr_itens_sem_aprov_w = 0) and (nr_documento_w > 0) then

	update	nota_fiscal
	set	dt_aprovacao = clock_timestamp(),
		nm_usuario_aprov = nm_usuario_p
	where	nr_sequencia	in (
		SELECT	distinct nr_sequencia
		from	nota_fiscal_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	update	processo_aprov_compra
	set 	dt_definicao 	= clock_timestamp(),
		ie_aprov_reprov 	= 'A',
		nm_usuario	= nm_usuario_p,
		nm_usuario_aprov 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_liberacao	= clock_timestamp(),
		ie_automatico	= 'S'
	where	nr_sequencia	= nr_seq_aprovacao_p
	and	ie_aprov_reprov	not in ('A','R');
end if;


/* Caso nao existam itens pendentes Autorizar no registro licitacao*/

select	count(*)
into STRICT	nr_itens_sem_aprov_w
from	reg_lic_item
where (coalesce(coalesce(dt_aprovacao, dt_reprovacao)::text, '') = '')
and	nr_seq_licitacao = (
		SELECT	distinct nr_seq_licitacao
		from	reg_lic_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p)
and	(nr_seq_aprovacao IS NOT NULL AND nr_seq_aprovacao::text <> '');

select	coalesce(max(nr_seq_licitacao),0)
into STRICT	nr_documento_w
from	reg_lic_item
where	nr_seq_aprovacao = nr_seq_aprovacao_p;

if (nr_itens_sem_aprov_w = 0) and (nr_documento_w > 0) then

	update	reg_licitacao
	set	dt_aprovacao = clock_timestamp(),
		nm_usuario_aprov = nm_usuario_p
	where	nr_sequencia in (
		SELECT	distinct nr_seq_licitacao
		from	reg_lic_item
		where	nr_seq_aprovacao = nr_seq_aprovacao_p);

	update	processo_aprov_compra
	set 	dt_definicao 	= clock_timestamp(),
		ie_aprov_reprov 	= 'A',
		nm_usuario	= nm_usuario_p,
		nm_usuario_aprov 	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_liberacao	= clock_timestamp(),
		ie_automatico	= 'S'
	where	nr_sequencia	= nr_seq_aprovacao_p
	and	ie_aprov_reprov	not in ('A','R');
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprovar_solic_ordem_compra ( nr_seq_aprovacao_p bigint, nm_usuario_p text) FROM PUBLIC;

