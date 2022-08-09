-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fluxo_caixa_doc_passado (cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_empresa_p bigint, ie_restringe_estab_p text, vl_saldo_anterior_p bigint, ie_periodo_p text, ie_dia_util_p text, ie_todas_contas_p text, ie_operacao_p text, ie_somente_ativa_p text, nr_seq_regra_p bigint default null, cd_moeda_p bigint default null) AS $body$
DECLARE


/*--------------------------------------------------------------- ATENÇÃO ----------------------------------------------------------------*/


/* Cuidado ao realizar alterações no fluxo de caixa. Toda e qualquer alteração realizada em qualquer uma das       */


/* procedures do fluxo de caixa deve ser cuidadosamente verificada e realizada no fluxo de caixa em lote.           */


/* Devemos garantir que os dois fluxos de caixa tragam os mesmos valores no resultado, evitando assim que           */


/* existam diferenças entre os fluxos de caixa.                                                                                                                */


/*--------------- AO ALTERAR O FLUXO DE CAIXA ALTERAR TAMBÉM O FLUXO DE CAIXA EM LOTE ---------------*/

qt_dia_fechado_w		integer;
dt_mes_fechamento_w		timestamp;
dt_inicio_w			timestamp;
dt_final_w			timestamp;
dt_inicio_mes_w			timestamp;
dt_final_mes_w			timestamp;
dt_final_fim_mes_w		timestamp;
ie_fechamento_w			varchar(1);
ie_gera_saldo_banco_w		varchar(1);
ie_filtro_fluxo_w		varchar(1);
ie_filtro_fluxo_proj_w		varchar(1);
ie_cheque_pago_pend_w		parametro_fluxo_caixa.ie_cheque_pago_pend%type	:= 'N';
ie_operacao_w			conta_financeira.ie_oper_fluxo%type;
ie_conta_financ_ativa_w		conta_financeira.ie_situacao%type;
ie_fluxo_especial_w		parametro_fluxo_caixa.ie_fluxo_especial%type;
/* Projeto Multimoeda - Variáveis */

cd_moeda_estrang_w		moeda.cd_moeda%type;
cd_moeda_empresa_w		moeda.cd_moeda%type;

c01 CURSOR FOR
	SELECT	a.ie_integracao,
		a.dt_referencia,
		a.cd_conta_financ,
		sum(a.vl_fluxo) vl_fluxo,
		a.cd_moeda,
		a.ie_classif_fluxo,
		a.cd_estabelecimento,
		a.cd_empresa,
		obter_se_contrato_titulo(a.nr_titulo_pagar,a.nr_titulo_receber) ie_contrato
	from	fluxo_caixa_docto a
	where	a.ie_classif_fluxo = 'P'
	and	a.dt_referencia between dt_inicio_w and dt_final_w
	and	a.cd_empresa = cd_empresa_p
	and (ie_restringe_estab_p = 'N'
		or (ie_restringe_estab_p = 'E' and a.cd_estabelecimento = cd_estabelecimento_p)
		or (ie_restringe_estab_p = 'S' and (a.cd_estabelecimento = cd_estabelecimento_p or a.cd_estab_financeiro = cd_estabelecimento_p)))
	and (ie_restringe_estab_p = 'N' or substr(obter_se_conta_financ_estab(a.cd_conta_financ, cd_estabelecimento_p,ie_restringe_estab_p),1,1) = 'S')
	and (ie_filtro_fluxo_w = 'N' or substr(obter_se_filtro_fluxo_estab(a.nr_seq_conta_banco, a.nr_seq_cheque_cr, null, nm_usuario_p, a.nr_seq_caixa, cd_estabelecimento_p),1,1) = 'S')
	and	coalesce(a.cd_moeda,cd_moeda_empresa_w) = coalesce(cd_moeda_estrang_w,cd_moeda_empresa_w)   --Projeto Multimoeda - Busca apenas os registros da moeda relacionada
	and (ie_filtro_fluxo_proj_w = 'N' or substr(obter_se_proj_filtro_fluxo(a.nr_seq_proj_recurso, nm_usuario_p),1,1) = 'S')
	and	(coalesce(a.nr_titulo_receber::text, '') = ''
		or ((a.nr_titulo_receber IS NOT NULL AND a.nr_titulo_receber::text <> '')
		and not exists	(SELECT	1
				from	fluxo_caixa_excecao x
				where	x.ie_integracao		= 'TR'
				and	x.ie_origem_titulo_rec	= (select b.ie_origem_titulo from titulo_receber b where b.nr_titulo = a.nr_titulo_receber)
				and	x.ie_tipo_fluxo		= 'P')))
	group by a.ie_integracao,
		a.dt_referencia,
		a.cd_conta_financ,
		a.cd_moeda,
		a.ie_classif_fluxo,
		a.cd_estabelecimento,
		a.cd_empresa,
		obter_se_contrato_titulo(a.nr_titulo_pagar,a.nr_titulo_receber)
	
