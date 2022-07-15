-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bionexo_desdobrar_cot_compra ( nr_cot_compra_p bigint, cd_estabelecimento_p bigint, xml_p text, nr_cot_compra_nova_p INOUT bigint, ds_erro_p INOUT text ) AS $body$
DECLARE

						
/* Procedure utilizada na integracao Bionexo - Reposicao de contratos */

xml_w				xml;
xsl_w				xml;
qt_registro_w			bigint;
qt_existe_entrega_w		bigint;
dt_vencimento_w			varchar(40);
ds_erro_w			varchar(1000);
nr_cot_compra_w			cot_compra.nr_cot_compra%type;
nr_cot_compra_existente_w		cot_compra.nr_cot_compra%type;
cd_comprador_w			parametro_compras.cd_comprador_padrao%type;
cd_pessoa_solicitante_w		parametro_compras.cd_pessoa_solic_padrao%type;
dt_limite_entrega_w			cot_compra_item.dt_limite_entrega%type;
nr_item_cot_compra_w		cot_compra_item.nr_item_cot_compra%type;
nr_item_cot_compra_ww		cot_compra_item.nr_item_cot_compra%type;
cd_unidade_medida_compra_w	material.cd_unidade_medida_compra%type;
ds_material_w			material.ds_material%type;
nr_seq_contrato_w			contrato.nr_sequencia%type;

c01 CURSOR FOR
SELECT	*
from	xmltable('Respostas/Cabecalho' passing xml_w columns
	cd_pdc			varchar(10)	path	'PDC',
	dt_vencimento		varchar(40)	path	'Data_Vencimento',
	dt_hora_vencimento	varchar(40)	path	'Hora_Vencimento');

c01_w	c01%rowtype;

c04 CURSOR FOR
SELECT	dt_entrega,
	qt_entrega,
	nm_usuario
from	cot_compra_item_entrega
where	nr_cot_compra = nr_cot_compra_p
and	nr_item_cot_compra = nr_item_cot_compra_w;

c04_w	c04%rowtype;

  c02_w RECORD;
  c03_w RECORD;
  c05_w RECORD;

BEGIN

xsl_w := xmlparse(DOCUMENT, convert_from(, 'utf-8'));

select 	xmltransform(xmlparse(DOCUMENT, convert_from(, 'utf-8')), xsl_w)
into STRICT	xml_w
;

nr_cot_compra_w := 0;

