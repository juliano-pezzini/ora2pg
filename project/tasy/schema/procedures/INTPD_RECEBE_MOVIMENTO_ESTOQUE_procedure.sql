-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_recebe_movimento_estoque ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
movimento_estoque_w		movimento_estoque%rowtype;
movimento_estoque_valor_w		movimento_estoque_valor%rowtype;

ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
ie_sistema_externo_w		varchar(15);
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
nr_seq_regra_w			conversao_meio_externo.nr_seq_regra%type;
ds_erro_w			varchar(4000);
i				integer;
ie_exception_w			varchar(1) := 'N';
ie_erro_w				varchar(1) := 'N';

qt_barra_material_w			bigint := 0;
nr_seq_mat_estab_w			material_estab.nr_sequencia%type := 0;
ie_tipo_requisicao_w 		operacao_estoque.ie_tipo_requisicao%type;
ie_entrada_saida_w 		operacao_estoque.ie_entrada_saida%type;
qt_saldo_estoque_w 		saldo_estoque.qt_estoque%type;
ie_evento_w			intpd_fila_transmissao.ie_evento%type;
ie_consignado_w			material.ie_consignado%type;
qt_registros_w			bigint;

/*'Efetua a consulta transformando o elemento XML num tipo de tabela'*/

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/STOCK_MOVEMENT' passing xml_p columns
	cd_acao				varchar(40)	path	'CD_ACTION',
	cd_centro_custo			varchar(40)	path	'CD_COST_CENTER',
	cd_barra_material			varchar(255)	path	'CD_BARCODE',
	ds_barras				varchar(4000)	path	'DS_BARCODE_DESCRIPTION',
	cd_conta_contabil			varchar(40)	path	'CD_BOOKKEEPING_ACCOUNT',
	cd_estabelecimento			varchar(40)	path	'CD_ESTABLISHMENT',
	cd_fornecedor			varchar(40)	path	'CD_SUPPLIER',
	cd_local_estoque			varchar(40)	path	'CD_STOCK_LOCATION',
	cd_lote_fabricacao			varchar(20)	path	'CD_MANUFACTURING_BATCH',
	cd_material			varchar(40)	path	'CD_MATERIAL',
	cd_sistema_ant			varchar(20)	path	'CD_EXTERNAL_MATERIAL',
	cd_operacao_estoque		varchar(40)	path	'CD_STOCK_OPERATION',
	cd_setor_atendimento		varchar(40)	path	'CD_ENCOUNTER_DEPARTMENT',
	cd_unidade_med_mov		varchar(40)	path	'CD_MOV_UNIT_MEASUREMENT',
	ds_maquina			varchar(80)	path	'DS_MACHINE',
	ds_observacao			varchar(255)	path	'DS_NOTE',
	dt_movimento_estoque		varchar(40)	path	'DT_STOCK_MOVEMENT',
	dt_validade			varchar(40)	path	'DT_VALIDITY',
	nm_usuario			varchar(40)	path	'NM_USER',
	nr_atendimento			bigint	path	'NR_ENCOUNTER',
	nr_documento			bigint	path	'NR_DOCUMENT',
	nr_doc_externo			varchar(80)	path	'NR_EXTERNAL_MOVEMENT',
	nr_prescricao			bigint	path	'NR_PRESCRIPTION',
	nr_seq_lote_fornec			varchar(40)	path	'NR_SEQ_SUPPLIER_BACTH',
	nr_sequencia_item_docto		integer	path	'NR_DOCTO_ITEM_SEQ',
	qt_inventario			varchar(40)	path	'QT_INVENTORY',
	qt_movimento			varchar(40)	path	'QT_MOVEMENT',
	/*'Transforma um subnivel da estrutura XML num xmltype, que sera utilizado posteriormente na consulta, transformando-o num tipo de tabela'*/

	xml_movimento_valor		xml		path	'STOCK_MOVEMENT_VALUES');

c01_w	c01%rowtype;

/*'Efetua a consulta transformando o elemento XML num tipo de tabela'*/

