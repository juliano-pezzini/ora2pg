-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_devolucao_med ( nr_devolucao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_tipo_baixa_p bigint, qt_material_estoque_p bigint, cd_pessoa_fisica_p text, cd_local_estoque_p bigint, ie_baixa_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


dt_atualizacao_w			timestamp		:= clock_timestamp();
nr_atendimento_w			bigint	:= 0;
nr_atendimento_ww			bigint	:= 0;
nr_sequencia_w			bigint	:= 0;
cd_setor_atendimento_w		integer    	:= 0;
cd_setor_regra_oc_consig_w		integer    	:= 0;
dt_entrada_unidade_w		timestamp;
cd_material_w			integer	:= 0;
qt_material_w			double precision	:= 0;
qt_material_disp_w			double precision	:= 0;
qt_material_liq_w			double precision	:= 0;
dt_atendimento_w			timestamp;
dt_recebimento_w			timestamp;
qt_mat_atend_w			bigint;
cd_unidade_medida_w		varchar(30)	:= '';
flag_ok_w			varchar(1)	:= 'S';
nr_devolucao_w			bigint	:= 0;
nr_seq_devolucao_w		bigint	:= 0;
nr_prescricao_w			bigint	:= 0;
nr_seq_prescricao_w		bigint	:= 0;
cd_motivo_devolucao_w		varchar(03);
ie_conta_paciente_w		varchar(1);
ie_atualiza_estoque_w		varchar(1);
ie_fim_conta_w			varchar(1);
cd_cgc_fornec_w			varchar(14);
nr_seq_atendimento_w		bigint;
nr_ordem_compra_w		bigint;
nr_item_oci_w			bigint;
ie_consignado_w			varchar(01)	:= 'N';
nm_usuario_ww			varchar(255);
nm_usuario_dest_w		varchar(255);
nr_seq_classif_w		bigint;
cd_estabelecimento_w		bigint;
ds_material_w			varchar(255);
ie_baixa_estoque_pac_w		varchar(01);
cd_operacao_devol_paciente_w	smallint;
ie_gera_ordem_w			varchar(1);
cd_local_entrega_w		bigint;
cd_centro_custo_w		bigint;
pr_desconto_w			bigint;
cd_pessoa_solicitante_w		varchar(10);
nr_seq_lote_fornec_w		bigint;
ie_tipo_data_w			varchar(1);
dt_baixa_conta_w		timestamp;
dt_aprovacao_w			timestamp;
ie_consiste_oc_aprov_w		varchar(1);
ie_doc_interno_w		varchar(1);
nr_doc_interno_w		bigint;
nr_seq_lote_w			bigint;
ie_status_lote_w		varchar(2);
ie_cancela_lote_w		varchar(1);
ie_considera_alta_w		varchar(1);
qt_material_oc_w		double precision;
ie_exclui_item_oc_w		varchar(1);
cd_perfil_comunic_w		varchar(10);
ds_erro_w			varchar(2000);
cd_convenio_w			bigint;
ie_cons_item_exc_w		varchar(1);
qt_existe_w			integer	:= 0;
nr_kit_estoque_w		bigint;
nr_seq_lote_dev_mat_w		bigint;
ds_comunicacao_w		varchar(2000);
lista_usuario_w			varchar(2000);
tam_lista_w			bigint;
ie_pos_virgula_w		bigint;
ds_email_usuario_w		varchar(255);
ds_lista_email_usuario_w	varchar(2000);
nm_usuario_w			varchar(2000);
ie_gera_oc_reposicao_w		varchar(1);
ie_tipo_ordem_w			ordem_compra.ie_tipo_ordem%type;
ds_log_w             varchar(2000);

c01 CURSOR FOR
	SELECT	coalesce(obter_ordem_atend_consignado(cd_estabelecimento_p, cd_cgc_fornec_w, cd_local_estoque_p, 0, nr_atendimento_w, coalesce(nr_prescricao_w,0),'G'),0), /* ordem de consumo de consignado*/
		'G'
	
	
union all

		SELECT	coalesce(obter_ordem_atend_consignado(cd_estabelecimento_p, cd_cgc_fornec_w, cd_local_estoque_p, 0, nr_atendimento_w, coalesce(nr_prescricao_w,0),'W'),0), /* ordem de reposicao de consignado*/
		'W'
	;


BEGIN

ds_log_w := substr('NR_DEVOLUCAO_P=' || nr_devolucao_p ||
                   ';NR_SEQUENCIA_P=' || nr_sequencia_p || 
                   ';CD_TIPO_BAIXA_P=' || cd_tipo_baixa_p ||
                   ';QT_MATERIAL_ESTOQUE_P=' || qt_material_estoque_p ||
                   ';CD_PESSOA_FISICA_P=' || cd_pessoa_fisica_p ||
                   ';CD_LOCAL_ESTOQUE_P=' || cd_local_estoque_p ||
                   ';IE_BAIXA_P=' || ie_baixa_p ||
                   ';CD_ESTABELECIMENTO_P=' || cd_estabelecimento_p ||
                   ';CALL STACK='|| substr(dbms_utility.format_call_stack,1,1800),1,2000);

CALL gravar_log_tasy(1291, ds_log_w, nm_usuario_p);

flag_ok_w := 'S';
ie_tipo_data_w := obter_param_usuario(42, 68, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_tipo_data_w);
ie_consiste_oc_aprov_w := obter_param_usuario(42, 74, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_oc_aprov_w);
ie_doc_interno_w := obter_param_usuario(42, 76, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_doc_interno_w);
ie_cancela_lote_w := obter_param_usuario(42, 77, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_cancela_lote_w);
ie_considera_alta_w := obter_param_usuario(42, 79, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_considera_alta_w);
ie_exclui_item_oc_w := obter_param_usuario(42, 82, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exclui_item_oc_w);
ie_cons_item_exc_w := obter_param_usuario(42, 117, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_cons_item_exc_w);

/* obter o registro da devolucao de material do paciente */

begin
select	a.ie_conta_paciente,
	a.ie_atualiza_estoque
into STRICT	ie_conta_paciente_w,
	ie_atualiza_estoque_w
from	tipo_baixa_prescricao a
where	a.ie_prescricao_devolucao = 'D'
and	a.cd_tipo_baixa = cd_tipo_baixa_p;
exception
	when others then
        flag_ok_w := 'N';
end;
begin
select	a.nr_atendimento,
	coalesce(b.dt_entrada_unidade, a.dt_entrada_unidade) dt_entrada_unidade,
	a.cd_setor_atendimento,
	b.cd_material,
	b.qt_material,
	b.dt_atendimento,
	b.cd_unidade_medida,
	a.nr_devolucao,
	b.nr_sequencia,
	b.nr_prescricao,
	CASE WHEN b.nr_sequencia_prescricao=0 THEN  null  ELSE b.nr_sequencia_prescricao END ,
	b.cd_motivo_devolucao,
	b.cd_cgc_fornec,
	b.nr_seq_atendimento,
	substr(obter_desc_material(b.cd_material),1,255),
	b.nr_seq_lote_fornec,
	dt_baixa_conta,
	nr_doc_interno,
	b.nr_kit_estoque,
	nr_seq_lote
into STRICT	nr_atendimento_w,
	dt_entrada_unidade_w,
	cd_setor_atendimento_w,
	cd_material_w,
	qt_material_w,
	dt_atendimento_w,
	cd_unidade_medida_w,
	nr_devolucao_w,
	nr_seq_devolucao_w,
	nr_prescricao_w,
	nr_seq_prescricao_w,
	cd_motivo_devolucao_w,
	cd_cgc_fornec_w,
	nr_seq_atendimento_w,
	ds_material_w,
	nr_seq_lote_fornec_w,
	dt_baixa_conta_w,
	nr_doc_interno_w,
	nr_kit_estoque_w,
	nr_seq_lote_dev_mat_w
from	devolucao_material_pac a,
	item_devolucao_material_pac b
where	a.nr_devolucao  = nr_devolucao_p
and	b.nr_devolucao  = a.nr_devolucao
and	b.nr_sequencia  = nr_sequencia_p
and	coalesce(dt_recebimento::text, '') = '';
exception
	when others then
        	flag_ok_w := 'N';
end;

select	coalesce(max(cd_convenio),0),
	coalesce(max(cd_setor_atendimento),0)
into STRICT	cd_convenio_w,
	cd_setor_regra_oc_consig_w
from	material_atend_paciente
where	nr_sequencia = nr_seq_atendimento_w;

/* ricardo 30/03/2004 - inclui o teste da baixa do estoque do paciente */

if (flag_ok_w	= 'S') then
	begin
	select	obter_se_baixa_estoque_pac(cd_setor_atendimento_w, cd_material_w,null,0)
	into STRICT	ie_baixa_estoque_pac_w
	;
	end;
end if;
/* fim alteracao (observar onde utiliza a variavel ie_baixa_estoque_pac_w */

if (coalesce(nr_prescricao_w,0) > 0) and (coalesce(nr_seq_prescricao_w,0) > 0) then

	select	count(*)
	into STRICT	qt_mat_atend_w
	from	material_atend_paciente
	where	nr_prescricao		= nr_prescricao_w
	and	nr_sequencia_prescricao	= nr_seq_prescricao_w;

	if (qt_mat_atend_w = 0) then
	  	/*(-20011, 'O material ' || ds_material_w || ' nao pode ser devolvido porque nao foi executado! ');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(196044,'DS_MATERIAL_W='||ds_material_w);
	end if;

	select	coalesce(sum(qt_material),0)
	into STRICT	qt_material_disp_w
	from	material_atend_paciente
	where	nr_prescricao		= nr_prescricao_w
	and	nr_sequencia_prescricao	= nr_seq_prescricao_w;

	if (qt_material_estoque_p > qt_material_disp_w) then
		select	sum(b.qt_material)
		into STRICT	qt_material_disp_w
		from	devolucao_material_pac a,
       			item_devolucao_material_pac b
		where	a.nr_devolucao  	= nr_devolucao_p
		and	b.nr_devolucao  	= a.nr_devolucao
		and	b.cd_material	= cd_material_w
		and	coalesce(b.dt_recebimento::text, '') = '';

		/* 28/09/2004 - fabio adicionei mais este if, pois pode ter o mesmo material
				em mais de uma prescricao e na mesma devolucao*/
		if (qt_material_estoque_p > qt_material_disp_w) and (ie_conta_paciente_w = 'S') then
			/*(-20011, 'O saldo: ' || qt_material_disp_w || ' e menor que a quantidade a devolver: ' ||qt_material_estoque_p);*/

			CALL wheb_mensagem_pck.exibir_mensagem_abort(196043,	'QT_MATERIAL_DISP_W='||qt_material_disp_w||';'||
									'QT_MATERIAL_ESTOQUE_P='||qt_material_estoque_p);
		end if;
	end if;
end if;

/*   se o paciente ja teve o fim atendimento informado nao gerar nova conta */

if (coalesce(nr_atendimento_w,0) = 0) then
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_ww
	from	devolucao_material_pac a,
		item_devolucao_material_pac b
	where	a.nr_devolucao  = nr_devolucao_p
	and	b.nr_devolucao  = a.nr_devolucao
	and	b.nr_sequencia  = nr_sequencia_p;
	
	nr_atendimento_w := nr_atendimento_ww;
end if;

if (ie_tipo_data_w = 'A') then
	dt_recebimento_w := clock_timestamp();
elsif (ie_tipo_data_w = 'P') then
	select	coalesce(dt_prescricao,clock_timestamp())
	into STRICT	dt_recebimento_w
	from	material_atend_paciente
	where	nr_sequencia = nr_seq_atendimento_w;
elsif (ie_tipo_data_w = 'D') then
	dt_recebimento_w := coalesce(dt_atendimento_w,clock_timestamp());
end if;

select	ie_fim_conta,
	CASE WHEN ie_considera_alta_w='N' THEN coalesce(dt_alta,dt_recebimento_w)  ELSE dt_recebimento_w END ,
	cd_estabelecimento
into STRICT	ie_fim_conta_w,
	dt_recebimento_w,
	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_w;

if (ie_fim_conta_w = 'F') and (ie_conta_paciente_w = 'S') then
	ie_conta_paciente_w	:= 'N';
end if;

if (ie_cons_item_exc_w = 'S') then
	select	count(*)
	into STRICT	qt_existe_w
	from	material_atend_paciente
	where	coalesce(nr_interno_conta::text, '') = ''
	and	(cd_motivo_exc_conta IS NOT NULL AND cd_motivo_exc_conta::text <> '')
	and	nr_sequencia = nr_seq_atendimento_w;
end if;
/*   inserir dados do material */

if (qt_existe_w = 0) and (flag_ok_w = 'S') and (ie_conta_paciente_w = 'S') and (coalesce(dt_baixa_conta_w::text, '') = '') then
    	begin
	select	nextval('material_atend_paciente_seq')
	into STRICT	nr_sequencia_w
     	;
	
	begin
	qt_material_liq_w := qt_material_w - coalesce(qt_material_estoque_p,0);
	if (qt_material_liq_w = 0) then
		qt_material_liq_w	:= qt_material_w;
	end if;
	if (qt_material_liq_w < 0) then /* matheus os 93253 16/06/2008 coloquei esta restricao para identificar itens negativos*/

		/*(-20011,'Erro ao devolver o item: ' || cd_material_w || ' QTD: ' || qt_material_liq_w || chr(13) ||'Quantidade de devolucao invalida!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(196045,	'CD_MATERIAL_W='||cd_material_w||';'||
								'QT_MATERIAL_LIQ_W='||qt_material_liq_w);
	end if;
	
	insert into material_atend_paciente(
		nr_sequencia,
		nr_atendimento,
 		dt_entrada_unidade,
		cd_material,
		dt_atendimento,
		cd_unidade_medida,
		qt_material,
		dt_atualizacao,
		nm_usuario,
		cd_convenio,
		cd_categoria,
		dt_prescricao,
		cd_material_prescricao,
		ie_via_aplicacao,
		vl_material,
		cd_tab_preco_material,
		dt_vigencia_tabela,
		nr_prescricao,
		nr_sequencia_prescricao,
		cd_acao,
		cd_setor_atendimento,
		qt_devolvida,
		cd_motivo_devolucao,
		nr_cirurgia,
		nr_doc_convenio,
		qt_executada,
		dt_conta,
		vl_unitario,
		cd_proced_referencia,
		nr_aih,
		ie_valor_informado,
		nr_seq_autorizacao,
		cd_material_exec,
		nr_seq_atepacu,
		cd_cgc_fornecedor,
		ie_auditoria,
		cd_local_estoque,
		nr_seq_cor_exec,
		nr_seq_aih,
		nr_seq_lote_fornec,
		nr_devolucao,
		nr_seq_item_devol,
		cd_material_convenio,
		nr_doc_interno,
		nr_seq_kit_estoque,
		nr_seq_lote_ap)
	SELECT	nr_sequencia_w,
		nr_atendimento_w,
 		dt_entrada_unidade_w,
		cd_material_w,
		dt_recebimento_w,
		cd_unidade_medida_w,
		(0 - qt_material_liq_w),
		dt_atualizacao_w,
		nm_usuario_p,
		cd_convenio,
		cd_categoria,
		dt_prescricao,
		cd_material_prescricao,
		ie_via_aplicacao,
		(qt_material_liq_w * vl_unitario * -1),
		cd_tab_preco_material,
		dt_vigencia_tabela,
		nr_prescricao_w,
		coalesce(nr_seq_prescricao_w, nr_sequencia_prescricao) ,
		2,
		cd_setor_atendimento,
		qt_material_liq_w,
		cd_motivo_devolucao_w,
		nr_cirurgia,
		nr_doc_convenio,
		0,
		dt_conta,
		vl_unitario,
		cd_proced_referencia,
		nr_aih,
		'N',
		nr_seq_autorizacao,
		cd_material_w,
		nr_seq_atepacu,
		cd_cgc_fornec_w,
		'N',
		null,
		100,
		nr_seq_aih,
		nr_seq_lote_fornec_w,
		nr_devolucao_p,
		nr_sequencia_p,
		cd_material_convenio,
		CASE WHEN ie_doc_interno_w='S' THEN nr_doc_interno_w  ELSE null END ,
		nr_kit_estoque_w,
		nr_seq_lote_dev_mat_w
    	from	material_atend_paciente
	where	nr_sequencia = nr_seq_atendimento_w;
	
	/*matheus os 76148 05/12/07 troquei nr_seq_atendimento_w por nr_sequencia_w*/

	update	material_atend_paciente
	set	cd_local_estoque = cd_local_estoque_p
	where	nr_sequencia = nr_sequencia_w;
	
	/* inserindo o numero da devolucao no registro da material_atend_paciente que deu origem
	a devolucao. esse campo somente sera verificado no processo de devoluca por lote fornecedor 
	para quando e utilizado lote unico.*/
	update	material_atend_paciente
	set	nr_devolucao = nr_devolucao_p
	where	nr_sequencia = nr_seq_atendimento_w;

/* marcus incluiu a ultima linha para resolver os casos de baixa de devolucao com
   duplo registro da chave (4 primeiros campos); */
	exception
		when others then
			begin
			flag_ok_w := 'N';
			ds_erro_w := substr(sqlerrm(SQLSTATE),1,2000);
			CALL wheb_mensagem_pck.exibir_mensagem_abort(196059,'DS_ERRO_W='||ds_erro_w);
			end;
	end;
	end;
end if;

/*   recalcular o valor do material/conta devido alteracao da quantidade */

if (nr_atendimento_w > 0) and (ie_conta_paciente_w = 'S') and (flag_ok_w = 'S')  then
     begin
     CALL atualiza_preco_material(nr_sequencia_w, nm_usuario_p);
     end;
end if;

/*   gerar movimento de estoque */

if (flag_ok_w = 'S') and (cd_local_estoque_p	> 0) and (ie_baixa_estoque_pac_w = 'S') and (ie_atualiza_estoque_w = 'S') then
	begin
	qt_material_liq_w	:= qt_material_w - coalesce(qt_material_estoque_p,0);
	if (qt_material_liq_w = 0) then
		qt_material_liq_w	:= qt_material_w;
	end if;
	if (qt_material_liq_w < 0) then /* matheus os 93253 16/06/2008 coloquei esta restricao para identificar itens negativos*/

		/*(-20011,'Erro ao devolver o item: ' || cd_material_w || ' QTD: ' || qt_material_liq_w || chr(13) || 'Quantidade de devolucao invalida!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(196045,	'CD_MATERIAL_W='||cd_material_w||';'||
								'QT_MATERIAL_LIQ_W='||qt_material_liq_w);
	end if;
	CALL gerar_consumo_paciente(	nr_atendimento_w,
				cd_material_w,
				dt_recebimento_w,
				'2',
				cd_local_estoque_p,
				qt_material_liq_w,
				cd_setor_atendimento_w,
				cd_unidade_medida_w,
				nm_usuario_p,
				'I',
				nr_prescricao_w,
				nr_seq_prescricao_w,
				cd_cgc_fornec_w,
				nr_devolucao_p,
				nr_seq_lote_fornec_w);
	end;
	end if;


if (flag_ok_w = 'S') then
	update item_devolucao_material_pac
	set	dt_recebimento		= dt_recebimento_w,
		nm_usuario_receb 		= nm_usuario_p,
		ie_tipo_baixa_estoque	= cd_tipo_baixa_p,
		cd_pessoa_fisica_receb	= cd_pessoa_fisica_p,
		qt_material_estoque		= qt_material_estoque_p,
		nm_usuario		= nm_usuario_p,
		ie_baixa			= ie_baixa_p
	where	nr_devolucao		= nr_devolucao_p
	and	nr_sequencia		= nr_sequencia_p;
	
	if (coalesce(ie_cancela_lote_w,'N') = 'S') then
		select	nr_seq_lote
		into STRICT	nr_seq_lote_w
		from	item_devolucao_material_pac
		where	nr_devolucao = nr_devolucao_p
		and	nr_sequencia = nr_sequencia_p
		group by nr_seq_lote;
		
		if (coalesce(nr_seq_lote_w,0) > 0) then
		
			select	ie_status_lote
			into STRICT	ie_status_lote_w
			from	ap_lote
			where	nr_sequencia = nr_seq_lote_w;
			
			if (coalesce(ie_status_lote_w,'A') <> 'C') then
				update	ap_lote
				set	ie_status_lote = 'C'
				where	nr_sequencia = nr_seq_lote_w;
				
				insert into ap_lote_historico(
					nr_sequencia,			dt_atualizacao,
					nm_usuario,			nr_seq_lote,
					ds_evento,			ds_log)
				values (	nextval('ap_lote_historico_seq'),		clock_timestamp(),
					nm_usuario_p,			nr_seq_lote_w,
					Wheb_mensagem_pck.get_Texto(297840),
					Wheb_mensagem_pck.get_Texto(297841));
			end if;
		end if;
	end if;
	
	if (coalesce(nr_kit_estoque_w,0) > 0) and (coalesce(nr_atendimento_w,0) > 0) then
		update	kit_estoque
		set	dt_utilizacao  = NULL,
			nm_usuario_util  = NULL,
			nr_atendimento  = NULL
		where	nr_sequencia = nr_kit_estoque_w;
	end if;
end if;

select	coalesce(max(ie_consignado),'0')
into STRICT	ie_consignado_w
from	material
where	cd_material	= cd_material_w;

if (ie_consignado_w <> '0') then
	begin		
	
	open C01;
	loop
	fetch C01 into	
		nr_ordem_compra_w,
		ie_tipo_ordem_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
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
			and	b.qt_material >= qt_material_w;
		
			if (nr_ordem_compra_w = 0) and (ie_tipo_ordem_w = 'G') and (ie_consiste_oc_aprov_w = 'S') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(196046,'CD_MATERIAL_W='||cd_material_w);
				/*(-20011, 'Nao e possivel devolver o item  ' || cd_material_w || ', pois nao possui nenhuma ' ||'ordem de compra relacionada a este atendimento que  nao esteja aprovada. ' ||'Verifique o parametro [74]. Para realizar essa acao, deve ser estornado a aprovacao ' ||'de alguma ordem  relacionada a este atendimento');*/

			end if;		
			
			if (nr_ordem_compra_w > 0) and (nr_item_oci_w > 0) then

				if (ie_consiste_oc_aprov_w = 'S') and (qt_material_w > 0) then
				
					select	dt_aprovacao
					into STRICT	dt_aprovacao_w
					from	ordem_compra
					where	nr_ordem_compra = nr_ordem_compra_w;
						
					if (dt_aprovacao_w IS NOT NULL AND dt_aprovacao_w::text <> '') and (ie_tipo_ordem_w = 'G') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(196046,'CD_MATERIAL_W='||cd_material_w);
						/*(-20011,	'Nao e possivel devolver o item  ' || cd_material_w || ', pois nao possui nenhuma ' ||
								'ordem de compra relacionada a este atendimento que  nao esteja aprovada. ' ||
								'Verifique o parametro [74]. Para realizar essa acao, deve ser estornado a aprovacao ' ||
								'de alguma ordem  relacionada a este atendimento');*/
					end if;
				end if;
				
				select	qt_material
				into STRICT	qt_material_oc_w
				from	ordem_compra_item
				where	nr_ordem_compra	= nr_ordem_compra_w
				and	nr_item_oci	= nr_item_oci_w;
				
				if	((qt_material_oc_w - qt_material_w) = 0) and (coalesce(ie_exclui_item_oc_w,'N') = 'S') then
					begin
					
					delete	FROM ordem_compra_item
					where	nr_ordem_compra = nr_ordem_compra_w
					and	nr_item_oci = nr_item_oci_w;
					
					select	count(*)
					into STRICT	qt_existe_w
					from	ordem_compra_item
					where	nr_ordem_compra = nr_ordem_compra_w;
					
					if (qt_existe_w = 0) then
						begin
						
						delete FROM ordem_compra
						where nr_ordem_compra = nr_ordem_compra_w;
						
						exception
						when others then
							nr_ordem_compra_w := nr_ordem_compra_w;
						end;
					end if;				
					end;
				else
					begin
					
					update	ordem_compra_item
					set	qt_material = qt_material - qt_material_w,
						vl_total_item = round(((qt_material - qt_material_w) * vl_unitario_material),4)
					where	nr_ordem_compra	= nr_ordem_compra_w
					and	nr_item_oci = nr_item_oci_w;

					update	ordem_compra_item_entrega
					set	qt_prevista_entrega = qt_prevista_entrega - qt_material_w
					where	nr_ordem_compra	= nr_ordem_compra_w
					and	nr_item_oci = nr_item_oci_w
					and	dt_prevista_entrega =
						(SELECT max(dt_prevista_entrega)
						from	ordem_compra_item_entrega
						where	nr_ordem_compra	= nr_ordem_compra_w
						and	nr_item_oci = nr_item_oci_w
						and	coalesce(dt_cancelamento::text, '') = '');
						
					end;
				end if;
				
			elsif (ie_tipo_ordem_w = 'G') then
				
				select	nextval('comunic_interna_seq')
				into STRICT	nr_sequencia_w
				;
				select	obter_classif_comunic('F')
				into STRICT	nr_seq_classif_w
				;

				select	max(b.nm_usuario)
				into STRICT	nm_usuario_ww
				from	usuario b,
					parametro_compras a,
					atendimento_paciente t
				where	a.cd_estabelecimento	= t.cd_estabelecimento
				and	a.cd_comprador_padrao	= b.cd_pessoa_fisica
				and	t.nr_atendimento	= nr_atendimento_w;

				select	cd_operacao_devol_paciente
				into STRICT	cd_operacao_devol_paciente_w
				from	parametro_estoque
				where	cd_estabelecimento = cd_estabelecimento_w;
				
				SELECT * FROM obter_regra_ordem_consignado(
					cd_estabelecimento_w, cd_local_estoque_p, cd_operacao_devol_paciente_w, cd_material_w, cd_cgc_fornec_w, cd_convenio_w, cd_setor_regra_oc_consig_w, ie_gera_ordem_w, cd_local_entrega_w, cd_centro_custo_w, pr_desconto_w, nm_usuario_dest_w, cd_perfil_comunic_w, cd_pessoa_solicitante_w, ie_gera_oc_reposicao_w) INTO STRICT ie_gera_ordem_w, cd_local_entrega_w, cd_centro_custo_w, pr_desconto_w, nm_usuario_dest_w, cd_perfil_comunic_w, cd_pessoa_solicitante_w, ie_gera_oc_reposicao_w;
					
				if	((ie_gera_ordem_w = 'C') or (ie_gera_ordem_w = 'A') or (ie_gera_ordem_w = 'E') or (ie_gera_ordem_w = 'O')) and (nm_usuario_dest_w IS NOT NULL AND nm_usuario_dest_w::text <> '') then
					nm_usuario_ww	:= nm_usuario_ww || ',' || nm_usuario_dest_w;
				end if;
				
				if (coalesce(cd_perfil_comunic_w,0) > 0) then
					cd_perfil_comunic_w := substr(cd_perfil_comunic_w || ',',1,10);
				end if;
				
				ds_comunicacao_w :=	WHEB_MENSAGEM_PCK.get_texto(297845,
								'CD_MATERIAL_W='||CD_MATERIAL_W||
								';DS_MATERIAL_W='||ds_material_w||
								';NR_ATENDIMENTO_W='||NR_ATENDIMENTO_W||
								';NR_PRESCRICAO_W='||NR_PRESCRICAO_W);
								
				/*Material: #@CD_MATERIAL_W#@ - #@DS_MATERIAL_W#@
				Quantidade: #@QT_MATERIAL_W#@
				Atendimento: #@NR_ATENDIMENTO_W#@
				Prescricao: #@NR_PRESCRICAO_W#@*/
				
				insert into comunic_interna(
					dt_comunicado,
					ds_titulo,
					ds_comunicado,
					nm_usuario,
					dt_atualizacao,
					ie_geral,
					nm_usuario_destino,
					nr_sequencia,
					ie_gerencial,
					nr_seq_classif,
					dt_liberacao,
					ds_perfil_adicional)
				values (	clock_timestamp() + interval '1 days'/86400,
					Wheb_mensagem_pck.get_Texto(297846),
					ds_comunicacao_w,
					Wheb_mensagem_pck.get_Texto(297847),
					clock_timestamp(),
					'N',
					nm_usuario_ww || ',',
					nr_sequencia_w,
					'N',
					nr_seq_classif_w,
					clock_timestamp(),
					cd_perfil_comunic_w);
				
				lista_usuario_w	:= substr(nm_usuario_ww,1,2000);
						
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
					CALL Enviar_Email(Wheb_mensagem_pck.get_Texto(297846),ds_comunicacao_w, null, ds_lista_email_usuario_w, nm_usuario_p,'M');
					exception
					when others then
						null;
					end;
				end if;
			end if;
		end if;
		end;
	end loop;
	close C01;
	end;
end if;

if (flag_ok_w = 'S') then
	commit;
else
	rollback;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_devolucao_med ( nr_devolucao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_tipo_baixa_p bigint, qt_material_estoque_p bigint, cd_pessoa_fisica_p text, cd_local_estoque_p bigint, ie_baixa_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