for c01_w in c01
loop
begin

	select 	coalesce(max(nr_cot_compra),0)
	into STRICT	nr_cot_compra_existente_w
	from	cot_compra
	where	nr_documento_externo = c01_w.cd_pdc;

	if (nr_cot_compra_existente_w = 0) then

		select 	count(*)
		into STRICT	qt_registro_w
		from	cot_compra
		where	nr_cot_compra = nr_cot_compra_p;

		if (qt_registro_w > 0) then

			select	nextval('cot_compra_seq')
			into STRICT	nr_cot_compra_w
			;

			insert into cot_compra(
				nr_cot_compra,
				dt_cot_compra,
				dt_atualizacao,
				cd_comprador,
				nm_usuario,
				ds_observacao,
				cd_pessoa_solicitante,
				cd_estabelecimento,
				dt_geracao_ordem_compra,
				dt_retorno_prev,
				dt_entrega,
				nr_documento_externo,
				ie_tipo_integracao_envio,
				ie_tipo_integracao_receb,
				nr_seq_motivo_cancel,
				nr_seq_reg_licitacao,
				nr_documento_interno,
				nr_seq_tipo_compra,
				nr_seq_mod_compra,
				dt_fechamento_lic,
				nr_seq_reg_compra,
				nr_classif_interno,
				nr_seq_subgrupo_compra,
				nr_seq_agenda_pac,
				ds_titulo,
				ie_sistema_cotacao,
				dt_calculo_cotacao,
				dt_aprovacao,
				nm_usuario_aprov,
				nr_orcamento,
				ie_finalidade_cotacao,
				ie_status_envio,
				nr_seq_contrato,
				ds_justif_divergencia,
				nr_processo,
				ie_forma_venc_cotacao,
				ie_operacao_envio,
				ie_orcado,
				nr_atendimento,
				nr_seq_autor_cir,
				cd_condicao_pagamento,
				dt_envio_integr_padrao,
				ie_enviado_integracao)
			SELECT	nr_cot_compra_w,
				clock_timestamp(),
				clock_timestamp(),
				cd_comprador,
				nm_usuario,
				'Cotacao gerada a partir da Integracao Bionexo - Reposicao de contratos. Cotacao original: ' || nr_cot_compra_p,
				cd_pessoa_solicitante,
				cd_estabelecimento,
				dt_geracao_ordem_compra,
				dt_retorno_prev,
				dt_entrega,
				c01_w.cd_pdc,
				ie_tipo_integracao_envio,
				ie_tipo_integracao_receb,
				nr_seq_motivo_cancel,
				nr_seq_reg_licitacao,
				nr_documento_interno,
				nr_seq_tipo_compra,
				nr_seq_mod_compra,
				dt_fechamento_lic,
				nr_seq_reg_compra,
				nr_classif_interno,
				nr_seq_subgrupo_compra,
				nr_seq_agenda_pac,
				ds_titulo,
				ie_sistema_cotacao,
				dt_calculo_cotacao,
				dt_aprovacao,
				nm_usuario_aprov,
				nr_orcamento,
				ie_finalidade_cotacao,
				ie_status_envio,
				nr_seq_contrato,
				ds_justif_divergencia,
				nr_processo,
				ie_forma_venc_cotacao,
				ie_operacao_envio,
				ie_orcado,
				nr_atendimento,
				nr_seq_autor_cir,
				cd_condicao_pagamento,
				dt_envio_integr_padrao,
				ie_enviado_integracao
			from	cot_compra
			where	nr_cot_compra = nr_cot_compra_p;

		else

			select 	cd_comprador_padrao,
				cd_pessoa_solic_padrao
			into STRICT	cd_comprador_w,
				cd_pessoa_solicitante_w
			from	parametro_compras
			where	cd_estabelecimento = cd_estabelecimento_p;

			if (coalesce(cd_comprador_w::text, '') = '') then
				nr_cot_compra_w := 0;
				ds_erro_w := 'Comprador padrao nao informado' || chr(10);
			end if;

			if (coalesce(cd_pessoa_solicitante_w::text, '') = '') then
				nr_cot_compra_w := 0;
				ds_erro_w := ds_erro_w || 'Pessoa solicitante padrao nao informada';
			end if;

			if (coalesce(ds_erro_w::text, '') = '') then

				select	nextval('cot_compra_seq')
				into STRICT	nr_cot_compra_w
				;

				dt_vencimento_w := c01_w.dt_vencimento || ' ' || c01_w.dt_hora_vencimento || ':00';

				insert into cot_compra(
					nr_cot_compra,
					dt_cot_compra,
					dt_atualizacao,
					cd_comprador,
					nm_usuario,
					ds_observacao,
					cd_pessoa_solicitante,
					cd_estabelecimento,
					dt_retorno_prev,
					ie_finalidade_cotacao,
					nr_documento_externo)
				values (	nr_cot_compra_w,
					clock_timestamp(),
					clock_timestamp(),
					cd_comprador_w,
					'WebService',
					'Cotacao gerada a partir da Integracao Bionexo - Reposicao de contratos',
					cd_pessoa_solicitante_w,
					cd_estabelecimento_p,
					to_date(dt_vencimento_w, 'dd/mm/yyyy hh24:mi:ss'),
					'C',
					c01_w.cd_pdc);

			end if;

		end if;

	end if;

end;
end loop;