c02 CURSOR FOR
SELECT	*
from	xmltable('/STOCK_MOVEMENT_VALUES/STOCK_MOVEMENT_VALUE' passing c01_w.xml_movimento_valor columns
	cd_tipo_valor			varchar(15)	path	'CD_VALUE_TYPE',
	vl_movimento			varchar(40)	path	'VL_MOVEMENT');

c02_w	c02%rowtype;


BEGIN

/*'Atualiza o status da fila para Em processamento'*/

update	intpd_fila_transmissao
set	ie_status = 'R'
where	nr_sequencia = nr_sequencia_p;

/*'Realiza o commit para nao permite o status de processamento em casa de rollback por existir consistencia. Existe tratamento de excecao abaixo para colocar o status de erro em caso de falha'*/

commit;

/*'Inicio de controle de falha'*/

begin
/*'Busca os dados da regra do registro da fila que esta em processamento'*/

select	coalesce(b.ie_conversao,'I'),
	nr_seq_sistema,
	nr_seq_projeto_xml,
	nr_seq_regra_conv,
	ie_evento
into STRICT	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_w,
	ie_evento_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;

ie_sistema_externo_w	:=	nr_seq_sistema_w;

/*'Alimenta as informacoes iniciais de controle e consistencia de cada atributo do XML'*/

reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe		:=	'R';
reg_integracao_w.ie_sistema_externo		:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao		:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml		:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao	:=	nr_seq_regra_w;
reg_integracao_w.intpd_log_receb.delete;
reg_integracao_w.qt_reg_log			:=	0;

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_erro_w	:= 'N';

	/*'Alimenta as informacoes de controle e consistencia referente ao Elemento a ser processado no momento. E importante manter dentro do cursor e nao fora.'*/

	reg_integracao_w.nm_tabela			:=	'MOVIMENTO_ESTOQUE';
	reg_integracao_w.nm_elemento		:=	'STOCK_MOVEMENT';
	reg_integracao_w.nr_seq_visao		:=	27753;

	/*'Consiste cada atributo do XML'*/

	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_ACAO', c01_w.cd_acao, 'S', movimento_estoque_w.cd_acao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_acao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_CENTRO_CUSTO', c01_w.cd_centro_custo, 'S', movimento_estoque_w.cd_centro_custo) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_centro_custo := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_CONTA_CONTABIL', c01_w.cd_conta_contabil, 'S', movimento_estoque_w.cd_conta_contabil) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_conta_contabil := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_ESTABELECIMENTO', c01_w.cd_estabelecimento, 'S', movimento_estoque_w.cd_estabelecimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_estabelecimento := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_FORNECEDOR', c01_w.cd_fornecedor, 'S', movimento_estoque_w.cd_fornecedor) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_fornecedor := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_LOCAL_ESTOQUE', c01_w.cd_local_estoque, 'S', movimento_estoque_w.cd_local_estoque) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_local_estoque := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_LOTE_FABRICACAO', c01_w.cd_lote_fabricacao, 'N', movimento_estoque_w.cd_lote_fabricacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_lote_fabricacao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_MATERIAL', c01_w.cd_material, 'S', movimento_estoque_w.cd_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_material := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_OPERACAO_ESTOQUE', c01_w.cd_operacao_estoque, 'S', movimento_estoque_w.cd_operacao_estoque) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_operacao_estoque := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_SETOR_ATENDIMENTO', c01_w.cd_setor_atendimento, 'S', movimento_estoque_w.cd_setor_atendimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_setor_atendimento := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_UNIDADE_MED_MOV', c01_w.cd_unidade_med_mov, 'S', movimento_estoque_w.cd_unidade_med_mov) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.cd_unidade_med_mov := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_MAQUINA', c01_w.ds_maquina, 'N', movimento_estoque_w.ds_maquina) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.ds_maquina := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_OBSERVACAO', c01_w.ds_observacao, 'N', movimento_estoque_w.ds_observacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.ds_observacao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_MOVIMENTO_ESTOQUE', c01_w.dt_movimento_estoque, 'N', movimento_estoque_w.dt_movimento_estoque) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.dt_movimento_estoque := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_VALIDADE', c01_w.dt_validade, 'N', movimento_estoque_w.dt_validade) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.dt_validade := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', substr(c01_w.nm_usuario,1,15), 'N', movimento_estoque_w.nm_usuario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.nm_usuario := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_ATENDIMENTO', c01_w.nr_atendimento, 'N', movimento_estoque_w.nr_atendimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.nr_atendimento := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_DOCUMENTO', c01_w.nr_documento, 'N', movimento_estoque_w.nr_documento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.nr_documento := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_DOC_EXTERNO', c01_w.nr_doc_externo, 'N', movimento_estoque_w.nr_doc_externo) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.nr_doc_externo := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_PRESCRICAO', c01_w.nr_prescricao, 'N', movimento_estoque_w.nr_prescricao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.nr_prescricao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_LOTE_FORNEC', c01_w.nr_seq_lote_fornec, 'S', movimento_estoque_w.nr_seq_lote_fornec) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.nr_seq_lote_fornec := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQUENCIA_ITEM_DOCTO', c01_w.nr_sequencia_item_docto, 'N', movimento_estoque_w.nr_sequencia_item_docto) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.nr_sequencia_item_docto := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'QT_MOVIMENTO', c01_w.qt_movimento, 'N', movimento_estoque_w.qt_movimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.qt_movimento := _ora2pg_r.ds_valor_retorno_p;
	movimento_estoque_w.ie_origem_documento	:=	'11' /*'Integracao'*/;
	movimento_estoque_w.dt_atualizacao		:=	clock_timestamp();

	/*'Efetua a atualizacao caso nao possua consistencia '*/

	if (reg_integracao_w.qt_reg_log = 0) then
		begin

		if (c01_w.cd_sistema_ant IS NOT NULL AND c01_w.cd_sistema_ant::text <> '') then

			select	coalesce(max(cd_material),0)
			into STRICT	movimento_estoque_w.cd_material
			from 	material
			where 	cd_sistema_ant = c01_w.cd_sistema_ant
			and	ie_situacao = 'A';

			if (movimento_estoque_w.cd_material = 0) then
				/*Codigo do material invalido ou inexistente no Tasy*/

				intpd_gravar_log_recebimento(nr_sequencia_p,wheb_mensagem_pck.get_texto(1015358),'INTPDTASY','0004');
				ie_erro_w := 'S';
			end if;
		end if;
		
		/* Verifica se movimento externo ja foi processado apenas se informacao passada for diferente da string '0' */

		if ((movimento_estoque_w.nr_doc_externo IS NOT NULL AND movimento_estoque_w.nr_doc_externo::text <> '')
			and movimento_estoque_w.nr_doc_externo <> '0') then
			begin
			select	count(*)
			into STRICT	qt_registros_w
			from	movimento_estoque
			where	nr_doc_externo = movimento_estoque_w.nr_doc_externo
			and	cd_estabelecimento = movimento_estoque_w.cd_estabelecimento;
			
			if (qt_registros_w > 0) then
				begin
				/*Ja foi processado um movimento de estoque com o numero de documento externo #@NR_DOC_EXTERNO_W#@. Nao e permitido processar movimentos em duplicidade.*/

				intpd_gravar_log_recebimento(nr_sequencia_p, wheb_mensagem_pck.get_Texto(1076138, 'NR_DOC_EXTERNO_W='|| movimento_estoque_w.nr_doc_externo),'INTPDTASY','0004');
				ie_erro_w := 'S';
				end;
			end if;			
			end;
		end if;

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_mat_estab_w
		from 	material_estab
		where 	cd_material = movimento_estoque_w.cd_material
		and	cd_estabelecimento = movimento_estoque_w.cd_estabelecimento;
		
		select	coalesce(max(ie_consignado),'0')
		into STRICT	ie_consignado_w
		from	material
		where	cd_material = movimento_estoque_w.cd_material;
		

		if (nr_seq_mat_estab_w = 0) then
			/*O material informado nao possui dados no cadastro para o estabelecimento atual.*/

			intpd_gravar_log_recebimento(nr_sequencia_p,wheb_mensagem_pck.get_texto(1061634),'INTPDTASY','0017');
			ie_erro_w := 'S';
		end if;

		if (ie_erro_w = 'N') then

			if (movimento_estoque_w.cd_operacao_estoque IS NOT NULL AND movimento_estoque_w.cd_operacao_estoque::text <> '') then

				begin
				select 	ie_tipo_requisicao,
					ie_entrada_saida
				into STRICT	ie_tipo_requisicao_w,
					ie_entrada_saida_w
				from	operacao_estoque
				where 	cd_operacao_estoque = movimento_estoque_w.cd_operacao_estoque;

				if (coalesce(ie_tipo_requisicao_w,'0') = '5') then /*5 = Inventario, dominio 21 */
					begin

					/* movimento_estoque_w.qt_inventario = La cantidad correcta que deve tener en stock. */

					SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'QT_INVENTARIO', c01_w.qt_inventario, 'N', movimento_estoque_w.qt_inventario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_w.qt_inventario := _ora2pg_r.ds_valor_retorno_p;
					
					if	((ie_consignado_w = '0') or /*Nao consignado - Busca o saldo normal*/
						((ie_consignado_w = '2') and (coalesce(movimento_estoque_w.cd_fornecedor::text, '') = ''))) then /*Ambos  (Sem fornecedor) - Busca saldo normal*/
						select 	coalesce(sum(qt_estoque),0)
						into STRICT	qt_saldo_estoque_w
						from 	saldo_estoque
						where	cd_estabelecimento 	= movimento_estoque_w.cd_estabelecimento
						and	cd_local_estoque 	= movimento_estoque_w.cd_local_estoque
						and	dt_mesano_referencia 	= pkg_date_utils.start_of(movimento_estoque_w.dt_movimento_estoque, 'MM', null)
						and	cd_material 		= movimento_estoque_w.cd_material;

						movimento_estoque_w.ie_movto_consignado := 'N';					
					
					elsif	((ie_consignado_w = '1') or /*Consignado - Busca o saldo consignado*/
						(ie_consignado_w = '2' AND movimento_estoque_w.cd_fornecedor IS NOT NULL AND movimento_estoque_w.cd_fornecedor::text <> '')) then /*Ambos  (Com fornecedor) - Busca saldo consignado*/
				
						select 	coalesce(sum(qt_estoque),0)
						into STRICT	qt_saldo_estoque_w
						from 	fornecedor_mat_consignado
						where	cd_estabelecimento 	= movimento_estoque_w.cd_estabelecimento
						and	cd_fornecedor		= movimento_estoque_w.cd_fornecedor
						and	cd_local_estoque 	= movimento_estoque_w.cd_local_estoque
						and	dt_mesano_referencia 	= pkg_date_utils.start_of(movimento_estoque_w.dt_movimento_estoque, 'MM', null)
						and	cd_material 		= movimento_estoque_w.cd_material;

						movimento_estoque_w.ie_movto_consignado := 'C';					
					end if;

					if (movimento_estoque_w.qt_inventario > qt_saldo_estoque_w) then
						/*generar un movimiento de stock con una operacion de tipo Inventario que sea de Entrada, para aumentar el saldo.*/

						movimento_estoque_w.qt_movimento := abs(movimento_estoque_w.qt_inventario - qt_saldo_estoque_w);

						select	max(cd_operacao_estoque)
						into STRICT	movimento_estoque_w.cd_operacao_estoque
						from(
							SELECT 	max(cd_operacao_estoque) cd_operacao_estoque
							from	operacao_estoque
							where 	ie_situacao = 'A'
							and	coalesce(ie_consignado,'0') = '0'
							and	ie_entrada_saida = 'E'
							and 	ie_tipo_requisicao = '5'
							and	((ie_consignado_w = '0') or
								((ie_consignado_w = '2') and (coalesce(movimento_estoque_w.cd_fornecedor::text, '') = '')))
							
union

							SELECT 	max(cd_operacao_estoque)
							from	operacao_estoque
							where 	ie_situacao = 'A'
							and	coalesce(ie_consignado,'0') = '7'
							and	ie_entrada_saida = 'E'
							and 	ie_tipo_requisicao = '5'
							and	((ie_consignado_w = '1') or
								(ie_consignado_w = '2' AND movimento_estoque_w.cd_fornecedor IS NOT NULL AND movimento_estoque_w.cd_fornecedor::text <> '')));


					elsif (movimento_estoque_w.qt_inventario < qt_saldo_estoque_w) then
						/*generar un movimiento de stock con una operacion de tipo Inventario que sea de Salida, para disminuir el saldo.*/

						movimento_estoque_w.qt_movimento := abs(movimento_estoque_w.qt_inventario - qt_saldo_estoque_w);

						select	max(cd_operacao_estoque)
						into STRICT	movimento_estoque_w.cd_operacao_estoque
						from(
							SELECT 	max(cd_operacao_estoque) cd_operacao_estoque
							from	operacao_estoque
							where 	ie_situacao = 'A'
							and	coalesce(ie_consignado,'0') = '0'
							and	ie_entrada_saida = 'S'
							and 	ie_tipo_requisicao = '5'
							and	((ie_consignado_w = '0') or
								((ie_consignado_w = '2') and (coalesce(movimento_estoque_w.cd_fornecedor::text, '') = '')))
							
union

							SELECT 	max(cd_operacao_estoque)
							from	operacao_estoque
							where 	ie_situacao = 'A'
							and	coalesce(ie_consignado,'0') = '7'
							and	ie_entrada_saida = 'S'
							and 	ie_tipo_requisicao = '5'
							and	((ie_consignado_w = '1') or
								(ie_consignado_w = '2' AND movimento_estoque_w.cd_fornecedor IS NOT NULL AND movimento_estoque_w.cd_fornecedor::text <> '')));

					elsif (movimento_estoque_w.qt_inventario = qt_saldo_estoque_w) then
						/*O movimento de estoque nao sera gerado, porque o saldo do Tasy ja esta igual ao saldo do sistema externo*/

						intpd_gravar_log_recebimento(nr_sequencia_p,wheb_mensagem_pck.get_texto(1015973),'INTPDTASY','0006');
						ie_erro_w := 'S';
					end if;

					movimento_estoque_w.ie_origem_documento	:=	'5'; /*'Inventario'*/
					end;
				end if;

				end;
			end if;

			if (coalesce(movimento_estoque_w.cd_operacao_estoque,0) = 0) then
				/*Nao foi encontrada nenhuma operacao de estoque cadastrada correspondente a este movimento de estoque.*/

				intpd_gravar_log_recebimento(nr_sequencia_p,wheb_mensagem_pck.get_texto(1015967),'INTPDTASY','0007');
				ie_erro_w := 'S';
			end if;

			if (ie_erro_w = 'N') then
				begin

				movimento_estoque_w.qt_estoque		:=	obter_quantidade_convertida(movimento_estoque_w.cd_material, movimento_estoque_w.qt_movimento, movimento_estoque_w.cd_unidade_med_mov, 'UME');

				if (movimento_estoque_w.cd_operacao_estoque IS NOT NULL AND movimento_estoque_w.cd_operacao_estoque::text <> '') and (movimento_estoque_w.cd_lote_fabricacao IS NOT NULL AND movimento_estoque_w.cd_lote_fabricacao::text <> '') and (movimento_estoque_w.cd_fornecedor IS NOT NULL AND movimento_estoque_w.cd_fornecedor::text <> '') and (coalesce(ie_tipo_requisicao_w,'0') = '6') and /*6 = Nota fiscal compra, dominio 21 */
					(coalesce(ie_entrada_saida_w,'S') = 'E') then /*E = Entrada*/
					begin

					if (coalesce(movimento_estoque_w.nr_seq_lote_fornec, 0) > 0) then
						update	material_lote_fornec
						set	qt_material = qt_material + movimento_estoque_w.qt_estoque,
							dt_atualizacao = clock_timestamp(),
							nm_usuario = movimento_estoque_w.nm_usuario
						where	nr_sequencia = movimento_estoque_w.nr_seq_lote_fornec;
					else
						select	coalesce(max(nr_sequencia), 0)
						into STRICT	movimento_estoque_w.nr_seq_lote_fornec
						from	material_lote_fornec
						where	cd_material = movimento_estoque_w.cd_material
						and	cd_estabelecimento = movimento_estoque_w.cd_estabelecimento
						and	cd_cgc_fornec = movimento_estoque_w.cd_fornecedor
						and	ds_lote_fornec = movimento_estoque_w.cd_lote_fabricacao
						and	coalesce(dt_validade, clock_timestamp()) = coalesce(movimento_estoque_w.dt_validade, clock_timestamp());
						
						if (coalesce(movimento_estoque_w.nr_seq_lote_fornec, 0) > 0) then
							update	material_lote_fornec
							set	qt_material = qt_material + movimento_estoque_w.qt_estoque,
								dt_atualizacao = clock_timestamp(),
								nm_usuario = movimento_estoque_w.nm_usuario
							where	nr_sequencia = movimento_estoque_w.nr_seq_lote_fornec;
						else					
							select	nextval('material_lote_fornec_seq')
							into STRICT	movimento_estoque_w.nr_seq_lote_fornec
							;

							insert into material_lote_fornec(
								nr_sequencia,
								cd_material,
								nr_digito_verif,
								dt_atualizacao,
								nm_usuario,
								ds_lote_fornec,
								dt_validade,
								cd_cgc_fornec,
								qt_material,
								cd_estabelecimento,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								ie_origem_lote,
								ie_validade_indeterminada,
								ie_situacao,
								ds_barras,
								cd_barra_material)
							values ( movimento_estoque_w.nr_seq_lote_fornec,
								movimento_estoque_w.cd_material,
								calcula_digito('MODULO11', nextval('material_lote_fornec_seq')),
								clock_timestamp(),
								movimento_estoque_w.nm_usuario,
								movimento_estoque_w.cd_lote_fabricacao,
								movimento_estoque_w.dt_validade,
								movimento_estoque_w.cd_fornecedor,
								movimento_estoque_w.qt_estoque,
								movimento_estoque_w.cd_estabelecimento,
								clock_timestamp(),
								movimento_estoque_w.nm_usuario,
								'I', /*integracao, dominio 1695*/
								CASE WHEN coalesce(movimento_estoque_w.dt_validade::text, '') = '' THEN  'S'  ELSE 'N' END ,
								'A',
								c01_w.ds_barras,
								c01_w.cd_barra_material);
						end if;
					end if;
					end;
				end if;

				if (c01_w.cd_barra_material IS NOT NULL AND c01_w.cd_barra_material::text <> '') then

					select 	count(*)
					into STRICT	qt_barra_material_w
					from	material_cod_barra
					where 	cd_barra_material = c01_w.cd_barra_material;

					if (qt_barra_material_w = 0) then
						begin
						insert into material_cod_barra(
							cd_material,
							cd_barra_material,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							dt_atualizacao,
							nm_usuario,
							ie_considerar_fornecedor,
							nr_seq_lote_fornec,
							qt_material,
							cd_cgc_fabricante)
						values (	movimento_estoque_w.cd_material,
							c01_w.cd_barra_material,
							clock_timestamp(),
							movimento_estoque_w.nm_usuario,
							clock_timestamp(),
							movimento_estoque_w.nm_usuario,
							'N',
							movimento_estoque_w.nr_seq_lote_fornec,
							null,
							movimento_estoque_w.cd_fornecedor);
						exception
							when unique_violation then
							intpd_gravar_log_recebimento(nr_sequencia_p, wheb_mensagem_pck.get_texto(1061331),'INTPDTASY');
						end;
					end if;
				end if;

				if (coalesce(movimento_estoque_w.nr_seq_lote_fornec::text, '') = '') and /*Quando a sequencia do lote fornecedor esta vazia, ele buscara o lote fornecedor atraves do codigo de barras e do codigo do material*/
					(movimento_estoque_w.cd_fornecedor IS NOT NULL AND movimento_estoque_w.cd_fornecedor::text <> '') and (c01_w.cd_barra_material IS NOT NULL AND c01_w.cd_barra_material::text <> '') then
					begin
					/*Busca o lote fornecedor para vincular com o movimento de estoque (quando sistema externo nao manda a sequencia do lote)*/

					select	max(nr_sequencia)
					into STRICT	movimento_estoque_w.nr_seq_lote_fornec
					from	material_lote_fornec
					where	cd_barra_material = c01_w.cd_barra_material
					and	cd_material = movimento_estoque_w.cd_material;
					end;
				end if;

				select	nextval('movimento_estoque_seq')
				into STRICT	movimento_estoque_w.nr_movimento_estoque
				;

				insert into movimento_estoque values (movimento_estoque_w.*);

				open c02;
				loop
				fetch c02 into
					c02_w;
				EXIT WHEN NOT FOUND; /* apply on c02 */
					begin
					/*'Alimenta as informacoes de controle e consistencia referente ao Elemento a ser processado no momento. E importante manter dentro do cursor e nao fora.'*/

					reg_integracao_w.nm_tabela				:=	'MOVIMENTO_ESTOQUE_VALOR';
					reg_integracao_w.nm_elemento			:=	'STOCK_MOVEMENT_VALUE';
					reg_integracao_w.nr_seq_visao			:=	27754;

					movimento_estoque_valor_w.nr_movimento_estoque	:=	movimento_estoque_w.nr_movimento_estoque;
					movimento_estoque_valor_w.nm_usuario		:=	movimento_estoque_w.nm_usuario;
					movimento_estoque_valor_w.dt_atualizacao		:=	clock_timestamp();

					/*'Consiste cada atributo do XML'*/

					SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_TIPO_VALOR', c02_w.cd_tipo_valor, 'S', movimento_estoque_valor_w.cd_tipo_valor) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_valor_w.cd_tipo_valor := _ora2pg_r.ds_valor_retorno_p;
					SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'VL_MOVIMENTO', c02_w.vl_movimento, 'N', movimento_estoque_valor_w.vl_movimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; movimento_estoque_valor_w.vl_movimento := _ora2pg_r.ds_valor_retorno_p;

					/*'Efetua a atualizacao caso nao possua consistencia '*/

					if (reg_integracao_w.qt_reg_log = 0) then
						insert into movimento_estoque_valor values (movimento_estoque_valor_w.*);
					end if;
					end;
				end loop;
				close c02;
				end;
			end if;
		end if;
		end;
	end if;
	end;