union all
	/* acumular cheques pagos à compensar no primeiro dia do fluxo */
	select	a.ie_integracao,
		dt_inicio_p,
		a.cd_conta_financ,
		sum(a.vl_fluxo) vl_fluxo,
		a.cd_moeda,
		a.ie_classif_fluxo,
		a.cd_estabelecimento,
		a.cd_empresa,
		'N' ie_contrato
	from	fluxo_caixa_docto a,
		cheque b
	where	a.ie_classif_fluxo = 'P'
	and	(a.nr_seq_cheque_cp IS NOT NULL AND a.nr_seq_cheque_cp::text <> '')
	and	a.nr_seq_cheque_cp = b.nr_sequencia
	and	a.dt_referencia < dt_inicio_w
	and 	a.dt_referencia > dt_final_w
	and	b.dt_emissao < dt_inicio_w
	and (coalesce(b.dt_compensacao::text, '') = '' or b.dt_compensacao > dt_final_w)
	and	ie_cheque_pago_pend_w = 'S'
	and	a.cd_empresa = cd_empresa_p
	and (ie_restringe_estab_p = 'N'
		or (ie_restringe_estab_p = 'E' and a.cd_estabelecimento = cd_estabelecimento_p)
		or (ie_restringe_estab_p = 'S' and (a.cd_estabelecimento = cd_estabelecimento_p or a.cd_estab_financeiro = cd_estabelecimento_p)))
	and (ie_restringe_estab_p = 'N' or substr(obter_se_conta_financ_estab(a.cd_conta_financ, cd_estabelecimento_p,ie_restringe_estab_p),1,1) = 'S')
	and (ie_filtro_fluxo_w = 'N' or substr(obter_se_filtro_fluxo_estab(a.nr_seq_conta_banco, a.nr_seq_cheque_cr, null, nm_usuario_p, a.nr_seq_caixa, cd_estabelecimento_p),1,1) = 'S')
	and	coalesce(a.cd_moeda,cd_moeda_empresa_w) = coalesce(cd_moeda_estrang_w,cd_moeda_empresa_w)   --Projeto Multimoeda - Busca apenas os registros da moeda relacionada
	group by a.ie_integracao,
		a.dt_referencia,
		a.cd_conta_financ,
		a.cd_moeda,
		a.ie_classif_fluxo,
		a.cd_estabelecimento,
		a.cd_empresa;

vet01		c01%rowtype;

c02 CURSOR FOR
	SELECT	cd_conta_financ
	from	conta_financeira
	where	CASE WHEN ie_somente_ativa_p='S' THEN ie_situacao  ELSE 'A' END  = 'A'
	and (cd_empresa		= cd_empresa_p or cd_estabelecimento = cd_estabelecimento_p)
	and	((ie_restringe_estab_p = 'N') or (obter_se_conta_financ_estab(cd_conta_financ, cd_estabelecimento_p,ie_restringe_estab_p) = 'S'))
	and	coalesce(ie_todas_contas_p,'N') = 'S';
	
vet02		c02%rowtype;


BEGIN

dt_inicio_w		:= pkg_date_utils.start_of(dt_inicio_p,'DD',0);
dt_final_w		:= fim_dia(dt_final_p);
dt_inicio_mes_w		:= pkg_date_utils.start_of(dt_inicio_p,'MONTH',0);
dt_final_mes_w		:= pkg_date_utils.start_of(dt_final_p,'MONTH',0);
dt_final_fim_mes_w	:= fim_mes(dt_final_p);

/* Projeto Multimoeda - Busca a moeda padrão da empresa e verifica o parâmetro cd_moeda passado na procedure. Ele será a base da busca dos dados
		em moeda estrangeira. Caso o parâmetro seja nulo, deverá ser considerada a moeda padrão da empresa nas consultas,
		caso contrário irá buscar somente os dados na moeda selecionada.*/
select obter_moeda_padrao_empresa(cd_estabelecimento_p,'E')
into STRICT cd_moeda_empresa_w
;
if (coalesce(cd_moeda_p::text, '') = '') then
	cd_moeda_estrang_w := cd_moeda_empresa_w;
