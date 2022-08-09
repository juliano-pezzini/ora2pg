-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_repasse_conta ( nr_interno_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Gerar itens de repasses a partir dos valores das contas. Somente se baseia no valor da conta
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [] Tasy (Delphi/Java) [  ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
 - Rotina executada através dos objetos GERAR_CONTA_PACIENTE_REPASSE
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/tx_repasse_w		double precision;
vl_total_conta_w	double precision;
vl_repasse_w		double precision;
ds_observacao_w		varchar(4000);
ie_status_acerto_w	smallint;
cont_rep_item_w		bigint;
cont_rep_item_vinc_w	bigint;
nr_atendimento_w	bigint;
nm_paciente_w		varchar(255);

--Variáveis para controle dos filtros SUS_AIH_UNIF
ie_complexidade_w	sus_aih_unif.ie_complexidade%type;
ie_tipo_financiamento_w sus_aih_unif.ie_tipo_financiamento%type;
ie_gera_repasse_w	varchar(1);

--Obtém todas as regras para o estabelecimento
c_regra_rep_conpaci CURSOR(cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
SELECT	a.nr_sequencia,
	a.nr_seq_terceiro,
	a.tx_repasse,
	a.dt_inicio_vigencia,
	a.dt_fim_vigencia,
	a.cd_convenio,
	a.ie_tipo_convenio,
	a.ie_tipo_atendimento,
	a.ie_complexidade,
	a.ie_tipo_financiamento,
	a.vl_fixo
from	REGRA_REPASSE_CONPACI a
where	a.cd_estabelecimento	= cd_estabelecimento_pc;

BEGIN

vl_total_conta_w	:= 0;
tx_repasse_w		:= 0;

--Retorna todas as regras encontradas para o estabelecimento.
for r_c_regra_rep_conpaci in c_regra_rep_conpaci(cd_estabelecimento_p) loop

	tx_repasse_w	:= r_c_regra_rep_conpaci.tx_repasse;
	vl_repasse_w	:= 0;
	ds_observacao_w	:= '';

	--Obtém as contas que se encaixam dentro de uma regra
	select	coalesce(sum(vl_conta),0),
		max(a.nr_atendimento),
		max(substr(obter_nome_pf_pj(b.cd_pessoa_fisica,null),1,255))
	into STRICT	vl_total_conta_w,
		nr_atendimento_w,
		nm_paciente_w
	from	convenio c,
		atendimento_paciente b,
		conta_paciente a
	where	a.nr_atendimento	= b.nr_atendimento
	and	a.cd_convenio_parametro	= c.cd_convenio
	and	a.nr_interno_conta	= nr_interno_conta_p
	and	a.dt_conta_definitiva	between coalesce(r_c_regra_rep_conpaci.dt_inicio_vigencia,a.dt_conta_definitiva) and fim_dia(coalesce(r_c_regra_rep_conpaci.dt_fim_vigencia,a.dt_conta_definitiva))
	and	c.cd_convenio		= coalesce(r_c_regra_rep_conpaci.cd_convenio,c.cd_convenio)
	and	c.ie_tipo_convenio	= coalesce(r_c_regra_rep_conpaci.ie_tipo_convenio,c.ie_tipo_convenio)
	and	b.ie_tipo_atendimento	= coalesce(r_c_regra_rep_conpaci.ie_tipo_atendimento,b.ie_tipo_atendimento);

	--ds_observacao_w	:= ('Item de repasse gerado a partir do atendimento: '||nr_atendimento_w||', conta: '||nr_interno_conta_p||', Paciente: '||nm_paciente_w||'.');
	ds_observacao_w	:= WHEB_MENSAGEM_PCK.get_texto(457791,'nr_atendimento_w='|| nr_atendimento_w ||';nr_interno_conta_p='|| nr_interno_conta_p||';nm_paciente_w='|| nm_paciente_w);

	ie_gera_repasse_w := 'S';

	--Verifica os filtros do SUS_AIH_UNIF, se informados na regra.
	if	((r_c_regra_rep_conpaci.ie_complexidade IS NOT NULL AND r_c_regra_rep_conpaci.ie_complexidade::text <> '') or (r_c_regra_rep_conpaci.ie_tipo_financiamento IS NOT NULL AND r_c_regra_rep_conpaci.ie_tipo_financiamento::text <> '')) then

		select	max(ie_complexidade),
			max(ie_tipo_financiamento)
		into STRICT	ie_complexidade_w,
			ie_tipo_financiamento_w
		from	sus_aih_unif
		where	nr_interno_conta = nr_interno_conta_p;

		if	((coalesce(ie_complexidade_w::text, '') = '') or
			((ie_complexidade_w IS NOT NULL AND ie_complexidade_w::text <> '') and (r_c_regra_rep_conpaci.ie_complexidade IS NOT NULL AND r_c_regra_rep_conpaci.ie_complexidade::text <> '') and (ie_complexidade_w <> r_c_regra_rep_conpaci.ie_complexidade))) then
			ie_gera_repasse_w := 'N';
		end if;

		if	((coalesce(ie_tipo_financiamento_w::text, '') = '') or
			((ie_tipo_financiamento_w IS NOT NULL AND ie_tipo_financiamento_w::text <> '') and (r_c_regra_rep_conpaci.ie_tipo_financiamento IS NOT NULL AND r_c_regra_rep_conpaci.ie_tipo_financiamento::text <> '') and (ie_tipo_financiamento_w <> r_c_regra_rep_conpaci.ie_tipo_financiamento))) then
			ie_gera_repasse_w := 'N';
		end if;

	end if;

	--Se o valor total da conta não estiver zerado, se a taxa de repasse não estiver zerado e se o registro for válido
	--Calcula o valor do repasse e insere como item de repasse.
	if (coalesce(vl_total_conta_w,0) <> 0) and (coalesce(tx_repasse_w,0) <> 0) then

		vl_repasse_w	:= dividir_sem_round((vl_total_conta_w * tx_repasse_w)::numeric,100);
	end if;

	--Se possuir valor fixo informado, calcular também.
	--O valor Fixo deve ser somado ao vlaor de repasse caso já tenha sido calculado pela taxa de repasse informada na regra.
	if (coalesce(r_c_regra_rep_conpaci.vl_fixo,0) <> 0) then

		vl_repasse_w	:= vl_repasse_w + r_c_regra_rep_conpaci.vl_fixo;
	end if;

	if (coalesce(vl_repasse_w,0) <> 0) and (ie_gera_repasse_w = 'S') then



		insert	into repasse_terceiro_item(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					vl_repasse,
					nr_seq_terceiro,
					ds_observacao,
					dt_lancamento,
					nr_interno_conta,
					nr_atendimento)
			values (		nextval('repasse_terceiro_item_seq'),
					nm_usuario_p,
					clock_timestamp(),
					vl_repasse_w,
					r_c_regra_rep_conpaci.nr_seq_terceiro,
					ds_observacao_w,
					clock_timestamp(),
					nr_interno_conta_p,
					nr_atendimento_w);
	end if;

--Fim do cursor r_c_regra_rep_conpaci
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_repasse_conta ( nr_interno_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
