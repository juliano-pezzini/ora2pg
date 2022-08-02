-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_valor_pos_estab_sca (nr_seq_conta_p bigint, ie_pos_estab_faturamento_p pls_parametros.ie_pos_estab_faturamento%type, ie_geracao_pos_estabelecido_p pls_parametros.ie_geracao_pos_estabelecido%type, nm_usuario_p text, ie_origem_valor_pos_p text) AS $body$
DECLARE


ie_calcula_preco_benef_w	varchar(1);
nr_seq_procedimento_w		bigint;
nr_seq_material_w		bigint;
nr_seq_segurado_w		bigint;
cd_estabelecimento_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
ie_origem_proc_regra_w		procedimento.ie_origem_proced%type;
ie_preco_plano_w		varchar(2);
nr_seq_regra_pos_estab_w	bigint;
vl_procedimento_w		double precision	:= 0;
vl_apresentado_w		double precision	:= 0;
vl_beneficiario_w		double precision	:= 0;
vl_tot_beneficiario_w		double precision	:= 0;
vl_material_w			double precision	:= 0;
cd_guia_w			varchar(20);
ie_internado_w			varchar(1);
qt_registro_w			integer	:= 0;
ie_tipo_despesa_w		varchar(10);
tx_intercambio_w		double precision;
nr_seq_regra_inter_w		bigint;
ie_tipo_conta_w			varchar(10);
ie_cobranca_pos_w		varchar(1)	:= 'N';
dt_rescisao_w			timestamp;
cd_usuario_plano_w		varchar(30);
qt_devolucao_carteira_w		bigint;
dt_procedimento_w		timestamp;
dt_atendimento_w		timestamp;
ie_calculo_pos_estab_w		pls_parametros.ie_calculo_pos_estab%type;
ie_tipo_valor_w			varchar(5);
nr_seq_regra_w			bigint;
nr_seq_sca_w			bigint;
vl_provisao_w			double precision;
nr_seq_pos_estab_w		bigint;
vl_custo_operacional_w		double precision;
vl_materiais_w			double precision;
vl_benef_proc_w			double precision;
vl_calculado_w			double precision;
vl_resultado_w			double precision := 0;
tx_administrativa_w		double precision;
vl_administrativa_w		double precision;
qt_procedimento_w		double precision;
qt_material_w			double precision;
ie_origem_conta_w		varchar(1);
vl_liberado_w			double precision;
dt_atendimento_referencia_w	timestamp;
dt_inicio_item_w		timestamp;
dt_fim_item_w			timestamp;
nr_seq_pos_cabecalho_w		bigint;
vl_glosa_w			double precision;
dados_conta_pos_w		pls_cta_valorizacao_pck.dados_conta_pos;
dados_regra_preco_pos_estab_w	pls_cta_valorizacao_pck.dados_regra_preco_pos_estab;
ie_apresentacao_prot_w		dados_conta_pos_w.ie_apresentacao_prot%type;
ie_tipo_despesa_mat_w		dados_conta_pos_w.ie_tipo_desp_mat%type;
dados_regra_preco_proc_w	pls_cta_valorizacao_pck.dados_regra_preco_proc;
dados_regra_preco_material_w	pls_cta_valorizacao_pck.dados_regra_preco_material;
nr_seq_prestador_prot_w		dados_conta_pos_w.nr_seq_prestador_prot%type;
ie_controle_pos_estabelecido_w	pls_parametros.ie_controle_pos_estabelecido%type;
ie_cobrar_mensalidade_w		pls_conta_pos_estabelecido.ie_cobrar_mensalidade%type;
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
ie_tipo_segurado_w		pls_segurado.ie_tipo_segurado%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
dt_mes_competencia_w		pls_protocolo_conta.dt_mes_competencia%type;
ie_tipo_protocolo_w		pls_protocolo_conta.ie_tipo_protocolo%type;
ie_tipo_prestador_atend_w	varchar(2);
ie_tipo_prestador_exec_w	varchar(2);
nr_seq_prestador_exec_w		pls_prestador.nr_sequencia%type;
ie_origem_protocolo_w		pls_protocolo_conta.ie_origem_protocolo%type;
nr_seq_ops_congenere_w		pls_congenere.nr_sequencia%type;
nr_seq_congenere_w		pls_congenere.nr_sequencia%type;
ie_glosa_parcial_w		varchar(1);
nr_seq_prest_Inter_w	pls_conta.nr_seq_prest_inter%type;

