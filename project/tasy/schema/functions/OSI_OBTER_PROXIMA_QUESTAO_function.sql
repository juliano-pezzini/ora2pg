-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION osi_obter_proxima_questao ( nr_OS_p bigint, cd_cgc_cliente_p text, ie_curva_cliente_p text) RETURNS bigint AS $body$
DECLARE

/* O retorno desta OS é o nr_sequencia da tabela MODELO_CONTEUDO_OS */

nr_seq_modelo_conteudo_os_w	modelo_conteudo_os.nr_sequencia%type;
ie_classificacao_w		man_ordem_servico.ie_classificacao%type;
cd_funcao_w			man_ordem_servico.cd_funcao%type;
nr_seq_osi_regra_resultado_w	osi_regra_resultado.nr_sequencia%type;
qt_respostas_w			bigint;
qt_total_questoes_regra_w	bigint;
qt_total_questoes_atendidas_w	bigint;
qt_total_questoes_respondid_w	bigint;
pr_respondida_w			double precision := 0;
pr_maior_respondida_w		double precision := 0;
nr_seq_maior_respondida_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	osi_regra_resultado
	where	coalesce(ie_situacao,'A') = 'A'
	order by nr_sequencia;


BEGIN

select	max(ie_classificacao),
	max(cd_funcao)
into STRICT	ie_classificacao_w,
	cd_funcao_w
from	man_ordem_servico
where	nr_sequencia = nr_OS_p;

select	count(1)
into STRICT	qt_respostas_w
from	osi_questao_os
where	nr_seq_ordem = nr_OS_p;

if (qt_respostas_w > 0) then
	open C01;
	loop
	fetch C01 into
		nr_seq_osi_regra_resultado_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	count(1)
		into STRICT	qt_total_questoes_regra_w
		from	osi_regra_resultado_item
		where	nr_seq_osi_regra_resultado =  nr_seq_osi_regra_resultado_w
		and	coalesce(ie_situacao,'A') = 'A';

		select	count(1)
		into STRICT	qt_total_questoes_atendidas_w
		from	osi_regra_resultado_item a
		where	a.nr_seq_osi_regra_resultado =  nr_seq_osi_regra_resultado_w
		and	coalesce(ie_situacao,'A') = 'A'
		and exists (	SELECT	1
				from	pergunta_result_os pr,
					pergunta_os p,
					modelo_conteudo_os mc,
					osi_questao_os qo,
					osi_questao_os_respostas qor
				where	p.nr_sequencia = mc.nr_seq_pergunta
				and	mc.nr_sequencia = qo.nr_seq_modelo_conteudo_os
				and	p.nr_sequencia = pr.nr_seq_pergunta
				and	qo.nr_sequencia = qor.nr_seq_osi_questao_os
				and	pr.nr_sequencia = qor.nr_seq_pergunta_result_os
				and	p.nr_sequencia = a.nr_seq_pergunta
				and	pr.nr_sequencia = a.nr_seq_pergunta_result_os
				and	qo.nr_seq_ordem = nr_OS_p);

		select	count(1)
		into STRICT	qt_total_questoes_respondid_w
		from	osi_regra_resultado_item a
		where	a.nr_seq_osi_regra_resultado =  nr_seq_osi_regra_resultado_w
		and	coalesce(a.ie_situacao,'A') = 'A'
		and exists (	SELECT	1
				from	pergunta_os p,
					modelo_conteudo_os mc,
					osi_questao_os qo
				where	p.nr_sequencia = mc.nr_seq_pergunta
				and	mc.nr_sequencia = qo.nr_seq_modelo_conteudo_os
				and	p.nr_sequencia = a.nr_seq_pergunta
				and	qo.nr_seq_ordem = nr_OS_p);

		if (qt_total_questoes_atendidas_w > 0) then
			pr_respondida_w := ((qt_total_questoes_atendidas_w * 100) / qt_total_questoes_regra_w);
		end if;

		if (pr_respondida_w > pr_maior_respondida_w) then
			pr_maior_respondida_w		:= pr_respondida_w;
			nr_seq_maior_respondida_w	:= nr_seq_osi_regra_resultado_w;
		end if;

		end;
	end loop;
	close C01;

	if (nr_seq_maior_respondida_w IS NOT NULL AND nr_seq_maior_respondida_w::text <> '') and (pr_maior_respondida_w = 100) then
		CALL osi_definir_classif_os(nr_OS_p, nr_seq_maior_respondida_w);
	end if;
end if;