else
	cd_moeda_estrang_w := cd_moeda_p;
end if;

select	coalesce(max('S'),'N')
into STRICT	ie_filtro_fluxo_w
from	w_filtro_fluxo
where	nm_usuario	= nm_usuario_p
and	coalesce(nr_seq_proj_rec::text, '') = '';

select	coalesce(max('S'),'N')
into STRICT	ie_filtro_fluxo_proj_w
from	w_filtro_fluxo
where	nm_usuario	= nm_usuario_p
and	(nr_seq_proj_rec IS NOT NULL AND nr_seq_proj_rec::text <> '');

ie_fechamento_w := obter_param_usuario(830, 22, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_fechamento_w);
ie_gera_saldo_banco_w := obter_param_usuario(830, 26, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gera_saldo_banco_w);

if (ie_fechamento_w = 'N') then
	select	to_char(max(a.dt_referencia),'dd/mm/yyyy') dt_referencia,
		count(*) qt_dia_fechado
	into STRICT	dt_mes_fechamento_w,
		qt_dia_fechado_w
	from	fluxo_caixa_fechamento a
	where	dt_referencia		between dt_inicio_mes_w and dt_final_mes_w
	and	cd_empresa		= cd_empresa_p
	and	coalesce(ie_tipo_fluxo,'G')	= 'G'
	and	coalesce(coalesce(cd_estabelecimento, cd_estabelecimento_p), -1)	= coalesce(cd_estabelecimento_p, coalesce(cd_estabelecimento,-1));
else
	select	to_char(max(a.dt_referencia),'dd/mm/yyyy') dt_referencia,
		count(*) qt_dia_fechado
	into STRICT	dt_mes_fechamento_w,
		qt_dia_fechado_w
	from	fluxo_caixa_fechamento a
	where	dt_referencia		between dt_inicio_p and dt_final_w
	and	cd_empresa		= cd_empresa_p
	and	coalesce(ie_tipo_fluxo,'G')	= 'G'
	and	coalesce(coalesce(cd_estabelecimento, cd_estabelecimento_p), -1)	= coalesce(cd_estabelecimento_p, coalesce(cd_estabelecimento,-1));
end if;

if (qt_dia_fechado_w > 0) then
	/*não é possível gerar/alterar fluxo realizado para este período pois o dia/mês #@dt_referencia#@ já foi fechado!
	verifique essa data na pasta fechamento.*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(206330,'DT_REFERENCIA='||dt_mes_fechamento_w);
end if;

select	coalesce(max(ie_cheque_pago_pend),'N'),
	coalesce(max(ie_fluxo_especial),'S')
into STRICT 	ie_cheque_pago_pend_w,
	ie_fluxo_especial_w
from	parametro_fluxo_caixa
where	cd_estabelecimento	= cd_estabelecimento_p;

delete	from fluxo_caixa
where	dt_referencia 		between dt_inicio_p and dt_final_p
and	ie_classif_fluxo 	in ('P', 'V')
and	ie_origem 		<> 'D'
and	cd_empresa		= cd_empresa_p
and (ie_restringe_estab_p = 'N' or (ie_restringe_estab_p = 'E' and cd_estabelecimento = cd_estabelecimento_p) or (ie_restringe_estab_p = 'S' and (cd_estabelecimento = cd_estabelecimento_p or obter_estab_financeiro(cd_estabelecimento) = cd_estabelecimento_p)));

commit;

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (vet01.cd_conta_financ <> 0) then
		
		select	max(ie_oper_fluxo),
			CASE WHEN ie_somente_ativa_p='S' THEN max(ie_situacao)  ELSE 'A' END
		into STRICT	ie_operacao_w,
			ie_conta_financ_ativa_w
		from	conta_financeira
		where	cd_conta_financ	= vet01.cd_conta_financ;
		
		if (ie_operacao_p = 'A') or (ie_operacao_p = 'D' and ie_operacao_w <> 'S') or (ie_operacao_p = 'S' and ie_operacao_w <> 'D') then

			if (ie_conta_financ_ativa_w = 'A') then
				begin
				
				insert	into fluxo_caixa(cd_estabelecimento,
					dt_referencia,
					cd_conta_financ,
					ie_classif_fluxo,
					dt_atualizacao,
					nm_usuario, 
					vl_fluxo, 
					ie_origem, 
					ie_periodo,
					ie_integracao,
					cd_empresa,
					ie_contrato,
					cd_moeda)
				values (cd_estabelecimento_p,
					vet01.dt_referencia,
					vet01.cd_conta_financ,
					vet01.ie_classif_fluxo,
					clock_timestamp(), 
					nm_usuario_p, 
					coalesce(vet01.vl_fluxo,0), 
					'I', 
					'D',
					vet01.ie_integracao,
					cd_empresa_p,
					vet01.ie_contrato,
					coalesce(vet01.cd_moeda,cd_moeda_empresa_w));
				exception
					when unique_violation then
						update	fluxo_caixa
						set	vl_fluxo		= vl_fluxo + coalesce(vet01.vl_fluxo,0)
						where	cd_estabelecimento	= cd_estabelecimento_p
						and	cd_conta_financ		= vet01.cd_conta_financ
						and	dt_referencia		= vet01.dt_referencia
						and	ie_periodo		= 'D'
						and	ie_classif_fluxo	= vet01.ie_classif_fluxo
						and	ie_integracao		= vet01.ie_integracao
						and	cd_empresa		= cd_empresa_p
						and	coalesce(cd_moeda,cd_moeda_empresa_w) = coalesce(vet01.cd_moeda,cd_moeda_empresa_w);
					when others then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(176731,'CONTA_FINANC_W=' || vet01.cd_conta_financ || ';' ||
												'SQLERRM=' || sqlerrm);
				end;
				
			end if;
		end if;
	end if;
end loop;
close c01;

if (ie_gera_saldo_banco_w = 'S') then
	CALL gerar_fluxo_saldo_banco(	cd_estabelecimento_p,
					dt_inicio_p,
					dt_final_p,
					nm_usuario_p,
					'P',
					ie_periodo_p,
					cd_empresa_p,
					ie_somente_ativa_p,
					coalesce(cd_moeda_estrang_w,cd_moeda_empresa_w),
					ie_restringe_estab_p );
end if;

/* Adicionada chamada para gerar fluxo com regra especial de saldo bancário + saldo da tesouraria. Será chamado somente quando fluxo diário. */