C01 CURSOR FOR
	SELECT	nr_seq_plano
	from	pls_sca_vinculo
	where	nr_seq_segurado	= nr_seq_segurado_w;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.vl_procedimento,
		a.vl_procedimento_imp,
		a.ie_tipo_despesa,
		a.dt_procedimento,
		a.vl_provisao,
		a.nr_seq_regra_pos_estab,
		a.tx_intercambio,
		a.vl_taxa_servico,
		coalesce(a.qt_procedimento_imp,1),
		vl_liberado,
		a.dt_inicio_proc,
		a.dt_fim_proc,
		a.vl_glosa,
		(	SELECT 	max(nr_seq_prest_inter)
			from 	pls_conta
			where	nr_sequencia = a.nr_seq_conta) nr_seq_prest_inter
	from	pls_conta_proc	a
	where	a.nr_seq_conta		= nr_seq_conta_p
	and	a.nr_seq_sca_cobertura	= nr_seq_sca_w
	and	not exists (	select	1
				from	pls_conta_pos_estabelecido	x
				where	x.nr_seq_conta_proc	= a.nr_sequencia
				and	((x.ie_situacao	= 'A') or (coalesce(x.ie_situacao::text, '') = '')));

C03 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_tipo_despesa,
		a.vl_material,
		a.dt_atendimento,
		a.vl_provisao,
		a.nr_seq_regra_pos_estab,
		coalesce(a.qt_material_imp,1),
		vl_liberado,
		vl_material_imp,
		a.dt_inicio_atend,
		a.dt_fim_atend,
		a.ie_tipo_despesa,
		a.vl_glosa,
		(	SELECT 	max(nr_seq_prest_inter)
			from 	pls_conta
			where	nr_sequencia = a.nr_seq_conta) nr_seq_prest_inter
	from	pls_conta_mat	a
	where	a.nr_seq_conta		= nr_seq_conta_p
	and	a.nr_seq_sca_cobertura	= nr_seq_sca_w
	and	not exists	(select	1
				from	pls_conta_pos_estabelecido	x
				where	x.nr_seq_conta_mat	= a.nr_sequencia
				and	((x.ie_situacao	= 'A') or (coalesce(x.ie_situacao::text, '') = '')));


BEGIN
update	pls_conta_proc
set	ie_co_preco_operadora	= 'N'
where	nr_seq_conta		= nr_seq_conta_p;

update	pls_conta_mat
set	ie_co_preco_operadora	= 'N'
where	nr_seq_conta		= nr_seq_conta_p;

if (ie_pos_estab_faturamento_p = 'N') or (ie_geracao_pos_estabelecido_p != 'F') then
	/* Obter dados da conta */

	select	a.nr_seq_segurado,
		a.cd_estabelecimento,
		a.cd_guia,
		pls_obter_se_internado(a.nr_sequencia, 'C'),
		a.ie_tipo_conta,
		b.dt_rescisao,
		a.ie_origem_conta,
		a.dt_atendimento_referencia,
		c.ie_apresentacao,
		c.nr_seq_prestador,
		a.ie_tipo_guia,
		c.ie_tipo_protocolo,
		coalesce(a.ie_tipo_segurado, b.ie_tipo_segurado),
		c.dt_mes_competencia,
		c.nr_sequencia,
		a.nr_seq_prestador_exec,
		c.ie_origem_protocolo,
		b.nr_seq_ops_congenere,
		b.nr_seq_congenere
	into STRICT	nr_seq_segurado_w,
		cd_estabelecimento_w,
		cd_guia_w,
		ie_internado_w,
		ie_tipo_conta_w,
		dt_rescisao_w,
		ie_origem_conta_w,
		dt_atendimento_referencia_w,
		ie_apresentacao_prot_w,
		nr_seq_prestador_prot_w,
		ie_tipo_guia_w,
		ie_tipo_protocolo_w,
		ie_tipo_segurado_w,
		dt_mes_competencia_w,
		nr_seq_protocolo_w,
		nr_seq_prestador_exec_w,
		ie_origem_protocolo_w,
		nr_seq_ops_congenere_w,
		nr_seq_congenere_w
	FROM pls_protocolo_conta c, pls_conta a