-- verifica se há uma pergunta filha da questão que acabou de ser respondida
select	max(mc.nr_sequencia)
into STRICT	nr_seq_modelo_conteudo_os_w
from	modelo_conteudo_os mc
where	coalesce(mc.ie_situacao,'A') = 'A'
and	mc.nr_seq_pergunta_sup = (	SELECT	max(qo.nr_seq_modelo_conteudo_os) -- traz o nr_seq_modelo_conteudo_os da última questão respondida na OS
					from	osi_questao_os qo
					where	qo.nr_sequencia = (	select	max(nr_sequencia)
									from	osi_questao_os
									where	nr_seq_ordem = nr_OS_p))
and (coalesce(mc.nr_seq_pergunta_result_os::text, '') = '' or
	 mc.nr_seq_pergunta_result_os in (	select	qos.nr_seq_pergunta_result_os
						from	osi_questao_os_respostas qos,
							osi_questao_os qo
						where	qo.nr_sequencia = qos.nr_seq_osi_questao_os
						and	qo.nr_seq_ordem = nr_OS_p));

-- caso não houver pergunta filha, traz a próxima conforme o cácula realizado acima (utilizando a variável nr_seq_maior_respondida_w)
if (coalesce(nr_seq_modelo_conteudo_os_w::text, '') = '') then
	-- O SQL abaixo traz apenas o primeiro registro considerando o order by!
	select	max(nr_sequencia)
	into STRICT	nr_seq_modelo_conteudo_os_w
	from(	SELECT	mc.nr_sequencia,
			row_number() over (order by coalesce(mo.nr_seq_apres,999), coalesce(mc.nr_seq_apres,999)) as row_id_pagina
		FROM modelo_conteudo_os mc, modelo_os mo
LEFT OUTER JOIN modelo_os_filtro mof ON (mo.nr_sequencia = mof.nr_seq_modelo_os)
WHERE mc.nr_seq_modelo 	= mo.nr_sequencia  and coalesce(mc.ie_situacao,'A')		= 'A' and coalesce(mo.ie_situacao,'A')		= 'A' and coalesce(mof.ie_situacao,'A')	= 'A' and (coalesce(ie_classificacao_w::text, '') = '' or coalesce(mof.ie_classificacao, 	ie_classificacao_w) 	= ie_classificacao_w) and (coalesce(cd_funcao_w::text, '') = '' or coalesce(mof.cd_funcao, 		cd_funcao_w) 		= cd_funcao_w) and (coalesce(cd_cgc_cliente_p::text, '') = '' or coalesce(mof.cd_cgc_cliente, 	cd_cgc_cliente_p) 	= cd_cgc_cliente_p) and (coalesce(ie_curva_cliente_p::text, '') = '' or coalesce(mof.ie_curva_cliente,	ie_curva_cliente_p)	= ie_curva_cliente_p) -- faz com que retorne apenas questões que não são dependentes de outras questões (apenas questões pais)
  and coalesce(mc.nr_seq_pergunta_sup::text, '') = '' -- não retorna perguntas que já foram respondidas nesta OS
  and not exists (	select	1
					from	osi_questao_os osi,
						modelo_conteudo_os mc_osi
					where	osi.nr_seq_ordem = nr_OS_p
					and	osi.nr_seq_modelo_conteudo_os = mc_osi.nr_sequencia
					and	mc_osi.nr_seq_pergunta = mc.nr_seq_pergunta) -- faz com que traga apenas perguntas que contenham registros na tabela de respostas (para que o questionário não fique "travado" sem botões na tela)
  and exists (		SELECT	1
					from	pergunta_os p,
						pergunta_result_os pr
					where	pr.nr_seq_pergunta = p.nr_sequencia
					and	p.nr_sequencia = mc.nr_seq_pergunta) -- caso tenha encontrado uma regra no início desta funcion (nr_seq_maior_respondida_w), somente retornará questões desta regra
  and ((coalesce(nr_seq_maior_respondida_w::text, '') = '') or (exists (	select	1
					from	osi_regra_resultado_item orri
					where	orri.nr_seq_pergunta = mc.nr_seq_pergunta
					and	orri.nr_seq_osi_regra_resultado = nr_seq_maior_respondida_w)))
		 )
	where	row_id_pagina = 1;
end if;

return	nr_seq_modelo_conteudo_os_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION osi_obter_proxima_questao ( nr_OS_p bigint, cd_cgc_cliente_p text, ie_curva_cliente_p text) FROM PUBLIC;
