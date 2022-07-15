-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE husf_gerar_razao_med_ctlado ( dt_inicial_p timestamp, dt_final_p timestamp, dt_movto_inic_p timestamp, dt_movto_fim_p timestamp, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, ie_gerar_saldo_p text, ie_imprime_local_p text, ie_imprime_endereco_p text, ie_imprime_setor_p text, ie_imprime_lote_p text, ie_imprime_movimento_p text, ie_analitico_p text, ie_desconsidera_transfer_p text, nm_usuario_p text, cd_local_estoque_p text, cd_medicamento_p bigint, ie_imprime_centro_p text, cd_centro_custo_p text) AS $body$
DECLARE

nr_sequencia_w			bigint;
nr_documento_w			varchar(22);
nr_sequencia_item_docto_w	numeric(22);
nr_sequencia_docto_w		integer;
nr_crm_w			varchar(80);
cd_medico_w			varchar(10);
cd_material_w			numeric(22);
cd_material_ww			numeric(22) := 0;
dt_movimento_w			timestamp;
dt_movimento_ant_w		timestamp;
cd_classificacao_w		varchar(80);
cd_dcb_w			varchar(80);
ds_dcb_w			varchar(80);
ds_local_estoque_w		varchar(80);
ie_tipo_w			varchar(10);
ds_observacao_w			varchar(255);
qt_entrada_w			double precision;
qt_saida_w			double precision;
qt_perda_w			double precision;
qt_transf_w			double precision;
ie_primeira_vez_w		varchar(1) := 'N';
qt_estoque_w			double precision;
qt_saldo_w			double precision;
ds_historico_w			varchar(250);
ie_origem_documento_w		varchar(25);
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
dt_saldo_w			timestamp;
ie_entrada_saida_w		varchar(10);
ie_tipo_requisicao_w		varchar(30);
nr_coluna_w			bigint;
dt_movto_inic_w			timestamp;
dt_movto_fim_w			timestamp;
qt_nota_estorno_w		integer;
ds_situacao_nota_w		varchar(50);
dt_inicio_compara_w		timestamp;
dt_anterior_w			timestamp;
dt_saldo_dia_w			timestamp;
qt_acumulado_dia_w		double precision := 0;
dt_validade_w			timestamp;
cd_lote_w			varchar(20);
cd_operacao_estoque_w		smallint;
ie_analitico_w			varchar(1);
nr_receita_w			bigint;
cd_centro_custo_w		integer;
ds_centro_custo_w		varchar(80);
cd_local_estoque_destino_w	integer;
cd_local_estoque_w		integer;
dt_fim_movto_w			timestamp;
dt_processo_w			timestamp;
nr_movimento_estoque_w		bigint;
dt_atualizacao_w		timestamp;
cd_acao_w varchar(1);

C00 CURSOR FOR
	SELECT	distinct
		m.cd_classificacao,
		c.cd_dcb,
		c.ds_dcb,
		a.cd_material
	from	dcb_medic_controlado c,
		medic_controlado m,
		saldo_estoque a
	where	m.cd_material		= a.cd_material
	and	m.nr_seq_dcb		= c.nr_sequencia
	and	a.dt_mesano_referencia between  trunc(dt_inicio_w,'month') and dt_fim_w
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	((coalesce(cd_medicamento_p::text, '') = '') or (cd_medicamento_p = a.cd_material))
	order by	c.ds_dcb;