if (nr_cot_compra_w > 0) then

	for c02_w in (	select	*
			from	xmltable('Respostas/Itens/Item' passing xml_w columns
			cd_produto			number(6)	path	'Cod_Produto',
			qt_produto			number(13,4)	path	'Quantidade',
			xml_programacao_entregas_item	xmltype 	path	'Programacao_Entrega',
			xml_campo_extra_item		xmltype 	path	'Campo_Extra') )
	loop
	begin

		select 	coalesce(max(nr_item_cot_compra),0)
		into STRICT	nr_item_cot_compra_w
		from	cot_compra a,
			cot_compra_item b
		where	a.nr_cot_compra = b.nr_cot_compra
		and	a.nr_cot_compra = nr_cot_compra_p
		and	b.cd_material = c02_w.cd_produto;

		if (nr_item_cot_compra_w > 0) then

			select	coalesce(max(nr_item_cot_compra),0) + 1
			into STRICT	nr_item_cot_compra_ww
			from	cot_compra_item
			where	nr_cot_compra = nr_cot_compra_w;

			insert into cot_compra_item(
				nr_cot_compra,
				nr_item_cot_compra,
				cd_material,
				qt_material,
				cd_unidade_medida_compra,
				dt_atualizacao,
				dt_limite_entrega,
				nm_usuario,
				ie_situacao,
				nr_cot_venc_sis,
				nr_item_cot_venc_sis,
				cd_cgc_fornecedor_venc_sis,
				nr_cot_venc_alt,
				nr_item_cot_venc_alt,
				cd_cgc_fornecedor_venc_alt,
				ds_material_direto_w,
				nr_seq_cot_item_forn,
				ie_regra_preco,
				nr_solic_compra,
				nr_item_solic_compra,
				cd_estab_item,
				ds_motivo_venc_alt,
				nr_seq_licitacao,
				nr_seq_lic_item,
				nr_seq_tipo_compra,
				nr_seq_mod_compra,
				nr_seq_reg_compra,
				nr_seq_reg_compra_item,
				nr_seq_proj_rec,
				nr_seq_aprovacao,
				dt_aprovacao,
				dt_reprovacao,
				nm_usuario_aprov,
				nr_item_solic_compra_entr,
				dt_desdobr_aprov,
				nr_seq_central_compra_item,
				ie_motivo_reprovacao,
				ds_justificativa_reprov,
				nr_contrato,
				ie_motivo_alter_venc,
				nr_seq_motivo,
				nr_seq_proc_aprov,
				vl_unit_previsto,
				ie_confirmado_integr)
			SELECT	nr_cot_compra_w,
				nr_item_cot_compra_ww,
				cd_material,
				qt_material,
				cd_unidade_medida_compra,
				dt_atualizacao,
				dt_limite_entrega,
				nm_usuario,
				ie_situacao,
				nr_cot_venc_sis,
				nr_item_cot_venc_sis,
				cd_cgc_fornecedor_venc_sis,
				nr_cot_venc_alt,
				nr_item_cot_venc_alt,
				cd_cgc_fornecedor_venc_alt,
				ds_material_direto_w,
				nr_seq_cot_item_forn,
				ie_regra_preco,
				nr_solic_compra,
				nr_item_solic_compra,
				cd_estab_item,
				ds_motivo_venc_alt,
				nr_seq_licitacao,
				nr_seq_lic_item,
				nr_seq_tipo_compra,
				nr_seq_mod_compra,
				nr_seq_reg_compra,
				nr_seq_reg_compra_item,
				nr_seq_proj_rec,
				nr_seq_aprovacao,
				dt_aprovacao,
				dt_reprovacao,
				nm_usuario_aprov,
				nr_item_solic_compra_entr,
				dt_desdobr_aprov,
				nr_seq_central_compra_item,
				ie_motivo_reprovacao,
				ds_justificativa_reprov,
				nr_contrato,
				ie_motivo_alter_venc,
				nr_seq_motivo,
				nr_seq_proc_aprov,
				vl_unit_previsto,
				ie_confirmado_integr
			from	cot_compra_item
			where	nr_cot_compra = nr_cot_compra_p
			and	nr_item_cot_compra = nr_item_cot_compra_w;

			select	count(*)
			into STRICT	qt_existe_entrega_w
			from	cot_compra_item_entrega
			where	nr_cot_compra = nr_cot_compra_p
			and	nr_item_cot_compra = nr_item_cot_compra_w;

			if (qt_existe_entrega_w > 0) then

				for c04_row in c04
				loop
				begin
					insert into cot_compra_item_entrega(
						nr_sequencia,
						qt_entrega,
						nr_item_cot_compra,
						nr_cot_compra,
						nm_usuario,
						dt_entrega,
						dt_atualizacao)
					values (	nextval('cot_compra_item_entrega_seq'),
						c04_row.qt_entrega,	
						nr_item_cot_compra_ww,
						nr_cot_compra_w,
						c04_row.nm_usuario,
						c04_row.dt_entrega,
						clock_timestamp());
				end;
				end loop;

			else

				for c03_w in (	select	*
						from	xmltable('/Programacao_Entrega' passing c02_w.xml_programacao_entregas_item columns
							dt_entrega			varchar2(40)	path	'Data',
							qt_entrega			number(13,4)	path	'Quantidade') )
				loop
				begin

					insert into cot_compra_item_entrega(
						nr_sequencia,
						qt_entrega,
						nr_item_cot_compra,
						nr_cot_compra,
						nm_usuario,
						dt_entrega,
						dt_atualizacao)
					values (	nextval('cot_compra_item_entrega_seq'),
						c03_w.qt_entrega,	
						nr_item_cot_compra_ww,
						nr_cot_compra_w,
						'WebService',
						c03_w.dt_entrega,
						clock_timestamp());

				end;
				end loop;

			end if;

			delete	from cot_compra_item
			where	nr_cot_compra = nr_cot_compra_p
			and	nr_item_cot_compra = nr_item_cot_compra_w;

		else

			select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMC'),1,30),
				ds_material
			into STRICT	cd_unidade_medida_compra_w,
				ds_material_w
			from	material
			where	cd_material = c02_w.cd_produto;

			if (coalesce(cd_unidade_medida_compra_w::text, '') = '') then
				ds_erro_w := 'A Unidade medida compra do material esta nula - ' || 'Material: ' || c02_w.cd_produto || ' - ' || ds_material_w;
			else

				select	coalesce(max(nr_item_cot_compra),0) + 1
				into STRICT	nr_item_cot_compra_ww
				from	cot_compra_item
				where	nr_cot_compra = nr_cot_compra_w;

				for c03_w in (	SELECT	*
						from	xmltable('/Programacao_Entrega' passing c02_w.xml_programacao_entregas_item columns
							dt_entrega			varchar2(40)	path	'Data',
							qt_entrega			number(13,4)	path	'Quantidade') )
				loop
				begin
					if (c03_w.dt_entrega >= coalesce(dt_limite_entrega_w,c03_w.dt_entrega)) then
						dt_limite_entrega_w := c03_w.dt_entrega;
					end if;
				end;
				end loop;

				insert into cot_compra_item(
					nr_cot_compra,
					nr_item_cot_compra,
					cd_material,
					qt_material,
					cd_unidade_medida_compra,
					dt_atualizacao,
					dt_limite_entrega,
					nm_usuario,
					ie_situacao,
					cd_estab_item)
				values (	nr_cot_compra_w,
					nr_item_cot_compra_ww,
					c02_w.cd_produto,
					c02_w.qt_produto,
					cd_unidade_medida_compra_w,
					clock_timestamp(),
					dt_limite_entrega_w,
					'WebService',
					'A',
					cd_estabelecimento_p);

				for c03_w in (	select	*
						from	xmltable('/Programacao_Entrega' passing c02_w.xml_programacao_entregas_item columns
							dt_entrega			varchar2(40)	path	'Data',
							qt_entrega			number(13,4)	path	'Quantidade') )
				loop
				begin

					insert into cot_compra_item_entrega(
						nr_sequencia,
						qt_entrega,
						nr_item_cot_compra,
						nr_cot_compra,
						nm_usuario,
						dt_entrega,
						dt_atualizacao)
					values (	nextval('cot_compra_item_entrega_seq'),
						c03_w.qt_entrega,	
						nr_item_cot_compra_ww,
						nr_cot_compra_w,
						'WebService',
						c03_w.dt_entrega,
						clock_timestamp());

				end;
				end loop;

			end if;

		end if;

		for c05_w in (	select	*
				from	xmltable('/Campo_Extra' passing c02_w.xml_campo_extra_item columns
					ds_nome				varchar2(255)	path	'Nome',
					nr_contrato			varchar2(4000)	path	'Valor') )
		loop
		begin
			if (UPPER(c05_w.ds_nome) = 'ID_CONTRATO') then

				select	coalesce(max(nr_sequencia),0)
				into STRICT	nr_seq_contrato_w
				from	contrato
				where	nr_documento_externo = c05_w.nr_contrato;

				if (nr_seq_contrato_w > 0) then
					update 	cot_compra_item
					set	nr_contrato = nr_seq_contrato_w
					where	nr_cot_compra = nr_cot_compra_w
					and	nr_item_cot_compra = nr_item_cot_compra_ww;
				end if;

			end if;
		end;
		end loop;

	end;
	end loop;

end if;

if (nr_cot_compra_existente_w > 0) then
	nr_cot_compra_nova_p := nr_cot_compra_existente_w;
else
	nr_cot_compra_nova_p := nr_cot_compra_w;
end if;

ds_erro_p := ds_erro_w;

if (coalesce(ds_erro_p::text, '') = '') then
	commit;
else
	rollback;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bionexo_desdobrar_cot_compra ( nr_cot_compra_p bigint, cd_estabelecimento_p bigint, xml_p text, nr_cot_compra_nova_p INOUT bigint, ds_erro_p INOUT text ) FROM PUBLIC;

