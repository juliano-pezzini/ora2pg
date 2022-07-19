-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transf_local_est_consig_mexico (nr_requisicao_p bigint, nr_sequencia_p bigint, qt_atendida_p bigint, cd_motivo_baixa_p bigint, cd_operacao_estoque_p bigint, dt_atendimento_p timestamp, cd_barras_p text, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_movimento_estoque_w		movimento_estoque.nr_movimento_estoque%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type := 0;
cd_operacao_estoque_w		operacao_estoque.cd_operacao_estoque%type;
cd_oper_trans_saida_consig_w	parametro_estoque.cd_op_tr_saida_consig%type;
ie_gera_ordem_w			regra_ordem_consignado.ie_gera_ordem%type;
cd_local_entrega_w		local_estoque.cd_local_estoque%type;
cd_centro_custo_w		regra_ordem_consignado.cd_centro_custo%type;
pr_desconto_w			regra_ordem_consignado.pr_desconto%type;
nm_usuario_destino_w		regra_ordem_consignado.nm_usuario_dest%type;
cd_perfil_comunic_w		regra_ordem_consignado.cd_perfil_comunic%type;
cd_pessoa_solicitante_w		regra_ordem_consignado.cd_pessoa_solicitante%type;
ie_gera_oc_reposicao_w		regra_ordem_consignado.ie_gera_oc_reposicao%type;
qt_conv_estoque_consumo_w	material.qt_conv_estoque_consumo%type;
ds_material_w			material.ds_material%type;
lista_usuario_w			varchar(2000);
ie_pos_virgula_w		bigint;
ds_email_usuario_w		usuario.ds_email%type;
ds_lista_email_usuario_w	varchar(2000);
tam_lista_w			bigint;
ds_comunicacao_w		varchar(2000);
nm_usuario_w			usuario.nm_usuario%type;
cd_material_w			material.cd_material%type;
cd_operacao_correspondente_w	operacao_estoque.cd_operacao_correspondente%type;
ie_bloqueio_inventario_w	saldo_estoque.ie_bloqueio_inventario%type;
cd_pessoa_atende_w		usuario.cd_pessoa_fisica%type;
qt_existe_w			smallint;
nr_seq_cor_w			bigint;
dt_aprovacao_w			ordem_compra.dt_aprovacao%type;
cd_local_estoque_w		local_estoque.cd_local_estoque%type;
cd_local_estoque_destino_w	local_estoque.cd_local_estoque%type;
cd_cgc_fornecedor_w		item_requisicao_material.cd_cgc_fornecedor%type;
nr_seq_lote_fornec_w		item_requisicao_material.nr_seq_lote_fornec%type;
ds_operacao_w			operacao_estoque.ds_operacao%type;
dt_validade_w			material_lote_fornec.dt_validade%type;
ds_lote_fornec_w		material_lote_fornec.ds_lote_fornec%type;
ds_erro_w			varchar(4000);
ie_material_consignado_w	material.ie_consignado%type;
nr_ordem_compra_w		ordem_compra.nr_ordem_compra%type;
ie_consiste_oc_aprovada_w	varchar(1);
nr_item_oci_w			ordem_compra_item.nr_item_oci%type;
qt_item_ordem_w			double precision;
ds_lock_w			varchar(4000);
vl_coluna_w			varchar(4000);
vl_resultado_w		varchar(4000);
code				bigint;
c001				integer;


BEGIN

select	a.cd_estabelecimento,
	cd_local_estoque,
	coalesce(cd_local_estoque_destino, cd_local_estoque),
	CASE WHEN coalesce(b.cd_material_lido, 0)=0 THEN   b.cd_material  ELSE b.cd_material_lido END ,
	b.cd_cgc_fornecedor,
	b.nr_seq_lote_fornec
into STRICT	cd_estabelecimento_w,
	cd_local_estoque_w,
	cd_local_estoque_destino_w,
	cd_material_w,
	cd_cgc_fornecedor_w,
	nr_seq_lote_fornec_w
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao = b.nr_requisicao
and	b.nr_requisicao = nr_requisicao_p
and	b.nr_sequencia  = nr_sequencia_p;

if (coalesce(cd_cgc_fornecedor_w::text, '') = '') then
	/* 1109280 - A operacao e consignada e o item #@CD_MATERIAL#@ nao possui fornecedor informado. */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(1109280,'CD_MATERIAL=' || cd_material_w);
end if;

ie_bloqueio_inventario_w := coalesce(obter_se_material_bloqueio_inv(cd_estabelecimento_p	=> cd_estabelecimento_w,
						cd_material_p		=> cd_material_w,
						cd_local_estoque_p	=> cd_local_estoque_w), 'N');

if (ie_bloqueio_inventario_w = 'N') then
	begin
	cd_operacao_estoque_w := cd_operacao_estoque_p;
	
	select	ds_operacao
	into STRICT	ds_operacao_w
	from	operacao_estoque
	where	cd_operacao_estoque  = cd_operacao_estoque_w;
	
	if (nr_seq_lote_fornec_w IS NOT NULL AND nr_seq_lote_fornec_w::text <> '') then
		select	dt_validade,
			ds_lote_fornec
		into STRICT	dt_validade_w,
			ds_lote_fornec_w
		from	material_lote_fornec
		where	nr_sequencia = nr_seq_lote_fornec_w;
	end if;

	select	cd_op_tr_ent_proprio
	into STRICT	cd_operacao_correspondente_w
	from	parametro_estoque
	where	cd_estabelecimento = cd_estabelecimento_w;

	select nextval('movimento_estoque_seq')
	into STRICT nr_movimento_estoque_w
	;

	begin
	insert into movimento_estoque(
				nr_movimento_estoque,
				cd_estabelecimento,
				cd_local_estoque,
				dt_movimento_estoque,
				cd_operacao_estoque,
				cd_acao,
				cd_material,
				dt_mesano_referencia,
				qt_movimento,
				dt_atualizacao,
				nm_usuario,
				ie_origem_documento,
				nr_documento,
				nr_sequencia_item_docto,
				cd_unidade_medida_estoque,
				cd_setor_atendimento,
				qt_estoque,
				cd_local_estoque_destino,
				cd_centro_custo,
				cd_unidade_med_mov,
				cd_conta_contabil,
				cd_fornecedor,
				nr_seq_lote_fornec,
				dt_validade,
				cd_lote_fabricacao)
			SELECT	nr_movimento_estoque_w,
				c.cd_estabelecimento,
				cd_local_estoque_w,
				dt_atendimento_p,
				cd_operacao_estoque_w,
				ie_acao_p,
				cd_material_w,
				dt_atendimento_p,
				qt_atendida_p,
				clock_timestamp(),
				nm_usuario_p,
				'2',
				a.nr_requisicao,
				b.nr_sequencia,
				b.cd_unidade_medida_estoque,
				a.cd_setor_atendimento,
				qt_atendida_p,
				cd_local_estoque_destino_w,
				a.cd_centro_custo,
				b.cd_unidade_medida,
				b.cd_conta_contabil,
				CASE WHEN ie_acao_p='1' THEN cd_cgc_fornecedor_w  ELSE b.CD_CGC_FORNECEDOR END ,
				nr_seq_lote_fornec_w,
				dt_validade_w,
				ds_lote_fornec_w
			from	requisicao_material a,
				item_requisicao_material b,
				local_estoque c
			where	a.nr_requisicao = b.nr_requisicao
			and	a.cd_local_estoque = c.cd_local_estoque
			and	b.nr_requisicao = nr_requisicao_p
			and	b.nr_sequencia  = nr_sequencia_p;
	exception when others then
		begin
		ds_erro_w	:= substr(SQLERRM(SQLSTATE),1,4000);
		/*(-20011,'Erro Incluir Movimento_estoque ' || chr(13) || chr(10) || DS_ERRO_W);*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(196051,'DS_ERRO_W=' || ds_erro_w);
		end;
	end;

	select nextval('movimento_estoque_seq')
	into STRICT nr_movimento_estoque_w
	;
	
	begin
	insert into movimento_estoque(
				nr_movimento_estoque,
				cd_estabelecimento,
				cd_local_estoque,
				dt_movimento_estoque,
				cd_operacao_estoque,
				cd_acao,
				cd_material,
				dt_mesano_referencia,
				qt_movimento,
				dt_atualizacao,
				nm_usuario,
				ie_origem_documento,
				nr_documento,
				nr_sequencia_item_docto,
				cd_unidade_medida_estoque,
				cd_setor_atendimento,
				qt_estoque,
				cd_local_estoque_destino,
				cd_centro_custo,
				cd_unidade_med_mov,
				cd_conta_contabil,
				cd_fornecedor,
				nr_seq_lote_fornec,
				dt_validade,
				cd_lote_fabricacao)
			SELECT	nr_movimento_estoque_w,
				c.cd_estabelecimento,
				cd_local_estoque_destino_w,
				dt_atendimento_p,
				cd_operacao_correspondente_w,
				ie_acao_p,
				cd_material_w,
				dt_atendimento_p,
				qt_atendida_p,
				clock_timestamp(),
				nm_usuario_p,
				'2',
				a.nr_requisicao,
				b.nr_sequencia,
				b.cd_unidade_medida_estoque,
				a.cd_setor_atendimento,
				qt_atendida_p,
				cd_local_estoque_w,
				a.cd_centro_custo,
				b.cd_unidade_medida,
				b.cd_conta_contabil,
				CASE WHEN ie_acao_p='1' THEN cd_cgc_fornecedor_w  ELSE b.CD_CGC_FORNECEDOR END ,
				nr_seq_lote_fornec_w,
				dt_validade_w,
				ds_lote_fornec_w
			from	requisicao_material a,
				item_requisicao_material b,
				local_estoque c
			where	a.nr_requisicao = b.nr_requisicao
			and	a.cd_local_estoque = c.cd_local_estoque
			and	b.nr_requisicao = nr_requisicao_p
			and	b.nr_sequencia  = nr_sequencia_p;
	exception when others then
		begin
		ds_erro_w	:= substr(SQLERRM(SQLSTATE),1,4000);
		/*(-20011,'Erro Incluir Movimento_estoque ' || chr(13) || chr(10) || DS_ERRO_W);*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(196051,'DS_ERRO_W=' || ds_erro_w);
		end;
	end;
	
	select	coalesce(max(a.ie_consignado),'0'),
		max(a.ds_material),
		coalesce(max(a.qt_conv_estoque_consumo),1)
	into STRICT	ie_material_consignado_w,
		ds_material_w,
		qt_conv_estoque_consumo_w
	from	material a,
		material_Estab b
	where	a.cd_material = b.cd_material
	and	b.cd_estabelecimento = cd_estabelecimento_w
	and	a.cd_material	= cd_material_w;
	
	if (ie_acao_p = '1') then
		begin
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_atende_w
		from	usuario
		where	nm_usuario = nm_usuario_p;

		begin
		update	item_requisicao_material
		set 	dt_atendimento 	= dt_atendimento_p,
			qt_material_atendida = qt_atendida_p,
			cd_motivo_baixa	= cd_motivo_baixa_p,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp(),
			cd_pessoa_atende = cd_pessoa_atende_w,
			qt_estoque	= dividir(qt_atendida_p, qt_conv_estoque_consumo_w),
			cd_barras 	= cd_barras_p,
			cd_cgc_fornecedor = cd_cgc_fornecedor_w
		where	nr_requisicao	= nr_requisicao_p
		and	nr_sequencia	= nr_sequencia_p;
		exception
		when others then
			begin
			ds_lock_w := 	' select substr(''sid=''||b.session_id || ''#oracle_username='' || ' ||
					' substr(b.oracle_username,1,15) || ''#locked_mode=''|| ' ||
					' substr(decode (b.locked_mode, 0, ''NONE'', 1, ''NULL (NULL)'', 2, ''ROW-S (SS)'', 3, ''ROW-X (SX)'',' ||
					' 4, ''SHARE (S)'', 5, ''S/ROW-X (SSX)'', 6, ''EXCLUSIVE (X)'', b.locked_mode),1,15)||' ||
					'''#user_name=''||substr(b.os_user_name,1,15)||''#status=''||substr(c.status,1,15)||''#program=''||substr(c.program,1,15)||' ||
					'''#machine=''||substr(c.machine,1,15)||''#module=''||substr(c.MODULE,1,15)||'||
					'''#plsql=''||substr((select object_name from user_objects d where d.object_id = c.plsql_object_id),1,30),1,4000) ds_lock ' ||
					' from user_objects a, gv$locked_object b, gv$session c where a.object_id = b.object_id ' ||
					' and b.session_id = c.sid and rownum = 1 and a.object_name = ''ITEM_REQUISICAO_MATERIAL''';

			c001	:= dbms_sql.open_cursor;
			dbms_sql.parse(c001,ds_lock_w,dbms_sql.native);
			dbms_sql.define_column(c001, 1, vl_coluna_w, 4000);
			vl_resultado_w	:= dbms_sql.execute(c001);
			vl_resultado_w	:= dbms_sql.fetch_rows(c001);
			dbms_sql.column_value(c001,1,vl_coluna_w);
			dbms_sql.close_cursor(c001);
			ds_lock_w := coalesce(vl_coluna_w,'X');

			ds_erro_w	:=	substr(sqlerrm,1,500);
			code		:= 	SQLSTATE;

			ds_lock_w	:= 	substr(ds_lock_w ||  chr(13) || chr(10) || chr(13) || chr(10) ||
						ds_erro_w || chr(13) || chr(10) || chr(13) || chr(10) ||
						substr(dbms_utility.format_call_stack,1,1800),1,4000);
			
			rollback;

			CALL gerar_historico_requisicao(nr_requisicao_p, 'Deadlock', ds_erro_w, 'GM', nm_usuario_p);
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
				CALL wheb_mensagem_pck.exibir_mensagem_abort(267189,'DS_MENSAGEM=' || ds_erro_w);
			end;
		end;

		select	count(*)
		into STRICT	qt_existe_w
		from	item_requisicao_material
		where	nr_requisicao	= nr_requisicao_p
		and	nr_sequencia	= nr_sequencia_p
		and	(cd_material_lido IS NOT NULL AND cd_material_lido::text <> '');

		nr_seq_cor_w := 102;

		if (qt_existe_w > 0) then
			nr_seq_cor_w := 103;
		end if;

		update 	item_requisicao_material
		set	nr_seq_cor_exec	= nr_seq_cor_w
		where	nr_requisicao	= nr_requisicao_p
		and	nr_sequencia	= nr_sequencia_p;
		end;
	else
		begin
		update	item_requisicao_material
		set	dt_atendimento	 = NULL,
			qt_material_atendida	= 0,
			cd_motivo_baixa	= 0,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp(),
			cd_pessoa_atende	 = NULL,
			nr_seq_lote_fornec	 = NULL,
			cd_material_lido	 = NULL,
			nm_usuario_retirada	 = NULL,
			nr_seq_cor_exec	 = NULL,
			dt_recebimento	 = NULL,
			nm_usuario_receb	 = NULL
		where	nr_requisicao	= nr_requisicao_p
		and	nr_sequencia	= nr_sequencia_p;

		update item_requisicao_material
		set	nr_seq_cor_exec	= 103
		where	nr_requisicao	= nr_requisicao_p
		and	nr_sequencia	= nr_sequencia_p
		and	coalesce(nr_seq_cor_exec::text, '') = '';
		end;
	end if;

	/* Tratar consumo de consignados  */

	if (ie_acao_p = '2') and (ie_material_consignado_w = 1) or
		(cd_cgc_fornecedor_w IS NOT NULL AND cd_cgc_fornecedor_w::text <> '' AND ie_material_consignado_w = 2) then

		SELECT * FROM Obter_Regra_Ordem_Consignado(cd_estabelecimento_p	=> cd_estabelecimento_w, cd_local_estoque_p	=> cd_local_estoque_w, cd_operacao_estoque_p	=> cd_operacao_estoque_w, cd_material_p		=> cd_material_w, cd_cgc_p		=> cd_cgc_fornecedor_w, cd_convenio_p		=> 0, cd_setor_prescricao_p	=> 0, ie_gera_ordem_p		=> ie_gera_ordem_w, cd_local_entrega_p	=> cd_local_entrega_w, cd_centro_custo_p	=> cd_centro_custo_w, pr_desconto_p		=> pr_desconto_w, nm_usuario_dest_p	=> nm_usuario_destino_w, cd_perfil_comunic_p	=> cd_perfil_comunic_w, cd_pessoa_solicitante_p	=> cd_pessoa_solicitante_w, ie_gera_oc_reposicao_p	=> ie_gera_oc_reposicao_w) INTO STRICT ie_gera_ordem_p		=> ie_gera_ordem_w, cd_local_entrega_p	=> cd_local_entrega_w, cd_centro_custo_p	=> cd_centro_custo_w, pr_desconto_p		=> pr_desconto_w, nm_usuario_dest_p	=> nm_usuario_destino_w, cd_perfil_comunic_p	=> cd_perfil_comunic_w, cd_pessoa_solicitante_p	=> cd_pessoa_solicitante_w, ie_gera_oc_reposicao_p	=> ie_gera_oc_reposicao_w;

		if (ie_gera_ordem_w = 'S')  then
			select	coalesce(obter_ordem_atend_consignado(cd_estabelecimento_w, cd_cgc_fornecedor_w, cd_local_entrega_w, nr_requisicao_p, 0, 0,'G'),0)
			into STRICT	nr_ordem_compra_w
			;
			
			ie_consiste_oc_aprovada_w := Obter_Valor_Param_Usuario(109, 65, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w);

			if (ie_consiste_oc_aprovada_w = 'S') and (ie_acao_p = '2') and (nr_ordem_compra_w > 0) then

				select	dt_aprovacao
				into STRICT	dt_aprovacao_w
				from	ordem_compra
				where	nr_ordem_compra = nr_ordem_compra_w;

				if (dt_aprovacao_w IS NOT NULL AND dt_aprovacao_w::text <> '') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(196047,'NR_ORDEM_COMPRA_W=' || nr_ordem_compra_w);
					/*(-20011,'Nao eh possivel estornar a baixa deste item, pois a ordem de compra numero ' || NR_ORDEM_COMPRA_W ||' (que foi gerada no atendimento  deste  item) ' ||
									'ja esta aprovada. Verifique o parametro [65]. Para realizar essa acao, deve ser estornado a aprovacao da ordem');*/
				end if;
			end if;

			if (nr_ordem_compra_w > 0) then
				select	coalesce(min(b.nr_item_oci),0)
				into STRICT	nr_item_oci_w
				from	ordem_compra_item b
				where	b.nr_ordem_compra = nr_ordem_compra_w
				and	b.cd_material in (
					SELECT	x.cd_material
					from	material x
					where	x.cd_material_estoque = cd_material_w
					
union

					SELECT	x.cd_material
					from	material x
					where	x.cd_material	= cd_material_w)
				and	b.qt_material >= qt_atendida_p;

				if (nr_item_oci_w > 0) then

					update	ordem_compra_item
					set	qt_material	= qt_material - qt_atendida_p,
						vl_total_item = round(( (qt_material - qt_atendida_p) * vl_unitario_material),4)
					where	nr_ordem_compra	= nr_ordem_compra_w
					and	nr_item_oci	= nr_item_oci_w;

					update	ordem_compra_item_entrega
					set	qt_prevista_entrega	= qt_prevista_entrega - qt_atendida_p
					where	nr_ordem_compra	= nr_ordem_compra_w
					and	nr_item_oci	= nr_item_oci_w
					and	dt_prevista_entrega	=
						(SELECT max(dt_prevista_entrega)
						from	ordem_compra_item_entrega
						where	nr_ordem_compra	= nr_ordem_compra_w
						and	nr_item_oci	= nr_item_oci_w
						and	coalesce(dt_cancelamento::text, '') = '');

					select	coalesce(sum(qt_material),0)
					into STRICT	qt_item_ordem_w
					from	ordem_compra_item
					where	nr_ordem_compra	= nr_ordem_compra_w
					and	nr_item_oci	= nr_item_oci_w;

					if (qt_item_ordem_w = 0) then
						delete from	ordem_compra_item
						where	nr_ordem_compra	= nr_ordem_compra_w
						and	nr_item_oci	= nr_item_oci_w;
					end if;
				end if;
			end if;
		end if;
	end if;

	if (ie_acao_p = '1') and
		((ie_material_consignado_w = 1) or ((cd_cgc_fornecedor_w IS NOT NULL AND cd_cgc_fornecedor_w::text <> '') and ie_material_consignado_w = 2)) then
		begin			
		SELECT * FROM Obter_Regra_Ordem_Consignado(cd_estabelecimento_p	=> cd_estabelecimento_w, cd_local_estoque_p	=> cd_local_estoque_w, cd_operacao_estoque_p	=> cd_operacao_estoque_w, cd_material_p		=> cd_material_w, cd_cgc_p		=> cd_cgc_fornecedor_w, cd_convenio_p		=> 0, cd_setor_prescricao_p	=> 0, ie_gera_ordem_p		=> ie_gera_ordem_w, cd_local_entrega_p	=> cd_local_entrega_w, cd_centro_custo_p	=> cd_centro_custo_w, pr_desconto_p		=> pr_desconto_w, nm_usuario_dest_p	=> nm_usuario_destino_w, cd_perfil_comunic_p	=> cd_perfil_comunic_w, cd_pessoa_solicitante_p	=> cd_pessoa_solicitante_w, ie_gera_oc_reposicao_p	=> ie_gera_oc_reposicao_w) INTO STRICT ie_gera_ordem_p		=> ie_gera_ordem_w, cd_local_entrega_p	=> cd_local_entrega_w, cd_centro_custo_p	=> cd_centro_custo_w, pr_desconto_p		=> pr_desconto_w, nm_usuario_dest_p	=> nm_usuario_destino_w, cd_perfil_comunic_p	=> cd_perfil_comunic_w, cd_pessoa_solicitante_p	=> cd_pessoa_solicitante_w, ie_gera_oc_reposicao_p	=> ie_gera_oc_reposicao_w;
			
		ds_comunicacao_w :=	substr(wheb_mensagem_pck.get_texto(280833) || cd_material_w || ' ' || ds_material_w || CHR(10) ||
					wheb_mensagem_pck.get_texto(280834) || qt_atendida_p || CHR(10) ||
					wheb_mensagem_pck.get_texto(280837) || nr_requisicao_p || CHR(10) ||
					wheb_mensagem_pck.get_texto(280838) || ds_operacao_w,1,2000);

		if (ie_gera_ordem_w in ('S','A','O'))  then
			CALL gerar_ordem_compra_Req_consig(
				cd_estabelecimento_p	=> cd_estabelecimento_w,
				cd_fornecedor_p		=> cd_cgc_fornecedor_w,
				cd_local_entrega_p	=> cd_local_entrega_w,
				cd_material_p		=> cd_material_w,
				qt_material_p		=> qt_atendida_p,
				nm_usuario_p		=> nm_usuario_p,
				nr_requisicao_p		=> nr_requisicao_p,
				cd_acao_p		=> ie_acao_p,
				nr_sequencia_p		=> nr_sequencia_p);
			if (ie_gera_ordem_w = 'A') then
				CALL Gerar_comunic_consignado(nm_usuario_p,nm_usuario_destino_w,ds_comunicacao_w,cd_perfil_comunic_w);
			end if;

			if (ie_gera_ordem_w = 'O') then
				lista_usuario_w	:= substr(nm_usuario_destino_w,1,2000);

				while(lista_usuario_w IS NOT NULL AND lista_usuario_w::text <> '') and (trim(both lista_usuario_w) <> ',') loop
					tam_lista_w		:= length(lista_usuario_w);
					ie_pos_virgula_w	:= position(',' in lista_usuario_w);
					if (ie_pos_virgula_w <> 0) then
						nm_usuario_w	:= substr(lista_usuario_w,1,(ie_pos_virgula_w - 1));
						lista_usuario_w	:= substr(lista_usuario_w,(ie_pos_virgula_w + 2), tam_lista_w);

						select	trim(both max(ds_email))
						into STRICT	ds_email_usuario_w
						from	usuario
						where	nm_usuario = nm_usuario_w;

						if (coalesce(ds_email_usuario_w,'X') <> 'X') then
							begin
							ds_lista_email_usuario_w	:= substr(ds_lista_email_usuario_w||ds_email_usuario_w||',',1,2000);
							end;
						end if;
					else
						lista_usuario_w	:= null;
					end if;
				end loop;

				if (coalesce(ds_lista_email_usuario_w,'X') <> 'X') then
					begin
					CALL Enviar_Email(wheb_mensagem_pck.get_texto(301563),ds_comunicacao_w, null, ds_lista_email_usuario_w, nm_usuario_p,'M');
					exception
					when others then
						null;
					end;
				end if;
			end if;
		elsif (ie_gera_ordem_w = 'C') then
			CALL Gerar_comunic_consignado(nm_usuario_p,nm_usuario_destino_w,ds_comunicacao_w,cd_perfil_comunic_w);
		elsif (ie_gera_ordem_w = 'E') then
			lista_usuario_w	:= substr(nm_usuario_destino_w,1,2000);

			while(lista_usuario_w IS NOT NULL AND lista_usuario_w::text <> '') and (trim(both lista_usuario_w) <> ',') loop
				tam_lista_w		:= length(lista_usuario_w);
				ie_pos_virgula_w	:= position(',' in lista_usuario_w);
				if (ie_pos_virgula_w <> 0) then
					nm_usuario_w	:= substr(lista_usuario_w,1,(ie_pos_virgula_w - 1));
					lista_usuario_w	:= substr(lista_usuario_w,(ie_pos_virgula_w + 2), tam_lista_w);

					select	trim(both max(ds_email))
					into STRICT	ds_email_usuario_w
					from	usuario
					where	nm_usuario = nm_usuario_w;

					if (coalesce(ds_email_usuario_w,'X') <> 'X') then
						begin
						ds_lista_email_usuario_w := substr(ds_lista_email_usuario_w||ds_email_usuario_w||',',1,2000);
						end;
					end if;
				else
					lista_usuario_w	:= null;
				end if;
			end loop;

			if (coalesce(ds_lista_email_usuario_w,'X') <> 'X') then
				begin
				CALL Enviar_Email(wheb_mensagem_pck.get_texto(301563),ds_comunicacao_w, null, ds_lista_email_usuario_w, nm_usuario_p,'M');
				exception
				when others then
					null;
				end;
			end if;
		end if;
		end;
	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transf_local_est_consig_mexico (nr_requisicao_p bigint, nr_sequencia_p bigint, qt_atendida_p bigint, cd_motivo_baixa_p bigint, cd_operacao_estoque_p bigint, dt_atendimento_p timestamp, cd_barras_p text, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

