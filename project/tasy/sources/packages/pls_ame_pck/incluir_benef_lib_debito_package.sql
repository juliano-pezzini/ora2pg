-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ame_pck.incluir_benef_lib_debito ( nr_seq_regra_ger_arq_p bigint, nr_seq_segurado_p bigint, nr_seq_lote_rem_valor_p bigint) AS $body$
DECLARE


nr_seq_lote_rem_valor_det_w		pls_ame_lote_rem_valor_det.nr_sequencia%type;
cd_cobranca_w				pls_ame_regra_conv_rubrica.cd_cobranca%type;
ds_cobranca_w				pls_ame_regra_conv_rubrica.ds_cobranca%type;
current_setting('pls_ame_pck.nr_seq_regra_conv_rubrica_w')::pls_ame_regra_conv_rubrica.nr_sequencia%type		pls_ame_regra_conv_rubrica.nr_sequencia%type;
current_setting('pls_ame_pck.nr_seq_plano_w')::pls_plano.nr_sequencia%type				pls_plano.nr_sequencia%type;
current_setting('pls_ame_pck.ie_situacao_trabalhista_w')::pls_segurado.ie_situacao_trabalhista%type		pls_segurado.ie_situacao_trabalhista%type;
current_setting('pls_ame_pck.nr_seq_parentesco_w')::bigint			pls_segurado.nr_seq_parentesco%type;
current_setting('pls_ame_pck.ie_tipo_parentesco_w')::bigint			pls_segurado.ie_tipo_parentesco%type;
current_setting('pls_ame_pck.ie_titular_w')::varchar(1)				varchar(10);
qt_dias_pro_rata_dia_w			bigint;
current_setting('pls_ame_pck.qt_registros_w')::bigint				bigint;
cd_dependente_w				pls_ame_regra_conv_depen.cd_dependente%type;
current_setting('pls_ame_pck.nr_seq_ame_empresa_w')::pls_ame_empresa.nr_sequencia%type			pls_ame_lote_rem_destino.nr_seq_ame_empresa%type;
current_setting('pls_ame_pck.nr_seq_ame_subsidiaria_w')::pls_ame_subsidiaria.nr_sequencia%type		pls_ame_lote_rem_destino.nr_seq_ame_subsidiaria%type;
dt_rescisao_lib_deb_w			pls_ame_lote_rem_valor.dt_rescisao_lib_deb%type;
dt_contratacao_w			timestamp;
dt_atual_trunc_w			timestamp := trunc(clock_timestamp(),'dd');
current_setting('pls_ame_pck.dt_rescisao_w')::timestamp				timestamp;
current_setting('pls_ame_pck.vl_item_w')::double				pls_ame_lote_rem_valor_det.vl_detalhe%type;
qt_dias_w				bigint;
tx_proporcional_rescisao_w		double precision := 0;
current_setting('pls_ame_pck.nr_seq_motivo_cancelamento_w')::pls_motivo_cancelamento.nr_sequencia%type		pls_segurado.nr_seq_motivo_cancelamento%type;
current_setting('pls_ame_pck.nr_seq_causa_rescisao_w')::pls_segurado.nr_seq_causa_rescisao%type			pls_segurado.nr_seq_causa_rescisao%type;
current_setting('pls_ame_pck.nr_seq_regra_ger_item_w')::pls_ame_regra_ger_item.nr_sequencia%type			bigint;
vl_total_aprop_w			double precision;
vl_baixa_centro_aprop_w			double precision;
current_setting('pls_ame_pck.cd_operadora_empresa_w')::pls_contrato.cd_operadora_empresa%type			pls_contrato.cd_operadora_empresa%type;
current_setting('pls_ame_pck.ie_titularidade_w')::varchar(1)			varchar(1);
current_setting('pls_ame_pck.nr_seq_tipo_prestador_w')::pls_prestador.nr_seq_tipo_prestador%type     		pls_prestador.nr_seq_tipo_prestador%type;