end loop;
close c01;
exception
when others then
	begin
	/*'Em caso de qualquer falha o sistema captura a mensagem de erro, efetua o rollback, atualiza o status para Erro e registra a falha ocorrida'*/

	ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);

	rollback;
	update	intpd_fila_transmissao
	set	ie_status = 'E',
		cd_default_message 	= CASE WHEN ds_erro_w = NULL THEN null  ELSE '0005' END ,
		ds_log = ds_erro_w,
		nr_doc_externo = c01_w.nr_doc_externo
	where	nr_sequencia = nr_sequencia_p;
	end;

	ie_exception_w := 'S';
end;

if (ie_exception_w = 'N') then

	if	((reg_integracao_w.qt_reg_log > 0) or (ie_erro_w = 'S')) then
		begin
		/*'Em caso de qualquer consistencia o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistencia'*/

		rollback;

		update	intpd_fila_transmissao
		set	ie_status = 'E',
			cd_default_message 	= CASE WHEN ds_erro_w = NULL THEN null  ELSE '0005' END ,
			ds_log = ds_erro_w,
			nr_doc_externo = c01_w.nr_doc_externo
		where	nr_sequencia = nr_sequencia_p;

		for i in 0..reg_integracao_w.qt_reg_log-1 loop
			intpd_gravar_log_recebimento(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY',reg_integracao_w.intpd_log_receb[i].cd_default_message);
		end loop;
		end;
	else
		update	intpd_fila_transmissao
		set	ie_status 	 = 'S',
			cd_default_message = '0000',
			nr_seq_documento = movimento_estoque_w.nr_movimento_estoque,
			nr_doc_externo 	 = c01_w.nr_doc_externo
		where	nr_sequencia	 = nr_sequencia_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_recebe_movimento_estoque ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;