if (ie_fluxo_especial_w = 'S' and ie_periodo_p = 'D') then
	CALL gerar_fluxo_caixa_esp(cd_estabelecimento_p,
				dt_inicio_p,
				dt_final_p,
				nm_usuario_p,
				cd_empresa_p,
				ie_restringe_estab_p,
				ie_operacao_p,
				ie_somente_ativa_p,
				'P',
				cd_moeda_p);
	commit;
end if;

/* acumular os valores diários para o mes */

delete from fluxo_caixa
where 	dt_referencia		between dt_inicio_mes_w and dt_final_fim_mes_w
and 	ie_classif_fluxo 	= 'P'
and	cd_empresa		= cd_empresa_p
and (ie_restringe_estab_p = 'N' or (ie_restringe_estab_p = 'E' and cd_estabelecimento = cd_estabelecimento_p) or (ie_restringe_estab_p = 'S' and (cd_estabelecimento = cd_estabelecimento_p or obter_estab_financeiro(cd_estabelecimento) = cd_estabelecimento_p)))
and	ie_origem 		<> 'D'
and	ie_periodo 		= 'M';

/* francisco - os 61295 - trazer todas contas financeiras */

open c02;
loop
fetch c02 into
	vet02;
EXIT WHEN NOT FOUND; /* apply on c02 */

	insert into fluxo_caixa(cd_estabelecimento,
		dt_referencia,
		cd_conta_financ, 
		ie_classif_fluxo,
		dt_atualizacao, 
		nm_usuario, 
		vl_fluxo, 
		ie_origem, 
		ie_periodo, 
		ie_integracao,
		cd_empresa,
		cd_moeda)
	values (cd_estabelecimento_p, 
		dt_inicio_p, 
		vet02.cd_conta_financ, 
		'P',
		clock_timestamp(), 
		nm_usuario_p, 
		0, 
		'I', 
		ie_periodo_p,
		'X',
		cd_empresa_p,
		coalesce(cd_moeda_estrang_w,cd_moeda_empresa_w));
end loop;
close c02;

commit;

begin
insert	into fluxo_caixa(
	cd_estabelecimento,
	dt_referencia,
	cd_conta_financ, 
	ie_classif_fluxo,
	dt_atualizacao, 
	nm_usuario, 
	vl_fluxo, 
	ie_origem, 
	ie_periodo, 
	ie_integracao,
	cd_empresa,
	ie_contrato,
	cd_moeda)