current_setting('pls_ame_pck.c01')::CURSOR( CURSOR FOR
	SELECT	ie_tipo_item,
		sum(vl_item) vl_item,
		nr_seq_conta,
		nr_seq_segurado_preco,
		dt_rescisao,
		nr_seq_prestador
	from	table(pls_ame_pck.imprimir_benef_lib_debito()) a
	where	a.nr_seq_segurado	= nr_seq_segurado_p
	group by ie_tipo_item, nr_seq_conta,nr_seq_segurado_preco, dt_rescisao, nr_seq_prestador;

current_setting('pls_ame_pck.c02')::CURSOR( CURSOR(	ie_tipo_item_pc			pls_ame_regra_conv_rubrica.ie_tipo_item_mens%type,
		nr_seq_tipo_prestador_pc	pls_prestador.nr_seq_tipo_prestador%type,
		nr_seq_prestador_pc		pls_prestador.nr_sequencia%type,	
		nr_seq_parentesco_pc		bigint) FOR
	SELECT	nr_sequencia
	from	pls_ame_regra_conv_rubrica
	where	nr_seq_ame_empresa	= current_setting('pls_ame_pck.nr_seq_ame_empresa_w')::pls_ame_empresa.nr_sequencia%type
	and (coalesce(nr_seq_ame_subsidiaria::text, '') = '' or nr_seq_ame_subsidiaria = current_setting('pls_ame_pck.nr_seq_ame_subsidiaria_w')::pls_ame_subsidiaria.nr_sequencia%type)
	and (coalesce(nr_seq_produto::text, '') = '' or nr_seq_produto = current_setting('pls_ame_pck.nr_seq_plano_w')::pls_plano.nr_sequencia%type)
	and	((coalesce(ie_situacao_trabalhista::text, '') = '') or (ie_situacao_trabalhista = current_setting('pls_ame_pck.ie_situacao_trabalhista_w')::pls_segurado.ie_situacao_trabalhista%type))
	and	((coalesce(ie_tipo_parentesco::text, '') = '') or (ie_tipo_parentesco = current_setting('pls_ame_pck.ie_tipo_parentesco_w')::bigint))
	and (coalesce(ie_tipo_item_mens::text, '') = '' or ie_tipo_item_mens = ie_tipo_item_pc)
	and (coalesce(nr_seq_motivo_cancelamento::text, '') = '' or nr_seq_motivo_cancelamento = current_setting('pls_ame_pck.nr_seq_motivo_cancelamento_w')::pls_motivo_cancelamento.nr_sequencia%type)
	and	((coalesce(nr_seq_causa_rescisao::text, '') = '') or (nr_seq_causa_rescisao = current_setting('pls_ame_pck.nr_seq_causa_rescisao_w')::pls_segurado.nr_seq_causa_rescisao%type))
	and	((coalesce(ie_titularidade, 'A') = 'A') or (ie_titularidade = current_setting('pls_ame_pck.ie_titularidade_w')::varchar(1)))
	and	((coalesce(cd_operadora_empresa::text, '') = '') or (cd_operadora_empresa = current_setting('pls_ame_pck.cd_operadora_empresa_w')::pls_contrato.cd_operadora_empresa%type))
	and (coalesce(nr_seq_tipo_acomodacao::text, '') = '' or nr_seq_tipo_acomodacao in (	SELECT	x.nr_sequencia
										from	pls_tipo_acomodacao	x,
											pls_plano_acomodacao	y
										where	x.nr_sequencia	= y.nr_seq_tipo_acomodacao
										and	y.nr_seq_plano	= current_setting('pls_ame_pck.nr_seq_plano_w')::pls_plano.nr_sequencia%type))
	and	((coalesce(ie_situacao_benef, 'T') = 'A' and (current_setting('pls_ame_pck.dt_rescisao_w')::timestamp > dt_atual_trunc_w or current_setting('pls_ame_pck.dt_rescisao_w')::coalesce(timestamp::text, '') = '')) or
		((coalesce(ie_situacao_benef, 'T') = 'I' and current_setting('pls_ame_pck.dt_rescisao_w')::timestamp <= dt_atual_trunc_w) or (coalesce(ie_situacao_benef, 'T') = 'T')))
	and  	((coalesce(nr_seq_prestador::text, '') = '') or (nr_seq_prestador = nr_seq_prestador_pc))
	and  	((coalesce(nr_seq_tipo_prestador::text, '') = '') or (nr_seq_tipo_prestador = nr_seq_tipo_prestador_pc))
	and  	((coalesce(nr_seq_parentesco::text, '') = '') or (nr_seq_parentesco = nr_seq_parentesco_pc))	
	and	coalesce(nr_seq_tipo_lanc::text, '') = ''
	
	order by
		coalesce(ie_tipo_parentesco,' '),
		coalesce(nr_seq_ame_subsidiaria,0),
		coalesce(nr_seq_produto,0),
		coalesce(ie_situacao_trabalhista,' '),
		coalesce(ie_tipo_item_mens,' '),
		coalesce(nr_seq_tipo_acomodacao,0),
		coalesce(nr_seq_causa_rescisao,0),
		coalesce(nr_seq_motivo_cancelamento,0),
		coalesce(cd_operadora_empresa, 0),
		coalesce(ie_titularidade, ' '),
		CASE WHEN ie_situacao_benef='T' THEN  ' '  ELSE coalesce(ie_situacao_benef, ' ') END ,		
		coalesce(nr_seq_prestador, 0),
		coalesce(nr_seq_tipo_prestador, 0),
		coalesce(nr_seq_parentesco, 0);

BEGIN

select	x.nr_seq_ame_empresa,
	x.nr_seq_ame_subsidiaria,
	z.dt_rescisao_lib_deb
into STRICT	current_setting('pls_ame_pck.nr_seq_ame_empresa_w')::pls_ame_empresa.nr_sequencia%type,
	current_setting('pls_ame_pck.nr_seq_ame_subsidiaria_w')::pls_ame_subsidiaria.nr_sequencia%type,
	dt_rescisao_lib_deb_w
from	pls_ame_lote_rem_destino	x,
	pls_ame_lote_rem_arquivo	y,
	pls_ame_lote_rem_valor		z
where	x.nr_sequencia	= y.nr_seq_lote_rem_dest
and	y.nr_sequencia	= z.nr_seq_lote_rem_arq
and	z.nr_sequencia	= nr_seq_lote_rem_valor_p;

select	x.nr_sequencia,
	y.ie_situacao_trabalhista,
	y.ie_tipo_parentesco,
	y.nr_seq_parentesco,
	(CASE WHEN (y.nr_seq_titular IS NOT NULL AND y.nr_seq_titular::text <> '') THEN 'N' ELSE 'S' END),
	y.dt_contratacao,
	trunc(dt_rescisao, 'dd'),
	y.nr_seq_motivo_cancelamento,
	y.nr_seq_causa_rescisao,
	(select a.cd_operadora_empresa
	from	pls_contrato a
	where	a.nr_sequencia = y.nr_seq_contrato) cd_operadora_empresa,
	CASE WHEN coalesce(y.nr_seq_titular::text, '') = '' THEN  'T'  ELSE 'D' END  ie_titularidade
into STRICT	current_setting('pls_ame_pck.nr_seq_plano_w')::pls_plano.nr_sequencia%type,
	current_setting('pls_ame_pck.ie_situacao_trabalhista_w')::pls_segurado.ie_situacao_trabalhista%type,
	current_setting('pls_ame_pck.ie_tipo_parentesco_w')::bigint,
	current_setting('pls_ame_pck.nr_seq_parentesco_w')::bigint,
	current_setting('pls_ame_pck.ie_titular_w')::varchar(1),
	dt_contratacao_w,
	current_setting('pls_ame_pck.dt_rescisao_w')::timestamp,
	current_setting('pls_ame_pck.nr_seq_motivo_cancelamento_w')::pls_motivo_cancelamento.nr_sequencia%type,
	current_setting('pls_ame_pck.nr_seq_causa_rescisao_w')::pls_segurado.nr_seq_causa_rescisao%type,
	current_setting('pls_ame_pck.cd_operadora_empresa_w')::pls_contrato.cd_operadora_empresa%type,
	current_setting('pls_ame_pck.ie_titularidade_w')::varchar(1)
from	pls_plano	x,
	pls_segurado	y
where	x.nr_sequencia	= y.nr_seq_plano
and	y.nr_sequencia	= nr_seq_segurado_p;

select	max(cd_dependente)
into STRICT	cd_dependente_w
from	pls_ame_regra_conv_depen
where (nr_seq_parentesco	= current_setting('pls_ame_pck.nr_seq_parentesco_w')::bigint or coalesce(nr_seq_parentesco::text, '') = '')
and (ie_tipo_parentesco	= current_setting('pls_ame_pck.ie_tipo_parentesco_w')::bigint or coalesce(ie_tipo_parentesco::text, '') = '')
and (ie_titular		= current_setting('pls_ame_pck.ie_titular_w')::varchar(1));

for r_c01_w in current_setting('pls_ame_pck.c01')::CURSOR( loop
	begin
	
	PERFORM set_config('pls_ame_pck.nr_seq_tipo_prestador_w', null, false);
	if (r_c01_w.nr_seq_prestador IS NOT NULL AND r_c01_w.nr_seq_prestador::text <> '') then
		select	max(nr_seq_tipo_prestador)
		into STRICT	current_setting('pls_ame_pck.nr_seq_tipo_prestador_w')::pls_prestador.nr_seq_tipo_prestador%type
		from	pls_prestador
		where	nr_sequencia = r_c01_w.nr_seq_prestador;
	end if;

	open current_setting('pls_ame_pck.c02')::CURSOR((r_c01_w.ie_tipo_item,
		current_setting('pls_ame_pck.nr_seq_tipo_prestador_w')::pls_prestador.nr_seq_tipo_prestador%type,
		r_c01_w.nr_seq_prestador,
		current_setting('pls_ame_pck.nr_seq_parentesco_w')::bigint);
	loop
	fetch current_setting('pls_ame_pck.c02')::CURSOR( into
		current_setting('pls_ame_pck.nr_seq_regra_conv_rubrica_w')::pls_ame_regra_conv_rubrica.nr_sequencia%type;
	EXIT WHEN NOT FOUND; /* apply on current_setting('pls_ame_pck.c02')::CURSOR( */
	end loop;
	close current_setting('pls_ame_pck.c02')::CURSOR(;

	begin
	select	cd_cobranca,
		ds_cobranca
	into STRICT	cd_cobranca_w,
		ds_cobranca_w
	from	pls_ame_regra_conv_rubrica
	where	nr_sequencia	= current_setting('pls_ame_pck.nr_seq_regra_conv_rubrica_w')::pls_ame_regra_conv_rubrica.nr_sequencia%type;
	exception
		when others then
		cd_cobranca_w	:= '';
		ds_cobranca_w	:= '';
	end;

	select	nextval('pls_ame_lote_rem_valor_det_seq')
	into STRICT	nr_seq_lote_rem_valor_det_w
	;

	qt_dias_pro_rata_dia_w	:= obter_dias_entre_datas(current_setting('pls_ame_pck.dados_lote_remessa_w')::pls_ame_lote_remessa%rowtype.dt_ref_mensalidade,dt_rescisao_lib_deb_w) + 1;

	PERFORM set_config('pls_ame_pck.nr_seq_regra_ger_item_w', pls_ame_pck.obter_regra_geracao_item(nr_seq_regra_ger_arq_p, r_c01_w.ie_tipo_item), false);

	select	count(1)
	into STRICT	current_setting('pls_ame_pck.qt_registros_w')::bigint
	from	pls_ame_regra_ger_item_apr
	where	nr_seq_regra_item = current_setting('pls_ame_pck.nr_seq_regra_ger_item_w')::pls_ame_regra_ger_item.nr_sequencia%type;

	if (current_setting('pls_ame_pck.nr_seq_regra_ger_item_w')::pls_ame_regra_ger_item.nr_sequencia%coalesce(type::text, '') = '') then
		PERFORM set_config('pls_ame_pck.vl_item_w', r_c01_w.vl_item, false);
	else
		if	((r_c01_w.ie_tipo_item in ('3','6','13')) and (current_setting('pls_ame_pck.qt_registros_w')::bigint > 0)) then
			select	coalesce(sum(b.vl_apropriacao), 0)
			into STRICT	vl_baixa_centro_aprop_w
			from	pls_mensalidade_item_conta a,
				pls_mens_item_conta_aprop b,
				pls_mensalidade_seg_item c,
				pls_mensalidade_segurado d,
				pls_mensalidade e
			where	a.nr_sequencia = b.nr_seq_mens_item_conta
			and	c.nr_seq_conta = r_c01_w.nr_seq_conta
			and	e.nr_sequencia = d.nr_seq_mensalidade
			and	d.nr_sequencia = c.nr_seq_mensalidade_seg
			and	c.nr_sequencia = a.nr_seq_item
			and	coalesce(e.ie_cancelamento::text, '') = ''
			and	c.ie_tipo_item 	= r_c01_w.ie_tipo_item
			and	b.nr_seq_centro_apropriacao in (SELECT 	nr_seq_centro_apropriacao
								from	pls_ame_regra_ger_item_apr
								where	nr_seq_regra_item = current_setting('pls_ame_pck.nr_seq_regra_ger_item_w')::pls_ame_regra_ger_item.nr_sequencia%type);
					
			if (r_c01_w.ie_tipo_item = '3') then
				select	coalesce(sum(a.vl_apropriacao), 0)
				into STRICT	vl_total_aprop_w
				from	pls_conta_copartic_aprop a,
					pls_conta_coparticipacao b
				where	b.nr_sequencia = a.nr_seq_conta_coparticipacao
				and	b.nr_seq_conta = r_c01_w.nr_seq_conta
				and	a.nr_seq_centro_apropriacao in (SELECT 	nr_seq_centro_apropriacao
									from	pls_ame_regra_ger_item_apr
									where	nr_seq_regra_item = current_setting('pls_ame_pck.nr_seq_regra_ger_item_w')::pls_ame_regra_ger_item.nr_sequencia%type);
			elsif (r_c01_w.ie_tipo_item = '6') then
				select	coalesce(sum(a.vl_apropriacao), 0)
				into STRICT	vl_total_aprop_w
				from	pls_conta_pos_estab_aprop a,
					pls_conta_pos_estabelecido b
				where	b.nr_sequencia = a.nr_seq_conta_pos_estab
				and	b.nr_seq_conta = r_c01_w.nr_seq_conta
				and	a.nr_seq_centro_apropriacao in (SELECT 	nr_seq_centro_apropriacao
									from	pls_ame_regra_ger_item_apr
									where	nr_seq_regra_item = current_setting('pls_ame_pck.nr_seq_regra_ger_item_w')::pls_ame_regra_ger_item.nr_sequencia%type);
			elsif (r_c01_w.ie_tipo_item = '13') then
				select	coalesce(sum(a.vl_apropriacao), 0)
				into STRICT	vl_total_aprop_w
				from	pls_conta_co_aprop a,
					pls_conta_co b
				where	b.nr_sequencia = a.nr_seq_conta_co
				and	b.nr_seq_conta = r_c01_w.nr_seq_conta
				and	a.nr_seq_centro_apropriacao in (SELECT 	nr_seq_centro_apropriacao
									from	pls_ame_regra_ger_item_apr
									where	nr_seq_regra_item = current_setting('pls_ame_pck.nr_seq_regra_ger_item_w')::pls_ame_regra_ger_item.nr_sequencia%type);
			end if;

			PERFORM set_config('pls_ame_pck.vl_item_w', vl_total_aprop_w - vl_baixa_centro_aprop_w, false);
		else
			PERFORM set_config('pls_ame_pck.vl_item_w', coalesce(pls_ame_pck.obter_valor_apropriacao(	nr_seq_regra_ger_arq_p, r_c01_w.ie_tipo_item, null,
									null, null, r_c01_w.vl_item,
									null, r_c01_w.nr_seq_segurado_preco, r_c01_w.nr_seq_conta,
									null, null, null),0), false);
		end if;
	end if;

	if (r_c01_w.ie_tipo_item in ('1','15')) then
		qt_dias_w			:= obter_dias_entre_datas(trunc(r_c01_w.dt_rescisao,'Month'),r_c01_w.dt_rescisao)+1;
		tx_proporcional_rescisao_w	:= (qt_dias_w/(to_char(last_day(trunc(r_c01_w.dt_rescisao,'Month')),'dd'))::numeric );
		PERFORM set_config('pls_ame_pck.vl_item_w', (tx_proporcional_rescisao_w * current_setting('pls_ame_pck.vl_item_w')::double), false);
	end if;

	if (current_setting('pls_ame_pck.vl_item_w')::double > 0)	then
		insert into pls_ame_lote_rem_valor_det(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_lote_rem_valor,cd_dependente,ie_tipo_item,ie_tipo_cobranca,cd_cobranca,
				ds_cobranca,vl_detalhe,qt_dias_pro_rata)
		values (	nr_seq_lote_rem_valor_det_w,clock_timestamp(),get_nm_usuario,clock_timestamp(),get_nm_usuario,
				nr_seq_lote_rem_valor_p,cd_dependente_w,r_c01_w.ie_tipo_item,CASE WHEN r_c01_w.ie_tipo_item='3' THEN 'C' WHEN r_c01_w.ie_tipo_item='6' THEN 'P' WHEN r_c01_w.ie_tipo_item='7' THEN 'P' WHEN r_c01_w.ie_tipo_item='13' THEN 'O'  ELSE 'M' END ,cd_cobranca_w,
				ds_cobranca_w,current_setting('pls_ame_pck.vl_item_w')::double,qt_dias_pro_rata_dia_w);

		CALL pls_ame_pck.inserir_itens_contas_copart(	nr_seq_regra_ger_arq_p, nr_seq_lote_rem_valor_det_w, null,
						r_c01_w.nr_seq_conta, null, r_c01_w.ie_tipo_item,
						null, 'S', null);
	end if;
	end;
end loop;

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ame_pck.incluir_benef_lib_debito ( nr_seq_regra_ger_arq_p bigint, nr_seq_segurado_p bigint, nr_seq_lote_rem_valor_p bigint) FROM PUBLIC;
