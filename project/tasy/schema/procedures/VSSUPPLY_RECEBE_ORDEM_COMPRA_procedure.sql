-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vssupply_recebe_ordem_compra (nr_sequencia_p bigint) AS $body$
DECLARE


													
_ora2pg_r RECORD;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_sistema_w		intpd_eventos_sistema.nr_seq_sistema%type;
ie_sistema_externo_w		varchar(15);
qt_registros_w			bigint;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nr_seq_regra_conv_w		conversao_meio_externo.nr_seq_regra%type;
pr_tributo_w			ordem_compra_item_trib.pr_tributo%type;
cd_tributo_w			ordem_compra_item_trib.cd_tributo%type;
vl_item_liquido_w		ordem_compra_item.vl_item_liquido%type;
ordem_compra_w			ordem_compra%rowtype;
ordem_compra_item_w		ordem_compra_item%rowtype;
i				integer;
ds_xml_w			text;
ds_xml_type_w			xml;

c01 CURSOR FOR
SELECT	*
from	xmltable('//*:cabecalho' passing ds_xml_type_w columns
	idIntegracaoExt			varchar(40)	path	'idIntegracaoExt',
	codigoEntidade			varchar(40)	path	'codigoEntidade',
	tipoInformacao			varchar(40)	path	'tipoInformacao');
c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	*
from	xmltable('//*:conteudo/ordemCompraRequisicao' passing ds_xml_type_w columns
	nr_documento_externo			varchar(40)	path	'numeroPedido',
	nr_solic_compra			varchar(40)	path	'numeroSC',
	cd_local_entrega		varchar(40)	path	'codigoEstoqueIntegra',
	cd_fornecedor			varchar(40)	path	'codigoFornecedor',
	ds_razao_social			varchar(255)	path	'razaoFornecedor',
	cd_cgc_fornecedor		varchar(40)	path	'cnpjCpfFornecedor',
	cd_condicao_pagamento		varchar(40)	path	'codigoFormaPagamento',
	ds_condicao_pagamento		varchar(40)	path	'descricaoFormaPagamento',
	ie_frete			varchar(40)	path	'tipoFrete',
	vl_total_ordem			double precision	path	'valorTotal',
	dt_aprovacao			varchar(40)	path	'dataAprovacao',
	nm_usuario_aprov		varchar(40)	path	'usuarioAprovador',
	dt_entrega			varchar(40)	path	'dataEntrega',
	xml_ordem_itens			xml 	path	'itens',
	vl_ipi_total			double precision	path	'IPITotal');

c02_w	c02%rowtype;


c03 CURSOR FOR
SELECT	*
from	xmltable('//*:itens' passing c02_w.xml_ordem_itens columns
	cd_material				varchar(40)	path	'codigoProduto',
	ds_material				varchar(255)	path	'descricaoProduto',
	qt_material				double precision	path	'quantidade',
	cd_unidade_medida_compra		varchar(40)	path	'codigoUnidade',
	ds_unidade_medida			varchar(255)	path	'descricaoUnidade',
	qt_fator				bigint	path	'fator',
	VL_UNITARIO_MATERIAL			double precision	path	'precoUnitario',
	VL_IPI_ITEM				double precision	path	'valorIpiProduto',
	DS_MARCA				varchar(30)	path	'descMarcaFabricante');

c03_w	c03%rowtype;


BEGIN

select	coalesce(b.ie_conversao,'I'),
	nr_seq_sistema,
	nr_seq_projeto_xml,
	nr_seq_regra_conv
into STRICT	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_conv_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;

ie_sistema_externo_w	:=	nr_seq_sistema_w;

reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe		:=	'R';
reg_integracao_w.ie_sistema_externo		:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao			:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml		:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao		:=	nr_seq_regra_conv_w;

select	ds_xml
into STRICT	ds_xml_w
from	intpd_fila_transmissao
where	nr_sequencia = nr_sequencia_p;

ds_xml_type_w	:= xmlparse(DOCUMENT, convert_from(, 'utf-8'));