C01 CURSOR FOR
	SELECT	/*+ index(a MOVESTO_I4) */		'B' ie_tipo,
		trunc(a.dt_processo) dt_processo,
		a.nr_movimento_estoque,
		a.dt_atualizacao,
		trunc(a.dt_movimento_estoque) dt_movimento_estoque,
		0 cd_local_estoque,
		'' local_estoque,
		sum(CASE WHEN a.cd_acao='1' THEN  qt_estoque  ELSE qt_estoque * -1 END ) qt_estoque,
		'Saídas' ds_historico,
		'',
		'',
		'0',
		0,
		0,
		'',
		'',
		sum(obter_qt_coluna_controlado(1, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque)) qt_entrada,
		sum(obter_qt_coluna_controlado(2, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque)) qt_saida,
		sum(obter_qt_coluna_controlado(3, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque)) qt_perda,
		sum(obter_qt_coluna_controlado(4, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque)) qt_transf,
		trunc(a.dt_validade) dt_validade,
		a.cd_lote_fabricacao,
		a.cd_operacao_estoque,
		0,
		0	cd_centro_custo,
		0 cd_local_estoque_destino,
		max(a.cd_acao)
	from	operacao_estoque b,
		movimento_estoque a
	where	a.dt_mesano_referencia between dt_inicio_w and dt_fim_w
	and	a.cd_estabelecimento		= cd_estabelecimento_p
	and	a.cd_material_estoque	= cd_material_w
	and	a.cd_operacao_estoque	= b.cd_operacao_estoque
	and (coalesce(ie_desconsidera_transfer_p,'N') = 'N' or
			ie_desconsidera_transfer_p = 'S'
			and b.ie_tipo_requisicao <> '2')
	and	b.ie_entrada_saida		= 'S'
	and	(ie_analitico_w = 'N' AND b.ie_tipo_requisicao <> 3)
	and (a.cd_setor_atendimento = cd_setor_atendimento_p or coalesce(cd_setor_atendimento_p,0) = 0)
	and	((coalesce(cd_local_estoque_p::text, '') = '') or (obter_se_contido(a.cd_local_estoque, cd_local_estoque_p) = 'S'))
	and	((coalesce(cd_centro_custo_p::text, '') = '') or (obter_se_contido(a.cd_centro_custo, cd_centro_custo_p) = 'S'))
	and	((coalesce(dt_movto_inic_p::text, '') = '') or (a.dt_movimento_estoque between dt_movto_inic_w and dt_movto_fim_w))
	and	(a.dt_processo IS NOT NULL AND a.dt_processo::text <> '')
	group by	trunc(a.dt_processo), trunc(a.dt_movimento_estoque), a.cd_operacao_estoque, trunc(a.dt_validade), a.cd_lote_fabricacao, a.nr_movimento_estoque, a.dt_atualizacao
	
union all

	SELECT	/*+ index(a MOVESTO_I4) */		'B' ie_tipo,
		a.dt_processo,
		a.nr_movimento_estoque,
		a.dt_atualizacao,
		a.dt_movimento_estoque,
		a.cd_local_estoque,
		substr(obter_desc_local_estoque(a.cd_local_estoque),1,100),
		CASE WHEN a.cd_acao='1' THEN  qt_estoque  ELSE qt_estoque * -1 END  qt_estoque,
		substr(obter_hist_medic_controlado(a.nr_movimento_estoque,
				coalesce(ie_imprime_endereco_p,'N'), coalesce(ie_imprime_setor_p,'N'),coalesce(ie_imprime_movimento_p,'N')),1,250) ds_historico,
		b.ie_entrada_saida,
		b.ie_tipo_requisicao,
		to_char(a.nr_documento),
		a.nr_sequencia_item_docto,
		a.nr_sequencia_documento,
		a.ie_origem_documento,
		b.ie_tipo_requisicao,
		obter_qt_coluna_controlado(1, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque) qt_entrada,
		obter_qt_coluna_controlado(2, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque) qt_saida,
		obter_qt_coluna_controlado(3, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque) qt_perda,
		obter_qt_coluna_controlado(4, b.ie_entrada_saida, b.ie_tipo_requisicao,
			b.ie_coluna_controlado, a.cd_acao, a.qt_estoque) qt_transf,
		trunc(a.dt_validade) dt_validade,
		a.cd_lote_fabricacao,
		b.cd_operacao_estoque,
		a.nr_receita,
		a.cd_centro_custo,
		a.cd_local_estoque_destino,
		a.cd_acao
	from	operacao_estoque b,
		movimento_estoque a
	where	a.dt_mesano_referencia between  dt_inicio_w and dt_fim_w
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.cd_material_estoque	= cd_material_w
	and	a.cd_operacao_estoque	= b.cd_operacao_estoque
	and (coalesce(ie_desconsidera_transfer_p,'N') = 'N' or
			ie_desconsidera_transfer_p = 'S'
			and b.ie_tipo_requisicao <> '2')
	and	((ie_analitico_w = 'S') or (b.ie_tipo_requisicao = 3) or (b.ie_entrada_saida = 'E'))
	and (a.cd_setor_atendimento = cd_setor_atendimento_p or coalesce(cd_setor_atendimento_p,0) = 0)
	and	((coalesce(cd_local_estoque_p::text, '') = '') or (obter_se_contido(a.cd_local_estoque, cd_local_estoque_p) = 'S'))
	and	((coalesce(cd_centro_custo_p::text, '') = '') or (obter_se_contido(a.cd_centro_custo, cd_centro_custo_p) = 'S'))
	and	((coalesce(dt_movto_inic_p::text, '') = '') or (a.dt_movimento_estoque between dt_movto_inic_w and dt_movto_fim_w))
	and	(a.dt_processo IS NOT NULL AND a.dt_processo::text <> '')
	