LEFT OUTER JOIN pls_segurado b ON (a.nr_seq_segurado = b.nr_sequencia)
WHERE a.nr_sequencia		= nr_seq_conta_p and c.nr_sequencia		= a.nr_seq_protocolo;
else
	select	max(c.nr_sequencia)
	into STRICT	nr_seq_pos_cabecalho_w
	from	pls_conta		a,
		pls_segurado		b,
		pls_conta_pos_cabecalho c
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_conta_p
	and	a.nr_sequencia		= c.nr_seq_conta;

	if (coalesce(nr_seq_pos_cabecalho_w,0) > 0) then
		select	c.nr_seq_segurado,
			c.cd_estabelecimento,
			c.cd_guia,
			pls_obter_se_internado(a.nr_sequencia, 'C'),
			a.ie_tipo_conta,
			b.dt_rescisao,
			c.ie_origem_conta,
			c.dt_atendimento,
			d.ie_apresentacao,
			d.nr_seq_prestador,
			a.ie_tipo_guia,
			d.ie_tipo_protocolo,
			coalesce(a.ie_tipo_segurado, b.ie_tipo_segurado),
			d.dt_mes_competencia,
			d.nr_sequencia,
			a.nr_seq_prestador_exec
		into STRICT	nr_seq_segurado_w,
			cd_estabelecimento_w,
			cd_guia_w,
			ie_internado_w,
			ie_tipo_conta_w,
			dt_rescisao_w,
			ie_origem_conta_w,
			dt_atendimento_referencia_w,
			ie_apresentacao_prot_w,
			nr_seq_prestador_prot_w,
			ie_tipo_guia_w,
			ie_tipo_protocolo_w,
			ie_tipo_segurado_w,
			dt_mes_competencia_w,
			nr_seq_protocolo_w,
			nr_seq_prestador_exec_w
		from	pls_conta		a,
			pls_segurado		b,
			pls_conta_pos_cabecalho c,
			pls_protocolo_conta d
		where	a.nr_seq_segurado	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_conta_p
		and	a.nr_sequencia		= c.nr_seq_conta
		and	c.nr_sequencia		= nr_seq_pos_cabecalho_w
		and 	d.nr_sequencia		= a.nr_seq_protocolo;
	end if;
end if;

cd_usuario_plano_w	:= pls_obter_carteira_segurado(nr_seq_segurado_w);

if (ie_internado_w	= 'S') then
	select	count(1)
	into STRICT	qt_registro_w
	from	pls_conta_pos_estabelecido	b,
		pls_conta			a
	where	a.nr_sequencia		= b.nr_seq_conta
	and	((b.ie_situacao	= 'A') or (coalesce(b.ie_situacao::text, '') = ''))
	and	((a.cd_guia_referencia	= cd_guia_w and (a.cd_guia_referencia IS NOT NULL AND a.cd_guia_referencia::text <> ''))
	or (a.cd_guia = cd_guia_w and coalesce(a.cd_guia_referencia::text, '') = ''));
end if;

select	coalesce(max(ie_calculo_pos_estab),'C'),
	coalesce(max(ie_controle_pos_estabelecido),'N')
into STRICT	ie_calculo_pos_estab_w,
	ie_controle_pos_estabelecido_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_w;

if (ie_controle_pos_estabelecido_w = 'S') then
	ie_cobrar_mensalidade_w	:= 'P'; -- Pendente de liberação
else
	ie_cobrar_mensalidade_w	:= 'S'; -- Liberado para a mensalidade
end if;