open C02;
loop
fetch C02 into
	c02_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	reg_integracao_w.nm_tabela		:=	'ORDEM_COMPRA';
	reg_integracao_w.nm_elemento		:=	'ordemCompraRequisicao';
	reg_integracao_w.nr_seq_visao		:=	17575;
  c02_w.nr_solic_compra         := (c02_w.nr_solic_compra)::numeric;

	begin
	select	coalesce(cd_estabelecimento,0),
		cd_centro_custo,
		cd_local_estoque,
		cd_conta_contabil
	into STRICT	ordem_compra_w.cd_estabelecimento,
		ordem_compra_item_w.cd_centro_custo,
		ordem_compra_item_w.cd_local_estoque,
		ordem_compra_item_w.cd_conta_contabil
	from	solic_compra
	where	nr_solic_compra = c02_w.nr_solic_compra;
	exception
	when others then
		ordem_compra_w.cd_estabelecimento := 0;
	end;

	if (ordem_compra_w.cd_estabelecimento > 0) then

		select	cd_comprador_padrao,
			cd_moeda_padrao,
			cd_responsavel_compras
		into STRICT	ordem_compra_w.cd_comprador,
			ordem_compra_w.cd_moeda,
			ordem_compra_w.cd_pessoa_solicitante
		from	parametro_compras
		where	cd_estabelecimento = ordem_compra_w.cd_estabelecimento;

		ordem_compra_w.nm_usuario := 'INTPDTASY';
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_DOCUMENTO_EXTERNO', c02_w.nr_documento_externo, 'N', ordem_compra_w.nr_documento_externo) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nr_documento_externo := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_LOCAL_ENTREGA', c02_w.cd_local_entrega, 'S', ordem_compra_w.cd_local_entrega) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.cd_local_entrega := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_CGC_FORNECEDOR', c02_w.cd_cgc_fornecedor, 'S', ordem_compra_w.cd_cgc_fornecedor) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.cd_cgc_fornecedor := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_CONDICAO_PAGAMENTO', c02_w.cd_condicao_pagamento, 'S', ordem_compra_w.cd_condicao_pagamento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.cd_condicao_pagamento := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_FRETE', c02_w.ie_frete, 'S', ordem_compra_w.ie_frete) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ie_frete := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_ENTREGA', substr(c02_w.dt_entrega,1,10), 'N', ordem_compra_w.dt_entrega) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.dt_entrega := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_FRETE', 0, 'N', ordem_compra_w.vl_frete) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.vl_frete := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_DESCONTO', 0, 'N', ordem_compra_w.vl_desconto) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.vl_desconto := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_DESPESA_DOC', 0, 'N', ordem_compra_w.vl_despesa_doc) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.vl_despesa_doc := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_SEGURO', 0, 'N', ordem_compra_w.vl_seguro) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.vl_seguro := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_DESPESA_ACESSORIA', 0, 'N', ordem_compra_w.vl_despesa_acessoria) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.vl_despesa_acessoria := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_CONV_MOEDA', 0, 'N', ordem_compra_w.vl_conv_moeda) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.vl_conv_moeda := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'PR_MULTA_ATRASO', 0, 'N', ordem_compra_w.pr_multa_atraso) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.pr_multa_atraso := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'PR_DESCONTO', 0, 'N', ordem_compra_w.pr_desconto) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.pr_desconto := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'PR_DESC_PGTO_ANTEC', 0, 'N', ordem_compra_w.pr_desc_pgto_antec) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.pr_desc_pgto_antec := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'PR_DESC_FINANCEIRO', 0, 'N', ordem_compra_w.pr_desc_financeiro) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.pr_desc_financeiro := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'PR_JUROS_NEGOCIADO', 0, 'N', ordem_compra_w.pr_juros_negociado) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.pr_juros_negociado := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_PESSOA_CONTATO', null, 'N', ordem_compra_w.ds_pessoa_contato) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ds_pessoa_contato := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_OBSERVACAO', null, 'N', ordem_compra_w.ds_observacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ds_observacao := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_OBS_INTERNA', null, 'N', ordem_compra_w.ds_obs_interna) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ds_obs_interna := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', ordem_compra_w.nm_usuario, 'N', ordem_compra_w.nm_usuario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nm_usuario := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_TIPO_ORDEM', 'I', 'N', ordem_compra_w.ie_tipo_ordem) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ie_tipo_ordem := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_AVISO_CHEGADA', 'N', 'N', ordem_compra_w.ie_aviso_chegada) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ie_aviso_chegada := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_EMITE_OBS', 'N', 'N', ordem_compra_w.ie_emite_obs) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ie_emite_obs := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_URGENTE', 'N', 'N', ordem_compra_w.ie_urgente) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ie_urgente := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_SOMENTE_PAGTO', 'N', 'N', ordem_compra_w.ie_somente_pagto) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ie_somente_pagto := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_SETOR_ENTREGA', null, 'S', ordem_compra_w.cd_setor_entrega) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.cd_setor_entrega := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_CONVENIO', null, 'S', ordem_compra_w.cd_convenio) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.cd_convenio := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_SUBGRUPO_COMPRA', null, 'S', ordem_compra_w.nr_seq_subgrupo_compra) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nr_seq_subgrupo_compra := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_FORMA_PAGTO', null, 'S', ordem_compra_w.nr_seq_forma_pagto) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nr_seq_forma_pagto := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_TIPO_COMPRA', null, 'S', ordem_compra_w.nr_seq_tipo_compra) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nr_seq_tipo_compra := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_MOD_COMPRA', null, 'S', ordem_compra_w.nr_seq_mod_compra) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nr_seq_mod_compra := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_MOTIVO_URGENTE', null, 'S', ordem_compra_w.nr_seq_motivo_urgente) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nr_seq_motivo_urgente := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_MOTIVO_SOLIC', null, 'S', ordem_compra_w.nr_seq_motivo_solic) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.nr_seq_motivo_solic := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_ESTAB_TRANSF', null, 'S', ordem_compra_w.cd_estab_transf) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.cd_estab_transf := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_LOCAL_TRANSF', null, 'S', ordem_compra_w.cd_local_transf) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.cd_local_transf := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_SISTEMA_ORIGEM', 'VSSUPPLY', 'N', ordem_compra_w.ie_sistema_origem) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_w.ie_sistema_origem := _ora2pg_r.ds_valor_retorno_p;
		ordem_compra_w.dt_atualizacao		:= clock_timestamp();
		ordem_compra_w.nm_usuario_nrec		:= ordem_compra_w.nm_usuario;
		ordem_compra_w.dt_atualizacao_nrec	:= clock_timestamp();
		ordem_compra_w.dt_inclusao		:= clock_timestamp();
		ordem_compra_w.ie_situacao		:= 'A';
		ordem_compra_w.dt_ordem_compra		:= clock_timestamp();

		if (c02_w.dt_aprovacao IS NOT NULL AND c02_w.dt_aprovacao::text <> '') then
			ordem_compra_w.dt_aprovacao 	:= clock_timestamp(); /*Tem que ser sysdate para que a data da aprovaçao não seja ANTES da data da criação da ordem*/
			ordem_compra_w.dt_liberacao 	:= clock_timestamp();
			ordem_compra_w.nm_usuario_lib 	:= 'INTPDTASY';
		end if;

		if (reg_integracao_w.qt_reg_log = 0) then

			select	coalesce(max(nr_ordem_compra),0)
			into STRICT	ordem_compra_w.nr_ordem_compra
			from	ordem_compra
			where	nr_documento_externo = ordem_compra_w.nr_documento_externo
			and	ie_sistema_origem = ordem_compra_w.ie_sistema_origem;

			if (ordem_compra_w.nr_ordem_compra > 0) then
				begin
					select	coalesce(max(nr_ordem_compra),0)
					into STRICT	ordem_compra_w.nr_ordem_compra
					from	ordem_compra
					where	nr_documento_externo = ordem_compra_w.nr_documento_externo
					and	ie_sistema_origem = ordem_compra_w.ie_sistema_origem
					and	coalesce(dt_liberacao::text, '') = '';
				
					if (ordem_compra_w.nr_ordem_compra > 0)then
						begin
							delete FROM ordem_compra_venc where nr_ordem_compra = ordem_compra_w.nr_ordem_compra;

							update	ordem_compra
							set	row = ordem_compra_w
							where	nr_ordem_compra = ordem_compra_w.nr_ordem_compra;
						end;
					else					
						begin
							update	intpd_fila_transmissao
							set	ie_status = 'S',
								nr_seq_documento = ordem_compra_w.nr_ordem_compra,
								nr_doc_externo = ordem_compra_w.nr_documento_externo
							where	nr_sequencia = nr_sequencia_p;
							
							commit;
							
							return;					
						end;
					end if;
				end;
			else		
				begin
					select	nextval('ordem_compra_seq')
					into STRICT	ordem_compra_w.nr_ordem_compra
					;

					insert into ordem_compra values (ordem_compra_w.*);	
				end;
			end if;
		end if;

		open C03;
		loop
		fetch C03 into
			c03_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin

			reg_integracao_w.nm_tabela		:=	'ORDEM_COMPRA_ITEM';
			reg_integracao_w.nm_elemento		:=	'Itens';
			reg_integracao_w.nr_seq_visao		:=	16711;

			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_MATERIAL', c03_w.cd_material, 'S', ordem_compra_item_w.cd_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.cd_material := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_UNIDADE_MEDIDA_COMPRA', c03_w.cd_unidade_medida_compra, 'S', ordem_compra_item_w.cd_unidade_medida_compra) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.cd_unidade_medida_compra := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_UNITARIO_MATERIAL', c03_w.vl_unitario_material, 'N', ordem_compra_item_w.vl_unitario_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.vl_unitario_material := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'QT_MATERIAL', c03_w.qt_material, 'N', ordem_compra_item_w.qt_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.qt_material := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'PR_DESCONTOS', 0, 'N', ordem_compra_item_w.pr_descontos) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.pr_descontos := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_DESCONTO', 0, 'N', ordem_compra_item_w.vl_desconto) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.vl_desconto := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_MATERIAL_DIRETO', null, 'N', ordem_compra_item_w.ds_material_direto) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.ds_material_direto := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_OBSERVACAO', null, 'N', ordem_compra_item_w.ds_observacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.ds_observacao := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_OBS_ITEM_FORN', null, 'N', ordem_compra_item_w.ds_obs_item_forn) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.ds_obs_item_forn := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_MARCA', c03_w.ds_marca, 'N', ordem_compra_item_w.ds_marca) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.ds_marca := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_MARCA', null, 'S', ordem_compra_item_w.nr_seq_marca) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.nr_seq_marca := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'PR_DESC_FINANC', 0, 'N', ordem_compra_item_w.pr_desc_financ) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.pr_desc_financ := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_CONTA_FINANC', null, 'S', ordem_compra_item_w.nr_seq_conta_financ) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.nr_seq_conta_financ := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_CRITERIO_RATEIO', null, 'S', ordem_compra_item_w.nr_seq_criterio_rateio) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.nr_seq_criterio_rateio := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SERIE_MATERIAL', null, 'N', ordem_compra_item_w.nr_serie_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.nr_serie_material := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_CONTA_BCO', null, 'S', ordem_compra_item_w.nr_seq_conta_bco) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.nr_seq_conta_bco := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_INICIO_GARANTIA', null, 'N', ordem_compra_item_w.dt_inicio_garantia) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.dt_inicio_garantia := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_FIM_GARANTIA', null, 'N', ordem_compra_item_w.dt_fim_garantia) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.dt_fim_garantia := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'QT_DIAS_GARANTIA', null, 'N', ordem_compra_item_w.qt_dias_garantia) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.qt_dias_garantia := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_LOTE', null, 'N', ordem_compra_item_w.ds_lote) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.ds_lote := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_VALIDADE', null, 'N', ordem_compra_item_w.dt_validade) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.dt_validade := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SOLIC_COMPRA', c02_w.nr_solic_compra, 'N', ordem_compra_item_w.nr_solic_compra) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ordem_compra_item_w.nr_solic_compra := _ora2pg_r.ds_valor_retorno_p;
			ordem_compra_item_w.dt_atualizacao		:= clock_timestamp();
			ordem_compra_item_w.nm_usuario			:= ordem_compra_w.nm_usuario;
			ordem_compra_item_w.ie_situacao			:= 'A';
			ordem_compra_item_w.nr_ordem_compra		:= ordem_compra_w.nr_ordem_compra;
			ordem_compra_item_w.cd_pessoa_solicitante	:= ordem_compra_w.cd_pessoa_solicitante;
			ordem_compra_item_w.qt_original			:= ordem_compra_item_w.qt_material;
			ordem_compra_item_w.nr_solic_compra		:= c02_w.nr_solic_compra;
			ordem_compra_item_w.vl_total_item		:= ordem_compra_item_w.qt_material * ordem_compra_item_w.vl_unitario_material;
			
			if (coalesce(ordem_compra_item_w.vl_desconto,0) > 0) then
				ordem_compra_item_w.vl_item_liquido		:= 	round((ordem_compra_item_w.vl_unitario_material * ordem_compra_item_w.qt_material) - coalesce(ordem_compra_item_w.vl_desconto,0),2);
			else
				ordem_compra_item_w.vl_item_liquido		:= 	round((ordem_compra_item_w.vl_unitario_material * ordem_compra_item_w.qt_material) - (((ordem_compra_item_w.vl_unitario_material * ordem_compra_item_w.qt_material) * ordem_compra_item_w.pr_descontos) / 100),2);
			end if;
			
			vl_item_liquido_w				:= ordem_compra_item_w.vl_item_liquido;

			select	max(nr_item_solic_compra)
			into STRICT	ordem_compra_item_w.nr_item_solic_compra
			from	solic_compra_item
			where	nr_solic_compra = ordem_compra_item_w.nr_solic_compra
			and	cd_material = ordem_compra_item_w.cd_material;

			if (reg_integracao_w.qt_reg_log = 0) then

				select	coalesce(max(nr_item_oci),0)
				into STRICT	ordem_compra_item_w.nr_item_oci
				from	ordem_compra_item
				where	nr_ordem_compra = ordem_compra_w.nr_ordem_compra
				and	cd_material = ordem_compra_item_w.cd_material;

				if (ordem_compra_item_w.nr_item_oci > 0) then

					update	ordem_compra_item
					set	row = ordem_compra_item_w
					where	nr_ordem_compra = ordem_compra_w.nr_ordem_compra
					and	nr_item_oci = ordem_compra_item_w.nr_item_oci;

				else
					select	coalesce(max(nr_item_oci),0) +1
					into STRICT	ordem_compra_item_w.nr_item_oci
					from	ordem_compra_item
					where	nr_ordem_compra = ordem_compra_w.nr_ordem_compra;

					insert into ordem_compra_item values (ordem_compra_item_w.*);
				end if;

				if (c03_w.vl_ipi_item > 0) then

					select	coalesce(max(cd_tributo),0)
					into STRICT	cd_tributo_w
					from	tributo
					where	ie_tipo_tributo = 'IPI'
					and	ie_situacao = 'A'
					and	ie_corpo_item = 'I';

					if (cd_tributo_w > 0) then

						delete from ordem_compra_item_trib
						where	nr_ordem_compra = ordem_compra_w.nr_ordem_compra
						and	nr_item_oci = ordem_compra_item_w.nr_item_oci;

						pr_tributo_w	:= (dividir((c03_w.vl_ipi_item * 100),vl_item_liquido_w));


						insert into ordem_compra_item_trib(
							nr_ordem_compra,
							nr_item_oci,
							cd_tributo,
							pr_tributo,
							vl_tributo,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							ie_corpo_item)
						values (	ordem_compra_w.nr_ordem_compra,
							ordem_compra_item_w.nr_item_oci,
							cd_tributo_w,
							pr_tributo_w,
							c03_w.vl_ipi_item,
							clock_timestamp(),
							ordem_compra_w.nm_usuario,
							clock_timestamp(),
							ordem_compra_w.nm_usuario,
							'I');

					end if;
				end if;
			end if;
			end;
		end loop;
		close C03;
	end if;
	end;
end loop;
close C02;

if (reg_integracao_w.qt_reg_log > 0) then
	begin
	rollback;

	update intpd_fila_transmissao
	set	ie_status = 'E',
		ie_tipo_erro = 'F'
	where	nr_sequencia = nr_sequencia_p;

	for i in 0..reg_integracao_w.qt_reg_log-1 loop

		INTPD_GRAVAR_LOG_RECEBIMENTO(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY');
	end loop;
	end;

else

	select	count(*)
	into STRICT	qt_registros_w
	from	ordem_compra_item
	where	nr_ordem_compra = ordem_compra_w.nr_ordem_compra;

	if (qt_registros_w > 0) then
		CALL gerar_acoes_ordem_compra_imp(ordem_compra_w.nr_ordem_compra,ordem_compra_w.nm_usuario);
	end if;
	
	update	intpd_fila_transmissao
	set	ie_status = 'S',
		nr_seq_documento = ordem_compra_w.nr_ordem_compra,
		nr_doc_externo = c02_w.nr_documento_externo
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vssupply_recebe_ordem_compra (nr_sequencia_p bigint) FROM PUBLIC;