union all

	select distinct
		'A',
		CASE WHEN coalesce(dt_movto_inic_p::text, '') = '' THEN  last_Day(dt_saldo_w)  ELSE trunc(dt_movto_inic_w,'dd')-1 END  dt_processo,
		0,
		CASE WHEN coalesce(dt_movto_inic_p::text, '') = '' THEN  last_Day(dt_saldo_w)  ELSE trunc(dt_movto_inic_w,'dd')-1 END  dt_atualizacao,
		CASE WHEN coalesce(dt_movto_inic_p::text, '') = '' THEN  last_Day(dt_saldo_w)  ELSE trunc(dt_movto_inic_w,'dd')-1 END  dt_movimento_estoque,
		0,
		'',
		0,
		'Saldo anterior',
		'',
		'',
		'0',
		0,
		0,
		'',
		'',
		0,
		0,
		0,
		0,
		to_date(null),
		'',
		0,
		0,
		0 cd_centro_custo,
		0,
		'0'
	from	material a
	where	coalesce(ie_gerar_saldo_p,'S') = 'S'
	and	cd_material = cd_material_w
	order by dt_processo,dt_movimento_estoque, 1, nr_movimento_estoque, dt_atualizacao;

BEGIN
if (dt_movto_fim_p IS NOT NULL AND dt_movto_fim_p::text <> '') then
	dt_fim_movto_w := fim_dia(fim_mes(dt_movto_fim_p));
end if;
ie_analitico_w	:= coalesce(ie_analitico_p, 'S');
dt_inicio_w	:= trunc(dt_inicial_p, 'dd');
dt_fim_w		:= trunc(dt_final_p, 'dd') + 86399 / 86400;
dt_saldo_w	:= add_months(dt_inicio_w, -1);
dt_movto_inic_w	:= trunc(dt_movto_inic_p, 'dd');
dt_movto_fim_w	:= trunc(dt_movto_fim_p, 'dd') + 86399 / 86400;
/*Para truncar somente se nao passou param com hora*/

if (dt_movto_inic_p IS NOT NULL AND dt_movto_inic_p::text <> '') and (to_char(dt_movto_inic_p,'hh24:mi:ss') <> '00:00:00') then
	dt_movto_inic_w	:= dt_movto_inic_p;
	dt_movto_fim_w	:= dt_movto_fim_p;
end if;