begin
select	CASE WHEN coalesce(cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END
into STRICT	ie_tipo_prestador_atend_w
from	pls_prestador
where	nr_sequencia	= nr_seq_prestador_prot_w;
exception
when others then
	ie_tipo_prestador_atend_w	:= null;
end;

begin
select	CASE WHEN coalesce(cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END
into STRICT	ie_tipo_prestador_exec_w
from	pls_prestador
where	nr_sequencia	= nr_seq_prestador_exec_w;
exception
when others then
	ie_tipo_prestador_exec_w	:= null;
end;

open C01;
loop
fetch C01 into
	nr_seq_sca_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_cobranca_pos_w	:= 'N';

	/* Obter dados do plano */

	begin
	select	ie_preco
	into STRICT	ie_preco_plano_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_sca_w;
	exception
	when others then
		ie_preco_plano_w	:= null;
	end;

	/* Felipe - 12/09/2011 - OS 332785
	Para os beneficiário rescindidos em Pré pagamento, que não devolveram a carteira, se for parametrizado, o sistema irá realizar a cobrança em Pós estabelecido */
	if (ie_preco_plano_w = '1') and (dt_atendimento_referencia_w > dt_rescisao_w ) and (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then
		select	coalesce(max(ie_cobranca_pos),'N')
		into STRICT	ie_cobranca_pos_w
		from	pls_parametros
		where	cd_estabelecimento	= cd_estabelecimento_w;

		if (ie_cobranca_pos_w = 'S') then
			ie_cobranca_pos_w	:= 'N';
			select	count(1)
			into STRICT	qt_devolucao_carteira_w
			from	pls_carteira_devolucao
			where	cd_usuario_plano	= cd_usuario_plano_w;

			if (qt_devolucao_carteira_w = 0) then
				ie_cobranca_pos_w	:= 'S';
			end if;
		end if;
	end if;

	ie_calcula_preco_benef_w	:= pls_obter_dados_conta(nr_seq_conta_p, 'CPO');

	if (qt_registro_w	= 0) and
		((ie_calcula_preco_benef_w = 'S') or (ie_preco_plano_w in ('2','3')) or (ie_cobranca_pos_w = 'S')) then
		/* PROCEDIMENTOS */

		open C02;
		loop
		fetch C02 into
			nr_seq_procedimento_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			vl_procedimento_w,
			vl_apresentado_w,
			ie_tipo_despesa_w,
			dt_procedimento_w,
			vl_provisao_w,
			nr_seq_regra_pos_estab_w,
			tx_administrativa_w,
			vl_administrativa_w,
			qt_procedimento_w,
			vl_liberado_w,
			dt_inicio_item_w,
			dt_fim_item_w,
			vl_glosa_w,
			nr_seq_prest_Inter_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			dados_regra_preco_proc_w		:= null;
			dados_conta_pos_w.cd_area_procedimento	:= null;
			dados_conta_pos_w.cd_especialidade	:= null;
			dados_conta_pos_w.cd_grupo_proc		:= null;

			if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
				SELECT * FROM pls_obter_estrut_proc(	cd_procedimento_w, ie_origem_proced_w, dados_conta_pos_w.cd_area_procedimento, dados_conta_pos_w.cd_especialidade, dados_conta_pos_w.cd_grupo_proc, ie_origem_proc_regra_w) INTO STRICT dados_conta_pos_w.cd_area_procedimento, dados_conta_pos_w.cd_especialidade, dados_conta_pos_w.cd_grupo_proc, ie_origem_proc_regra_w;
			end if;

			/* Se tinha que cobrar valor Pós de beneficiário Pre, mas o item foi executado antes da rescisao, então não cobra */

			if (ie_cobranca_pos_w = 'S') and (dt_procedimento_w <= dt_rescisao_w) then
				goto final;
			end if;

			if (ie_calculo_pos_estab_w = 'C') then
				if (ie_calcula_preco_benef_w = 'N') and (ie_preco_plano_w in ('2','3')) then
					vl_beneficiario_w	:= vl_procedimento_w;
				end if;
			elsif (ie_calculo_pos_estab_w = 'R') then
				dados_conta_pos_w.nr_seq_segurado	:= nr_seq_segurado_w;
				dados_conta_pos_w.dt_referencia		:= dt_procedimento_w;
				dados_conta_pos_w.ie_origem_conta	:= ie_origem_conta_w;
				dados_conta_pos_w.ie_apresentacao_prot	:= ie_apresentacao_prot_w;
				dados_conta_pos_w.ie_tipo_desp_mat	:= null;
				dados_conta_pos_w.nr_seq_prestador_prot	:= nr_seq_prestador_prot_w;

				dados_conta_pos_w.cd_procedimento	:= cd_procedimento_w;
				dados_conta_pos_w.ie_origem_proced	:= ie_origem_proced_w;
				dados_conta_pos_w.nr_seq_prestador_exec	:= nr_seq_prestador_exec_w;
				dados_conta_pos_w.ie_tipo_intercambio	:= coalesce(pls_obter_tipo_intercambio(coalesce(nr_seq_ops_congenere_w,nr_seq_congenere_w),cd_estabelecimento_w),'A');
				dados_conta_pos_w.ie_origem_protocolo	:= ie_origem_protocolo_w;
				dados_conta_pos_w.ie_tipo_congenere	:= coalesce(pls_obter_dados_cooperativa(coalesce(nr_seq_ops_congenere_w,nr_seq_congenere_w),'IT'),'A');
				dados_conta_pos_w.nr_seq_prest_inter :=  nr_seq_prest_Inter_w;

				dados_regra_preco_pos_estab_w := pls_obter_tipo_valor_pos_estab(	dados_conta_pos_w, nm_usuario_p, cd_estabelecimento_w, dados_regra_preco_pos_estab_w);

				nr_seq_regra_w		:= dados_regra_preco_pos_estab_w.nr_sequencia;
				ie_tipo_valor_w		:= dados_regra_preco_pos_estab_w.ie_tipo_valor;

				-- se a regra que retornou diz que não é para aplicar a taxa, então seta a variável para zero
				if (coalesce(dados_regra_preco_pos_estab_w.ie_nao_gera_tx_inter, 'N') = 'S') then

					tx_intercambio_w := 0;
				end if;

				if (ie_tipo_valor_w = '1') then
					ie_calcula_preco_benef_w := 'S';

				elsif (ie_tipo_valor_w = '2') then
					vl_beneficiario_w	:= vl_apresentado_w;
					ie_calcula_preco_benef_w := 'N';

				elsif (ie_tipo_valor_w = '3') then
					if (coalesce(vl_liberado_w,0) > 0) then
						vl_beneficiario_w	:= vl_liberado_w;
					else
						vl_beneficiario_w	:= vl_procedimento_w;
					end if;
					ie_calcula_preco_benef_w := 'N';

				elsif (ie_tipo_valor_w = '4') then
					ie_calcula_preco_benef_w := 'S';

				elsif (ie_tipo_valor_w = '5') then
					ie_calcula_preco_benef_w := 'S';

				elsif (ie_tipo_valor_w = '7') then
					vl_beneficiario_w	 := vl_apresentado_w;
					ie_calcula_preco_benef_w := 'N';

				elsif (ie_tipo_valor_w = '8') then
					vl_beneficiario_w	 := vl_liberado_w;
					ie_calcula_preco_benef_w := 'N';
				end if;
			elsif (ie_calculo_pos_estab_w = 'P') then
				vl_beneficiario_w		:= vl_procedimento_w;
				ie_calcula_preco_benef_w 	:= 'N';
			elsif ( ie_calculo_pos_estab_w = 'O') then
				ie_calcula_preco_benef_w	:= 'S';
			end if;

			if (ie_calcula_preco_benef_w = 'S') then
				dados_regra_preco_proc_w := pls_atualiza_valor_proc_co(nr_seq_procedimento_w, ie_tipo_despesa_w, 'N', ie_pos_estab_faturamento_p, ie_geracao_pos_estabelecido_p, nm_usuario_p, dados_regra_preco_proc_w);

				select	coalesce(max(vl_beneficiario),0)
				into STRICT	vl_beneficiario_w
				from	pls_conta_proc
				where	nr_sequencia	= nr_seq_procedimento_w;

				if (ie_tipo_valor_w = '4') and (vl_beneficiario_w = 0) then
					vl_beneficiario_w	:= vl_apresentado_w;
				elsif (ie_tipo_valor_w = '5') and (vl_beneficiario_w = 0) then
					vl_beneficiario_w	:= vl_liberado_w;
				end if;
			end if;

			if (ie_tipo_conta_w in ('I','C')) then
				SELECT * FROM pls_obter_tx_fat_intercambio(nr_seq_conta_p, nm_usuario_p, cd_estabelecimento_w, tx_intercambio_w, nr_seq_regra_inter_w) INTO STRICT tx_intercambio_w, nr_seq_regra_inter_w;
				vl_beneficiario_w	:= vl_beneficiario_w + (vl_beneficiario_w * tx_intercambio_w);
			end if;

			select	coalesce(max(vl_custo_operacional),0),
				coalesce(max(vl_materiais),0),
				coalesce(max(vl_beneficiario),0),
				coalesce(max(vl_procedimento),0)
			into STRICT	vl_custo_operacional_w,
				vl_materiais_w,
				vl_benef_proc_w,
				vl_calculado_w
			from	pls_conta_proc
			where	nr_sequencia	= nr_seq_procedimento_w;

			if (vl_custo_operacional_w > 0) then
				vl_resultado_w		:= (vl_benef_proc_w * vl_custo_operacional_w);
				vl_custo_operacional_w	:= dividir_sem_round(vl_resultado_w,vl_calculado_w);
			end if;

			vl_resultado_w	:= 0;

			if (vl_materiais_w > 0) then
				vl_resultado_w	:= (vl_benef_proc_w * vl_materiais_w);
				vl_materiais_w	:= dividir_sem_round(vl_resultado_w,vl_calculado_w);
			end if;

			select	max(nr_seq_regra_pos_estab)
			into STRICT	nr_seq_regra_pos_estab_w
			from	pls_conta_proc
			where	nr_sequencia = nr_seq_procedimento_w;

			select	nextval('pls_conta_pos_estabelecido_seq')
			into STRICT	nr_seq_pos_estab_w
			;

			insert into pls_conta_pos_estabelecido(nr_sequencia, nr_seq_conta, vl_beneficiario,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, nr_seq_conta_proc, nr_seq_conta_mat,
				ie_calcula_preco_benef, ie_preco_plano, nr_seq_regra_pos_estab,
				ie_cobrar_mensalidade, nr_seq_sca, vl_provisao,
				ie_status_faturamento,vl_custo_operacional,vl_materiais,
				tx_administracao,vl_administracao,qt_item,
				ie_origem_valor_pos,
				cd_procedimento, ie_origem_proced, dt_item,
				dt_inicio_item, dt_fim_item, vl_tabela_preco,
				vl_cotacao_moeda, cd_moeda_calculo, vl_custo_operacional_tab,
				qt_filme_tab, ie_situacao, vl_material_tab,
				ie_tipo_guia, ie_tipo_protocolo, nr_seq_segurado,
				ie_tipo_segurado, dt_mes_competencia, nr_seq_protocolo,
				nr_seq_prestador_atend, nr_seq_prestador_exec, ie_tipo_prestador_atend,
				ie_tipo_prestador_exec, nr_seq_regra_tp_pos)
			values (	nr_seq_pos_estab_w, nr_seq_conta_p, vl_beneficiario_w,
				clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, nr_seq_procedimento_w, null,
				ie_calcula_preco_benef_w, ie_preco_plano_w, nr_seq_regra_pos_estab_w,
				ie_cobrar_mensalidade_w, nr_seq_sca_w, coalesce(vl_provisao_w,vl_beneficiario_w),
				'U',vl_custo_operacional_w,vl_materiais_w,
				coalesce(tx_administrativa_w,0),coalesce(vl_administrativa_w,0),qt_procedimento_w,
				ie_origem_valor_pos_p,
				cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w,
				dt_inicio_item_w, dt_fim_item_w, dados_regra_preco_proc_w.vl_proc_tabela,
				dados_regra_preco_proc_w.vl_ch_honorarios, dados_regra_preco_proc_w.cd_moeda_autogerado, dados_regra_preco_proc_w.vl_custo_operacional_tab,
				dados_regra_preco_proc_w.qt_filme_tab, 'A', dados_regra_preco_proc_w.vl_base_filme,
				ie_tipo_guia_w, ie_tipo_protocolo_w, nr_seq_segurado_w,
				ie_tipo_segurado_w, dt_mes_competencia_w, nr_seq_protocolo_w,
				nr_seq_prestador_prot_w, nr_seq_prestador_exec_w, ie_tipo_prestador_atend_w,
				ie_tipo_prestador_exec_w, nr_seq_regra_w);

			-- Gerar os participantes do procedimento referente ao pós-estabelecido
			CALL pls_gerar_conta_pos_estab_part(nr_seq_pos_estab_w,'N',nm_usuario_p);

			update	pls_conta_proc
			set	vl_beneficiario		= coalesce(vl_beneficiario_w,0),
				ie_co_preco_operadora	= ie_calcula_preco_benef_w
			where	nr_sequencia		= nr_seq_procedimento_w;

			<<final>>
			null; /* Deve existir uma linha após o <<Final>> */
			end;
		end loop;
		close C02;

		/* MATERIAIS */

		open C03;
		loop
		fetch C03 into
			nr_seq_material_w,
			ie_tipo_despesa_w,
			vl_material_w,
			dt_atendimento_w,
			vl_provisao_w,
			nr_seq_regra_pos_estab_w,
			qt_material_w,
			vl_liberado_w,
			vl_apresentado_w,
			dt_inicio_item_w,
			dt_fim_item_w,
			ie_tipo_despesa_mat_w,
			vl_glosa_w,
			nr_seq_prest_Inter_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			dados_conta_pos_w.cd_area_procedimento	:= null;
			dados_conta_pos_w.cd_especialidade	:= null;
			dados_conta_pos_w.cd_grupo_proc		:= null;

			if (ie_cobranca_pos_w = 'S') and (dt_atendimento_w <= dt_rescisao_w) then
				goto final2;
			end if;

			if (ie_calculo_pos_estab_w = 'C') then
				if (ie_calcula_preco_benef_w = 'N') and (ie_preco_plano_w in ('2','3')) then
					vl_beneficiario_w	:= vl_material_w;
				end if;
			elsif (ie_calculo_pos_estab_w = 'R') then
				dados_conta_pos_w.nr_seq_segurado	:= nr_seq_segurado_w;
				dados_conta_pos_w.dt_referencia		:= dt_atendimento_w;
				dados_conta_pos_w.ie_origem_conta	:= ie_origem_conta_w;
				dados_conta_pos_w.ie_apresentacao_prot	:= ie_apresentacao_prot_w;
				dados_conta_pos_w.ie_tipo_desp_mat	:= ie_tipo_despesa_mat_w;
				dados_conta_pos_w.nr_seq_prestador_prot	:= nr_seq_prestador_prot_w;

				dados_conta_pos_w.cd_procedimento	:= null;
				dados_conta_pos_w.ie_origem_proced	:= null;
				dados_conta_pos_w.nr_seq_prestador_exec	:= nr_seq_prestador_exec_w;
				dados_conta_pos_w.ie_tipo_intercambio	:= coalesce(pls_obter_tipo_intercambio(coalesce(nr_seq_ops_congenere_w,nr_seq_congenere_w),cd_estabelecimento_w),'A');
				dados_conta_pos_w.ie_origem_protocolo	:= ie_origem_protocolo_w;
				dados_conta_pos_w.ie_tipo_congenere	:= coalesce(pls_obter_dados_cooperativa(coalesce(nr_seq_ops_congenere_w,nr_seq_congenere_w),'IT'),'A');
				dados_conta_pos_w.nr_seq_prest_inter :=  nr_seq_prest_Inter_w;

				dados_regra_preco_pos_estab_w := pls_obter_tipo_valor_pos_estab(	dados_conta_pos_w, nm_usuario_p, cd_estabelecimento_w, dados_regra_preco_pos_estab_w);

				nr_seq_regra_w		:= dados_regra_preco_pos_estab_w.nr_sequencia;
				ie_tipo_valor_w		:= dados_regra_preco_pos_estab_w.ie_tipo_valor;

				-- se a regra que retornou diz que não é para aplicar a taxa, então seta a variável para zero
				if (coalesce(dados_regra_preco_pos_estab_w.ie_nao_gera_tx_inter, 'N') = 'S') then

					tx_intercambio_w := 0;
				end if;

				if (ie_tipo_valor_w = '1') then
					ie_calcula_preco_benef_w := 'S';

				elsif (ie_tipo_valor_w = '2') then
					vl_beneficiario_w	:= vl_apresentado_w;
					ie_calcula_preco_benef_w := 'N';

				elsif (ie_tipo_valor_w = '3') then
					if (coalesce(vl_liberado_w,0) > 0) then
						vl_beneficiario_w	:= vl_liberado_w;
					else
						vl_beneficiario_w	:= vl_material_w;
					end if;
					ie_calcula_preco_benef_w := 'N';

				elsif (ie_tipo_valor_w = '4') then
					ie_calcula_preco_benef_w := 'S';

				elsif (ie_tipo_valor_w = '5') then
					ie_calcula_preco_benef_w := 'S';

				elsif (ie_tipo_valor_w = '7') then
					vl_beneficiario_w	 := vl_apresentado_w;
					ie_calcula_preco_benef_w := 'N';

				elsif (ie_tipo_valor_w = '8') then
					vl_beneficiario_w	 := vl_liberado_w;
					ie_calcula_preco_benef_w := 'N';
				end if;

			elsif (ie_calculo_pos_estab_w = 'P') then
				vl_beneficiario_w		:= vl_material_w;
				ie_calcula_preco_benef_w 	:= 'N';
			elsif ( ie_calculo_pos_estab_w = 'O') then
				ie_calcula_preco_benef_w	:= 'S';
			end if;

			if (ie_calcula_preco_benef_w = 'S') then
				dados_regra_preco_material_w := pls_atualiza_valor_mat_co(nr_seq_material_w, 'N', ie_pos_estab_faturamento_p, ie_geracao_pos_estabelecido_p, nm_usuario_p, dados_regra_preco_material_w);

				select	coalesce(max(vl_beneficiario),0)
				into STRICT	vl_beneficiario_w
				from	pls_conta_mat
				where	nr_sequencia	= nr_seq_material_w;

				if (ie_tipo_valor_w = '4') and (vl_beneficiario_w = 0) then
					vl_beneficiario_w	:= vl_apresentado_w;
				elsif (ie_tipo_valor_w = '5') and (vl_beneficiario_w = 0) then
					vl_beneficiario_w	:= vl_liberado_w;
				end if;
			elsif (ie_preco_plano_w in ('2','3')) then
				vl_beneficiario_w	:= vl_material_w;
			end if;

			if (ie_tipo_conta_w in ('I','C')) then
				SELECT * FROM pls_obter_tx_fat_intercambio(nr_seq_conta_p, nm_usuario_p, cd_estabelecimento_w, tx_intercambio_w, nr_seq_regra_inter_w) INTO STRICT tx_intercambio_w, nr_seq_regra_inter_w;
				vl_beneficiario_w	:= vl_beneficiario_w + (vl_beneficiario_w * tx_intercambio_w);
			end if;

			select	max(nr_seq_regra_pos_estab)
			into STRICT	nr_seq_regra_pos_estab_w
			from	pls_conta_mat
			where	nr_sequencia = nr_seq_material_w;

			--if	(nvl(vl_beneficiario_w,0) > 0) then
			insert into pls_conta_pos_estabelecido(nr_sequencia, nr_seq_conta, vl_beneficiario,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, nr_seq_conta_proc, nr_seq_conta_mat,
				ie_calcula_preco_benef, ie_preco_plano, nr_seq_regra_pos_estab,
				ie_cobrar_mensalidade, nr_seq_sca, vl_provisao,
				ie_status_faturamento,qt_item,ie_origem_valor_pos,
				nr_seq_material, dt_item, dt_inicio_item, dt_fim_item,
				vl_tabela_preco, vl_cotacao_moeda, cd_moeda_calculo,
				ie_situacao, ie_tipo_guia, ie_tipo_protocolo,
				nr_seq_segurado, ie_tipo_segurado, dt_mes_competencia,
				nr_seq_protocolo, nr_seq_prestador_atend, nr_seq_prestador_exec,
				ie_tipo_prestador_atend, ie_tipo_prestador_exec, nr_seq_regra_tp_pos)
			values (	nextval('pls_conta_pos_estabelecido_seq'), nr_seq_conta_p, vl_beneficiario_w,
				clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, null, nr_seq_material_w,
				ie_calcula_preco_benef_w, ie_preco_plano_w, nr_seq_regra_pos_estab_w,
				ie_cobrar_mensalidade_w, nr_seq_sca_w, coalesce(vl_provisao_w,vl_beneficiario_w),
				'U',qt_material_w, ie_origem_valor_pos_p,
				nr_seq_material_w, dt_atendimento_w, dt_inicio_item_w, dt_fim_item_w,
				dados_regra_preco_material_w.vl_material_tabela, dados_regra_preco_material_w.vl_ch_material, dados_regra_preco_material_w.cd_moeda_calculo,
				'A', ie_tipo_guia_w, ie_tipo_protocolo_w,
				nr_seq_segurado_w, ie_tipo_segurado_w, dt_mes_competencia_w,
				nr_seq_protocolo_w, nr_seq_prestador_prot_w, nr_seq_prestador_exec_w,
				ie_tipo_prestador_atend_w, ie_tipo_prestador_exec_w, nr_seq_regra_w);
			--end if;
			update	pls_conta_mat
			set	vl_beneficiario		= coalesce(vl_beneficiario_w,0),
				ie_co_preco_operadora	= ie_calcula_preco_benef_w
			where	nr_sequencia		= nr_seq_material_w;

			<<final2>>
			null;
			end;
		end loop;
		close C03;

		select 	sum(vl_beneficiario)
		into STRICT	vl_tot_beneficiario_w
		from	pls_conta_pos_estabelecido
		where	nr_seq_conta	= nr_seq_conta_p
		and	((ie_situacao	= 'A') or (coalesce(ie_situacao::text, '') = ''));

		if (coalesce(nr_seq_regra_inter_w,0) <> 0) then
			vl_tot_beneficiario_w	:= tx_intercambio_w;
		end if;

		if (vl_tot_beneficiario_w > 0) then
			update	pls_conta
			set	vl_total_beneficiario	= vl_tot_beneficiario_w
			where	nr_sequencia		= nr_seq_conta_p;
		end if;

		--Não é para commit em procedures intermediarias
		--commit;
	end if;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_valor_pos_estab_sca (nr_seq_conta_p bigint, ie_pos_estab_faturamento_p pls_parametros.ie_pos_estab_faturamento%type, ie_geracao_pos_estabelecido_p pls_parametros.ie_geracao_pos_estabelecido%type, nm_usuario_p text, ie_origem_valor_pos_p text) FROM PUBLIC;