SELECT	w.cd_estabelecimento,
	w.dt_referencia,
	w.cd_conta_financ,
	'P',
	clock_timestamp(),
	nm_usuario_p,
	sum(w.vl_fluxo),
	'X',
	'M',
	w.ie_integracao,
	w.cd_empresa,
	max(w.ie_contrato),
	w.cd_moeda
from (SELECT	a.cd_estabelecimento,
		pkg_date_utils.start_of(pkg_date_utils.end_of(a.dt_referencia,'MONTH',0), 'dd', 0) dt_referencia,
		a.cd_conta_financ,
		a.vl_fluxo,
		a.ie_integracao,
		a.cd_empresa,
		a.ie_contrato,
		coalesce(a.cd_moeda,cd_moeda_empresa_w) cd_moeda
	from	fluxo_caixa a
	where	a.dt_referencia		between dt_inicio_mes_w and dt_final_fim_mes_w
	and (ie_restringe_estab_p = 'N' or (ie_restringe_estab_p = 'E' and cd_estabelecimento = cd_estabelecimento_p) or (ie_restringe_estab_p = 'S' and (cd_estabelecimento = cd_estabelecimento_p or obter_estab_financeiro(cd_estabelecimento) = cd_estabelecimento_p)))
	and	a.cd_empresa		= cd_empresa_p
	and	coalesce(a.cd_moeda,cd_moeda_empresa_w) = coalesce(cd_moeda_estrang_w,cd_moeda_empresa_w)
	and (ie_operacao_p = 'A' or (ie_operacao_p = 'S' and obter_operacao_conta_financ(a.cd_conta_financ) <> 'D') or (ie_operacao_p = 'D' and obter_operacao_conta_financ(a.cd_conta_financ) <> 'S'))
	and	a.ie_classif_fluxo	= 'P'
	and (substr(obter_se_filtro_fluxo_estab(a.nr_seq_conta_banco,null,null,nm_usuario_p,null, cd_estabelecimento_p),1,1) = 'S' or ie_origem <> 'D')) w
where	not exists	/* ahoffelder - os 481697 - não pode repetir essas informações, é pk (flucaix_pk) */
	(select	1
	from	fluxo_caixa x
	where	x.ie_integracao		= w.ie_integracao
	and	x.ie_periodo		= 'M'
	and	x.ie_classif_fluxo	= 'P'
	and	x.cd_conta_financ	= w.cd_conta_financ
	and	x.dt_referencia		= w.dt_referencia
	and	x.cd_estabelecimento	= w.cd_estabelecimento
	and	x.cd_empresa		= w.cd_empresa
	and	coalesce(x.cd_moeda,cd_moeda_empresa_w) = w.cd_moeda)
GROUP BY	w.cd_estabelecimento,
	w.dt_referencia,
	w.cd_conta_financ,
	w.cd_empresa,
	w.ie_integracao,
	w.cd_moeda;
exception
when unique_violation then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(176734,	'DT_INICIO_P=' || dt_inicio_p || ';' ||
							'DT_FINAL_P=' || dt_final_p || ';' ||
							'CD_ESTABELECIMENTO_P=' || cd_estabelecimento_p || ';' ||
							'CD_EMPRESA_P=' || cd_empresa_p);
end;

CALL calcular_fluxo_caixa(	cd_estabelecimento_p,
			vl_saldo_anterior_p,
			dt_inicio_p,
			dt_final_p,
			ie_periodo_p,
			'P',
			nm_usuario_p,
			cd_empresa_p,
			ie_restringe_estab_p,
			'N',
			ie_somente_ativa_p,
			nr_seq_regra_p,
			cd_moeda_estrang_w);

commit;

CALL gerar_fluxo_caixa_agrup(cd_estabelecimento_p,
			dt_inicio_p,
			dt_final_p,
			ie_periodo_p,
			'P',
			nm_usuario_p,
			cd_empresa_p,
			ie_operacao_p,
			ie_restringe_estab_p,
			ie_somente_ativa_p,
			coalesce(cd_moeda_estrang_w,cd_moeda_empresa_w));

commit;

end; HAVING(sum(w.vl_fluxo)		<> 0
	or (coalesce(ie_todas_contas_p,'N') = 'S'))
;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fluxo_caixa_doc_passado (cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_empresa_p bigint, ie_restringe_estab_p text, vl_saldo_anterior_p bigint, ie_periodo_p text, ie_dia_util_p text, ie_todas_contas_p text, ie_operacao_p text, ie_somente_ativa_p text, nr_seq_regra_p bigint default null, cd_moeda_p bigint default null) FROM PUBLIC;