Delete FROM W_Razao_Medic_Controlado;
commit;
OPEN C00;
LOOP
FETCH C00 into
	cd_classificacao_w,
	cd_dcb_w,
	ds_dcb_w,
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	select	sum(qt_estoque)
	into STRICT	qt_saldo_w
	from	saldo_Estoque
	where	cd_estabelecimento		= cd_estabelecimento_p
	and	cd_material 		= cd_material_w
	and	dt_mesano_referencia 	= dt_saldo_w
	and	((coalesce(cd_local_estoque_p::text, '') = '') or (obter_se_contido(cd_local_estoque, cd_local_estoque_p) = 'S'));
	ie_primeira_vez_w	:= 'S';
	OPEN C01;
	LOOP
	FETCH C01 into
		ie_tipo_w,
		dt_processo_w,
		nr_movimento_estoque_w,
		dt_atualizacao_w,
		dt_movimento_w,
		cd_local_estoque_w,
		ds_local_estoque_w,
		qt_estoque_w,
		ds_historico_w,
		ie_entrada_saida_w,
		ie_tipo_requisicao_w,
		nr_documento_w,
		nr_sequencia_item_docto_W,
		nr_sequencia_docto_w,
		ie_origem_documento_w,
		ie_tipo_requisicao_w,
		qt_entrada_w,
		qt_saida_w,
		qt_perda_w,
		qt_transf_w,
		dt_validade_w,
		cd_lote_w,
		cd_operacao_estoque_w,
		nr_receita_w,
		cd_centro_custo_w,
		cd_local_estoque_destino_w,
		cd_acao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		select nextval('w_razao_medic_controlado_seq')
		into STRICT	nr_sequencia_w
		;
		nr_crm_w			:= '';
		ds_observacao_w			:= '';
		if (ie_origem_documento_w	= '1') then
			begin
			select	substr(coalesce(max(ds_observacao),''),1,255)
			into STRICT	ds_observacao_w
			from	nota_fiscal_item
			where	nr_nota_fiscal	= nr_documento_w
			and	nr_item_nf	= nr_sequencia_item_docto_w
			and	nr_sequencia_nf	= nr_sequencia_docto_w;
			select	substr(obter_valor_dominio(1056, coalesce(max(ie_situacao),'')),1,20)
			into STRICT	ds_situacao_nota_w
			from	nota_fiscal
			where	nr_nota_fiscal	= nr_documento_w
			and	nr_sequencia_nf	= nr_sequencia_docto_w;
			ds_observacao_w	:= substr(ds_observacao_w || ' ' || ds_situacao_nota_w,1,255);
			end;
		elsif (ie_origem_documento_w	= '2') then
			select	substr(coalesce(max(b.ds_observacao),max(a.ds_observacao)),1,255)
			into STRICT	ds_observacao_w
			from	item_requisicao_material b,
				requisicao_material a
			where	a.nr_requisicao = b.nr_requisicao
			and	a.nr_requisicao	= nr_documento_w
			and	b.nr_sequencia	= nr_sequencia_item_docto_w;
		elsif (ie_origem_documento_w	= '3') and (coalesce(nr_documento_w,'0') <> '0') then
			begin
			if (coalesce(nr_sequencia_item_docto_w::text, '') = '') or (nr_sequencia_item_docto_w	= 999) then
				begin
				select	coalesce(max(cd_medico_resp), ' ')
				into STRICT	cd_medico_w
				from	atendimento_paciente
				where	nr_atendimento	= nr_documento_w;
				end;
			else
				begin
				select	coalesce(max(cd_medico), ' ')
				into STRICT	cd_medico_w
				from	prescr_medica
				where	nr_prescricao	= nr_documento_w;
				end;
			end if;

			if (cd_medico_w <> ' ') then
				select	substr(obter_crm_medico(cd_medico_w),1,20)
				into STRICT	nr_Crm_w
				;
			end if;
			end;
		elsif (ie_origem_documento_w	= '5') then
			select	substr(coalesce(max(ds_observacao),''),1,255)
			into STRICT	ds_observacao_w
			from  	movimento_estoque
			where	nr_documento = nr_documento_w
			and	cd_material = cd_material_w;
		end if;
		if (coalesce(dt_movto_inic_p::text, '') = '') then
			qt_saldo_w		:= coalesce(qt_saldo_w,0) +
						qt_entrada_w -
						qt_saida_w -
						qt_perda_w -
						qt_transf_w;
		elsif (dt_movto_inic_p IS NOT NULL AND dt_movto_inic_p::text <> '') then
			begin
			if (trunc(dt_movimento_w,'dd') = trunc(dt_movimento_ant_w,'dd')) then
				qt_acumulado_dia_w	:= qt_acumulado_dia_w +
							qt_entrada_w - qt_saida_w - qt_perda_w - qt_transf_w;
			else
				qt_acumulado_dia_w	:= 0;
			end if;
			if (ie_primeira_vez_w = 'S') then
				ie_primeira_vez_w := 'N';
				qt_saldo_w	:= Obter_saldo_Diario_medic(
							dt_movto_inic_p - 1,
							cd_estabelecimento_p,
							cd_local_estoque_p,
							cd_material_w);
			else
				qt_saldo_w		:= coalesce(qt_saldo_w,0) +
							qt_entrada_w -
							qt_saida_w -
							qt_perda_w -
							qt_transf_w;
			end if;
			dt_movimento_ant_w	:= dt_movimento_w;
			end;
		end if;
		if (ie_tipo_w <> 'A') then
			ds_historico_w	:= substr(' (' || nr_documento_w || ') ' || ds_historico_w,1,250);
			if (ie_imprime_local_p = 'S') then
				ds_historico_w	:= substr(ds_historico_w || ' Local: ' || ds_local_estoque_w,1,250);
			elsif (ie_imprime_lote_p = 'S') and
				((cd_lote_w IS NOT NULL AND cd_lote_w::text <> '') or (dt_validade_w IS NOT NULL AND dt_validade_w::text <> '')) then
				ds_historico_w	:= substr(ds_historico_w || ' Lote: ' || cd_lote_w || ' - ' || 'Validade: ' || dt_validade_w,1,250);
			end if;
			if (ie_imprime_centro_p = 'S') and (cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') then
				select	substr(obter_desc_centro_custo(cd_centro_custo_w),1,80)
				into STRICT	ds_centro_custo_w
				;
				ds_historico_w	:= substr(ds_historico_w || ' Centro custo: ' || ds_centro_custo_w,1,250);
				end if;
		end if;

		if (cd_acao_w = '2') then
		   ds_historico_w	:= substr('ESTORNO - ' || ds_historico_w,1,250);
		end if;

		insert into w_Razao_Medic_Controlado(
			ie_tipo,
			cd_estabelecimento,
			nr_sequencia,
			cd_material,
			cd_classificacao,
			cd_dcb,
			ds_dcb,
			dt_movimento,
			ds_historico,
			qt_entrada,
			qt_saida,
			qt_perda,
			qt_transf,
			qt_saldo,
			nr_crm,
			ds_observacao,
			cd_operacao_estoque,
			nr_receita,
			cd_medico_presc,
			cd_local_estoque,
			cd_local_estoque_destino,
			dt_processo)
		values (	ie_tipo_w,
			cd_estabelecimento_p,
			nr_sequencia_w,
			cd_material_w,
			cd_classificacao_w,
			cd_dcb_w,
			ds_dcb_w,
			dt_movimento_w,
			ds_historico_w,
			qt_entrada_w,
			qt_saida_w,
			qt_perda_w,
			qt_transf_w,
			qt_saldo_w,
			nr_crm_w,
			coalesce(ds_observacao_w,''),
			cd_operacao_estoque_w,
			nr_receita_w,
			cd_medico_w,
			cd_local_estoque_w,
			cd_local_estoque_destino_w,
			dt_processo_w);
	END LOOP;
	CLOSE C01;
END LOOP;
CLOSE C00;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE husf_gerar_razao_med_ctlado ( dt_inicial_p timestamp, dt_final_p timestamp, dt_movto_inic_p timestamp, dt_movto_fim_p timestamp, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, ie_gerar_saldo_p text, ie_imprime_local_p text, ie_imprime_endereco_p text, ie_imprime_setor_p text, ie_imprime_lote_p text, ie_imprime_movimento_p text, ie_analitico_p text, ie_desconsidera_transfer_p text, nm_usuario_p text, cd_local_estoque_p text, cd_medicamento_p bigint, ie_imprime_centro_p text, cd_centro_custo_p text) FROM PUBLIC;

