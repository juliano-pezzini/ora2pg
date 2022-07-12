-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_evento_inside_per (nr_seq_periodo_p pls_periodo_pagamento.nr_sequencia%type, nr_seq_evento_p pls_evento.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, dt_competencia_p timestamp, dt_movimento_p timestamp) RETURNS PLS_EVENTO_REGRA.IE_INCIDE_PERIODO%TYPE AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- caso não encontre nenhuma regra válida então o retorno é Não
ie_retorno_w	pls_evento_regra.ie_incide_periodo%type	:= 'N';

/*  Edgar, 23/05/2014, Visita à Litoral (Sem OS),  MUITO CUIDADO AO INCLUIR RESTRIÇÕES DO ALIAS "B", VERIFIQUEM QUE ELE TEM OUTERJOIN E NECESSITA DE TRATAMENTO DE NVL */

C01 CURSOR(	nr_seq_periodo_pc	pls_periodo_pagamento.nr_sequencia%type,
		nr_seq_evento_pc	pls_evento.nr_sequencia%type,
		nr_seq_prestador_pc	pls_prestador.nr_sequencia%type,
		dt_mes_competencia_pc	timestamp,
		dt_movimento_pc		timestamp) FOR
	SELECT	coalesce(b.ie_incide_periodo,'S') ie_incide_periodo
	FROM pls_evento c
LEFT OUTER JOIN pls_evento_regra b ON (c.nr_sequencia = b.nr_seq_evento)
WHERE c.nr_sequencia = nr_seq_evento_pc and ((coalesce(b.ie_tipo_evento,'N') = 'N') or (c.ie_tipo_evento = b.ie_tipo_evento))  and ((coalesce(c.ie_consiste_periodo_pag, 'S') = 'N') or (b.nr_seq_evento IS NOT NULL AND b.nr_seq_evento::text <> '')) and trunc(dt_movimento_pc,'month') >= trunc(add_months(dt_mes_competencia_pc, - coalesce(b.qt_mes_deslocamento,0)),'month') and trunc(dt_movimento_pc,'month') <= trunc(add_months(dt_mes_competencia_pc, - coalesce(b.qt_mes_desloc_final,0)),'month') and ((coalesce(b.nr_seq_prestador::text, '') = '') or (b.nr_seq_prestador = coalesce(nr_seq_prestador_pc,0))) /*and	((b.nr_seq_classif_prestador is null) or
		(exists		(select	1
				from	pls_prestador x
				where	x.nr_sequencia		= nr_seq_prestador_pc
				and	x.nr_seq_classificacao	= b.nr_seq_classif_prestador)))*/
	-- OS 1305525 - jtonon - O tratamento acima foi substituído pelo tratamento abaixo visto que a regra estava com o campo 'nr_seq_classif_prestador' nulo e mesmo assim o select não trazia o mesmo
  and ((coalesce(b.nr_seq_classif_prestador::text, '') = '') or ((	SELECT	count(1)
								from	pls_prestador 		x
								where	x.nr_sequencia		= nr_seq_prestador_pc
								and	x.nr_seq_classificacao	= b.nr_seq_classif_prestador) > 0)) and ((coalesce(b.nr_seq_tipo_prestador::text, '') = '') or (exists (select	1
				from	pls_prestador_tipo	x
				where	x.nr_seq_prestador	= nr_seq_prestador_pc
				and	x.nr_seq_tipo		= b.nr_seq_tipo_prestador
				and	clock_timestamp() between coalesce(x.dt_inicio_vigencia, clock_timestamp() - interval '1 days') and coalesce(x.dt_fim_vigencia, clock_timestamp() + interval '1 days')
				
union

				select	1
				from	pls_prestador		y
				where	y.nr_sequencia		= nr_seq_prestador_pc
				and	y.nr_seq_tipo_prestador = b.nr_seq_tipo_prestador))) and (coalesce(b.cd_condicao_pagamento::text, '') = '' or
		exists (select	1
			from	pls_prestador_pagto	y,
				pls_prestador		x
			where	x.nr_sequencia		= y.nr_seq_prestador
			and	x.nr_sequencia		= nr_seq_prestador_pc
			and	y.cd_condicao_pagamento = b.cd_condicao_pagamento)) --and	trunc(a.dt_movimento) between trunc(nvl(dt_inicio_comp_w,a.dt_movimento)) and trunc(nvl(dt_fim_comp_w,a.dt_movimento))
  and coalesce(b.nr_seq_periodo,nr_seq_periodo_pc)  = nr_seq_periodo_pc and coalesce(b.ie_situacao, 'A')	= 'A' and dt_mes_competencia_pc between trunc(coalesce(b.dt_inicio_vigencia, dt_mes_competencia_pc), 'month') and trunc(coalesce(b.dt_fim_vigencia, dt_mes_competencia_pc),'month') -- regra de exceção de período
  and not exists (	select	1
			from 	pls_evento_regra_ex ex
			where	ex.nr_seq_periodo = nr_seq_periodo_pc
			and	ex.nr_seq_prestador = nr_seq_prestador_pc);

BEGIN
if (nr_seq_periodo_p IS NOT NULL AND nr_seq_periodo_p::text <> '') and (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') and (dt_competencia_p IS NOT NULL AND dt_competencia_p::text <> '') then

	for r_C01 in C01(	nr_seq_periodo_p, nr_seq_evento_p, nr_seq_prestador_p,
				dt_competencia_p, dt_movimento_p) loop

		ie_retorno_w := r_C01.ie_incide_periodo;
	end loop;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_evento_inside_per (nr_seq_periodo_p pls_periodo_pagamento.nr_sequencia%type, nr_seq_evento_p pls_evento.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, dt_competencia_p timestamp, dt_movimento_p timestamp) FROM PUBLIC;
