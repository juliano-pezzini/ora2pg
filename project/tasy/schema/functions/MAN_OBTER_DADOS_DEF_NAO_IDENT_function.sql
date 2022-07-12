-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_dados_def_nao_ident ( dt_ano_p timestamp, nr_seq_grupo_des_p bigint, cd_funcao_p bigint, nr_grupo_trabalho_p bigint, nr_seq_localizacao_p bigint, nr_seq_gerencia_p bigint, nr_seq_motivo_p bigint, ie_mes_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
OPÇÕES:
T - Total por motivo
P - Percentual por motivo
*/
qt_motivo_w		bigint;
qt_mes_w		bigint;
qt_retorno_w		double precision;


BEGIN

select	sum(CASE WHEN substr(to_char(b.dt_liberacao,'dd/mm/yyyy'),4,2)=ie_mes_p THEN count(*)  ELSE 0 END )
into STRICT	qt_motivo_w
from	man_ordem_servico a,
	man_doc_erro b,
	des_motivo_erro_teste c
where	a.nr_sequencia = b.nr_seq_ordem
and	b.nr_seq_motivo_testes = c.nr_sequencia
and	(b.nr_seq_motivo_testes IS NOT NULL AND b.nr_seq_motivo_testes::text <> '')
and	b.ie_origem_erro = 'W'
and	trunc(b.dt_liberacao,'yyyy') = dt_ano_p
and	((coalesce(nr_seq_grupo_des_p,0) = 0) or (b.nr_seq_grupo_des = coalesce(nr_seq_grupo_des_p,0)))
and	((coalesce(cd_funcao_p,0) = 0) or (a.cd_funcao = coalesce(cd_funcao_p,0)))
and	((coalesce(nr_grupo_trabalho_p,0) = 0) or (a.nr_grupo_trabalho = coalesce(nr_grupo_trabalho_p,0)))
and	((coalesce(nr_seq_localizacao_p,0) = 0) or (a.nr_seq_localizacao = coalesce(nr_seq_localizacao_p,0)))
and	((coalesce(nr_seq_gerencia_p,0) = 0) or (Obter_Gerencia_grupo_desen(b.nr_seq_grupo_des,'C') = coalesce(nr_seq_gerencia_p,0)))
and	((coalesce(nr_seq_motivo_p,0) = 0) or (c.nr_sequencia = coalesce(nr_seq_motivo_p,0)))
group by	substr(to_char(b.dt_liberacao,'dd/mm/yyyy'),4,2);

qt_retorno_w := qt_motivo_w;

if (ie_opcao_p = 'P') then
	begin
	select	sum(CASE WHEN substr(to_char(b.dt_liberacao,'dd/mm/yyyy'),4,2)=ie_mes_p THEN count(*)  ELSE 0 END )
	into STRICT	qt_mes_w
	from	man_ordem_servico a,
		man_doc_erro b,
		des_motivo_erro_teste c
	where	a.nr_sequencia = b.nr_seq_ordem
	and	b.nr_seq_motivo_testes = c.nr_sequencia
	and	(b.nr_seq_motivo_testes IS NOT NULL AND b.nr_seq_motivo_testes::text <> '')
	and	b.ie_origem_erro = 'W'
	and	trunc(b.dt_liberacao,'yyyy') = dt_ano_p
	and	((coalesce(nr_seq_grupo_des_p,0) = 0) or (b.nr_seq_grupo_des = coalesce(nr_seq_grupo_des_p,0)))
	and	((coalesce(cd_funcao_p,0) = 0) or (a.cd_funcao = coalesce(cd_funcao_p,0)))
	and	((coalesce(nr_grupo_trabalho_p,0) = 0) or (a.nr_grupo_trabalho = coalesce(nr_grupo_trabalho_p,0)))
	and	((coalesce(nr_seq_localizacao_p,0) = 0) or (a.nr_seq_localizacao = coalesce(nr_seq_localizacao_p,0)))
	and	((coalesce(nr_seq_gerencia_p,0) = 0) or (Obter_Gerencia_grupo_desen(b.nr_seq_grupo_des,'C') = coalesce(nr_seq_gerencia_p,0)))
	group by	substr(to_char(b.dt_liberacao,'dd/mm/yyyy'),4,2);

	if (qt_mes_w > 0) then
		qt_retorno_w := ((qt_motivo_w * 100) / qt_mes_w);
	else
		qt_retorno_w := 0;
	end if;

	end;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_dados_def_nao_ident ( dt_ano_p timestamp, nr_seq_grupo_des_p bigint, cd_funcao_p bigint, nr_grupo_trabalho_p bigint, nr_seq_localizacao_p bigint, nr_seq_gerencia_p bigint, nr_seq_motivo_p bigint, ie_mes_p text, ie_opcao_p text) FROM PUBLIC;

