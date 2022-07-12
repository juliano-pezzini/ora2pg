-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_info_os_area_versao (dt_parametro_p timestamp, cd_versao_p text, ie_area_gerencia_p text, ie_tipo_inf_p text, ie_tipo_valor_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_tipo_inf_p
QT - Quantidade total de OS no mês (Desenvolvimento, Tecnologia e Suporte)
QTD - Quantidade de OS's que passaram pelo desenvolvimento e tecnologia. OS's recebidas.
QTDFP - Quantidade de OS's que passaram pelo desenvolvimento e tecnologia fora Projeto.
QTDPRJ - Quantidade de OS's que passaram pelo desenvolvimento e tecnologia vinculadas a Projeto.
QTDPP - Quantidade de OS's que passaram pelo desenvolvimento por produto.
ER - Quantidade total de defeitos no mês
ERV - Quantidade total de defeitos da versão
ERI- Quantidade de defeitos identificados internamente na wheb
ERE-Quantidade de defeitos identificados externamente pelo cliente
ERIV- Quantidade de defeitos identificados internamente na wheb por versão
EREV-Quantidade de defeitos identificados externamente pelo cliente por versão
QTI - Quantidade total de Insatisfação no mês
PRI - Percentual de insatisfação
EN - Quantidade total de OS encerrada
ENS - Quantidade total de OS encerrada com satisfação
PR - Percentual de defeitos no mês
PRIN- Percentual de defeitos no mês identificados internamente na Philips
PRDJAVA - Percentual de defeitos identificados pela Philips e pelos clientes, relacionados a linguagem Java
PRDDELPHI - Percentual de defeitos identificados pela Philips e pelos clientes, relacionados a linguagem Delphi
PRDJVCLI - Percentual de defeitos java identificados pelos clientes
PRDJVPHI - Percentual de defeitos Java identificados pela Philips
PRDDECLI - Percentual de defeitos Delphi identificados pelos clientes
PRDDEPHI - Percentual de defeitos Delphi identificados pela Philips
PRD - Percentual de defeitos no mês, considerando apenas as OS's que passaram pelo desenvolvimento e tecnologia
PRIND - Percentual de defeitos no mês identificados internamente na Philips, considerando apenas as OS's que passaram pelo desenvolvimento e tecnologia
PRPP - Percentual de defeitos por produto, considerando apenas as OS's que passaram pelo desenvolvimento e tecnologia
PRSEV - Percentual de defeitos por severidade, considerando apenas as OS's que passaram pelo desenvolvimento e tecnologia
PRDSEV - Percentual dos defeitos por severidade.
PREX- Percentual de defeitos no mês identificados externamente pelos clientes
PREXD - Percentual de defeitos identificados pelos clientes, com base somente nas OS's que passaram pelo desenv e tecnologia
PRJIN - Percentual de defeitos internos de migração - Java
PRINSJ - Percentual de defeitos internos sem de migração - Java
VEVOS - Quantidade de O.Ss de defeito do setor de VeV
TMAC - Tempo médio gasto pelos usuários de desenvolvimento em ordens de alta complexidade
TMBC - Tempo médio gasto pelos usuários de desenvolvimento em ordens de baixa complexidade
PRANTIGA - Percental de OS's antigas pendentes no desenvolvimento
QTANTIGA - Quantidade de OS's antigas pendentes no desenvolvimento
QTBACKLOG - Quantidade de OS's pendentes no desenvolvimento no momento.
QTRECCLI - Quantidade de OS's recebidas dos clientes. Fora OS's abertas internamente.
QTRECINT - Quantidade de OS's abertas internamente na Philips.
QTBACKCLI - Quantidade de OS's pendentes no desenvolvimento que foram abertas pelos clientes
QTBACKINT - Quantidade de OS's pendentes no desenvolvimento que foram abertas internamente pela Philips.
QTBACKPENDCLI - Quantidade de OS's que passaram pelo desenvolvimento e que no momento estão pendentes com o cliente.
QTBACKPENDVEV - Quantidade de OS's que foram customizadas pelo desenvolvimento e que estão pendentes de testes pelo VeV
QTSLA - Quantidade de SLA pendentes no desenvolvimento.
QTBACKLOGDEF - Quantidade de defeitos pendentes no desenvolvimento
QTANNE - Quantidade de analistas de negócio
QTANSI - Quantidade de analistas de sistema
QTANMA - Quantidade de analistas de manutenção
QTPROG - Quantidade de programadores
QTESTA - Quantidade de estagiários
QAUSEN - Quantidade de pessoas ausentes no perído (férias ou afastamentos atestados por período maiores.)
QTHORAOS - Quantidade de horas registradas para encerrar cada ordens de serviço no periodo
QTHORADIA - Quantidade de horas registradas em ordens de serviço por dia no periodo
QTHORAOSINT - Quantidade de horas registradas para encerrar cada ordens de serviço interna (aberta pela Philips) no periodo
QTHORAOSCLI - Quantidade de horas registradas para encerrar cada ordens de serviço externa (aberta pelo cliente) no periodo
QTRECEBDIA - Quantidade de OS's recebidas no dia corrente.
QTRECEBDIACLI - Quantidade de OS's recebidas no dia corrente abertas por clientes
QTRECEBDIAINT - Quantidade de OS's recebidas no dia corrente abertas internamente
QTPESSOA - Quantidade de pessoas no último dia de cada mês no período (descontando apenas os gerentes)
*/
qt_total_os_w			double precision;
qt_total_tec_w			double precision := 0;
qt_erro_w			double precision;
qt_retorno_w			double precision;
qt_os_encerrada_w		double precision;
qt_os_encerrada_classif_w	double precision;
qt_min_os_w			double precision;
qt_os_insatisf_w		double precision;
dt_ref_mes_w			timestamp;
dt_fim_mes_w			timestamp;
dt_inicio_w			timestamp;
dt_final_w			timestamp;
qt_os_vev_w			double precision := 0;
qt_os_philips_w			double precision := 0;

C01 CURSOR FOR
SELECT	x.dt_inicio,
		x.dt_fim
from	ausencia_tasy x,
	usuario_grupo_des b,
	grupo_desenvolvimento a,
	gerencia_wheb g
where	a.nr_sequencia	= b.nr_seq_grupo
and	g.nr_sequencia	= a.nr_seq_gerencia
and	g.ie_situacao	= 'A'
and	a.ie_situacao	= 'A'
and	x.nm_usuario_ausente	= b.nm_usuario_grupo
and	x.nr_seq_grupo_des	= b.nr_seq_grupo
and	b.ie_funcao_usuario in ('P','S','N','M')
and	dt_parametro_p between PKG_DATE_UTILS.start_of(x.DT_INICIO,'month',0) and PKG_DATE_UTILS.END_OF(x.DT_FIM, 'MONTH', 0)
and	g.ie_area_gerencia	= ie_area_gerencia_p;

c01_w c01%rowtype;


BEGIN

dt_ref_mes_w			:= PKG_DATE_UTILS.start_of(dt_parametro_p,'month',0);
dt_fim_mes_w			:= PKG_DATE_UTILS.END_OF(dt_ref_mes_w, 'MONTH', 0);

if (ie_tipo_valor_p	= 'A') then /*Mês corrente*/
	dt_ref_mes_w		:= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(dt_parametro_p,'month', 0), -11, 0);
	dt_fim_mes_w		:= PKG_DATE_UTILS.start_of(dt_parametro_p,'month',0);
elsif (ie_tipo_valor_p	= 'AC') then /*Ano corrente de 01/01/xxxx até a data atual*/
	dt_ref_mes_w		:= PKG_DATE_UTILS.start_of(dt_parametro_p,'YEAR',0);
	dt_fim_mes_w		:= PKG_DATE_UTILS.END_OF(dt_parametro_p, 'MONTH', 0);
elsif (ie_tipo_valor_p	= 'ACM') then /*Ano corrente de 01/01/xxxx até o último mês cheio*/
	dt_ref_mes_w		:= PKG_DATE_UTILS.start_of(dt_parametro_p,'YEAR',0);
	dt_fim_mes_w		:= PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.start_of(dt_parametro_p,'month',0) - 1, 'MONTH', 0);
end if;

if (ie_tipo_inf_p in ('QT','PR','PRIN','PREX','PRJIN','PRINSJ','PRPHI','PRVEV','PRDJAVA','PRDDELPHI','PRDJVCLI','PRDJVPHI','PRDDECLI','PRDDEPHI'))   then

	/*Quantidade de OS recebidas independetente se passou para o Desenvolvimento/Tecnologia*/

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	gerencia_wheb b,
			os_recebida_gerencia_v a
	where	a.nr_seq_gerencia	= b.nr_sequencia
	and		a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		b.ie_area_gerencia	= ie_area_gerencia_p;

elsif (ie_tipo_inf_p in ('QTD','PRD','PREXD','PRIND','PRSEV')) then

	/*Quantidade de OS recebidas que passaram pelo Desenvolvimento e Tecnologia*/

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	gerencia_wheb b,
			os_recebida_gerencia_desenv_v a
	where	a.nr_seq_gerencia	= b.nr_sequencia
	and		a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		b.ie_area_gerencia	= ie_area_gerencia_p;

elsif (ie_tipo_inf_p in ('QTDFP')) then

	/*Quantidade de OS recebidas que passaram pelo Desenvolvimento e Tecnologia e que não estavam vinculadas a projetos*/

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	gerencia_wheb g,
			os_recebida_gerencia_desenv_v a
	where	a.nr_seq_gerencia	= g.nr_sequencia
	and		a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and	not exists (	SELECT	1
				from	proj_projeto b
				where	b.nr_seq_ordem_serv = a.nr_sequencia
				and	b.ie_origem	= 'D')
	and	not exists (	select	1
				from	proj_projeto c,
					proj_ordem_servico d
				where	d.nr_seq_ordem 	= a.nr_sequencia
				and	c.nr_sequencia	= d.nr_seq_proj
				and	c.ie_origem	= 'D');

elsif (ie_tipo_inf_p in ('QTDPRJ')) then

	/*Quantidade de OS recebidas que passaram pelo Desenvolvimento e Tecnologia e que estavam vinculadas a projetos*/

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	gerencia_wheb g,
			os_recebida_gerencia_desenv_v a
	where	a.nr_seq_gerencia	= g.nr_sequencia
	and		a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and	exists (SELECT	1
			from	proj_projeto b
			where	b.nr_seq_ordem_serv = a.nr_sequencia
			and	b.ie_origem	= 'D'
			
union

			SELECT	1
			from	proj_projeto c,
				proj_ordem_servico d
			where	d.nr_seq_ordem 	= a.nr_sequencia
			and	c.nr_sequencia	= d.nr_seq_proj
			and	c.ie_origem	= 'D');

elsif (ie_tipo_inf_p in ('QTDPP', 'PRPP')) then

	/*Quantidade de OS's que passaram pelo desenvolvimento por produto*/

	if (UPPER(ie_tipo_valor_p) = 'TASY') then
			select 	count(distinct a.nr_sequencia)
			into STRICT	qt_total_os_w
			from	gerencia_wheb g,
					os_recebida_gerencia_desenv_v a
			where	a.nr_seq_gerencia	= g.nr_sequencia
			and		a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
			and     g.ie_area_gerencia	= ie_area_gerencia_p
			and		g.nr_sequencia <> 7;

			select	count(distinct a.nr_sequencia)
			into STRICT	qt_erro_w
			from	gerencia_wheb g,
					os_erro_gerencia_v a
			where	a.nr_seq_gerencia	= g.nr_sequencia
			and		a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
			and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and		g.ie_area_gerencia	= ie_area_gerencia_p
			and		g.nr_sequencia <> 7;


	elsif (UPPER(ie_tipo_valor_p) = 'OPS') then
			select 	count(distinct nr_sequencia)
			into STRICT	qt_total_os_w
			from	os_recebida_gerencia_desenv_v
			where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
			and     nr_seq_gerencia = 7;

			select	count(distinct nr_sequencia)
			into STRICT	qt_erro_w
			from	os_erro_gerencia_v
			where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
			and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and		nr_seq_gerencia = 7;

	elsif (UPPER(ie_tipo_valor_p) = 'MULTIMED') then
			select 	count(distinct nr_sequencia)
			into STRICT	qt_total_os_w
			from	os_recebida_gerencia_desenv_v
			where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
			and     nr_seq_gerencia = 21;

			select	count(distinct nr_sequencia)
			into STRICT	qt_erro_w
			from	os_erro_gerencia_v
			where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	nr_seq_gerencia = 21;
	end if;
elsif (ie_tipo_inf_p in ('PRANTIGA','QTANTIGA')) then

	select	COUNT(*)
	into STRICT	qt_erro_w
	from	man_estagio_processo c,
			gerencia_wheb g,
			grupo_desenvolvimento b,
			man_ordem_servico a
	where	a.nr_seq_grupo_des = b.nr_sequencia
	and		c.nr_sequencia = a.nr_seq_estagio
	and		b.nr_seq_gerencia	= g.nr_sequencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		coalesce(c.ie_desenv,'X') = 'S'
	and		a.ie_status_ordem <> '3'
	AND		a.dt_ordem_servico < clock_timestamp() - interval '30 days';

elsif (ie_tipo_inf_p = 'QTRECCLI') then

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	FROM gerencia_wheb g, os_recebida_gerencia_desenv_v a
LEFT OUTER JOIN man_localizacao b ON (a.nr_seq_localizacao = b.nr_sequencia)
WHERE a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w and a.nr_seq_gerencia		= g.nr_sequencia and g.ie_area_gerencia		= ie_area_gerencia_p  and coalesce(ie_terceiro,'S')	= 'S';

elsif (ie_tipo_inf_p = 'QTRECINT') then

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	FROM gerencia_wheb g, os_recebida_gerencia_desenv_v a
LEFT OUTER JOIN man_localizacao b ON (a.nr_seq_localizacao = b.nr_sequencia)
WHERE a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w and a.nr_seq_gerencia		= g.nr_sequencia and g.ie_area_gerencia		= ie_area_gerencia_p  and coalesce(ie_terceiro,'S')	= 'N';

elsif (ie_tipo_inf_p = 'QTBACKLOG') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	from	man_estagio_processo c,
			gerencia_wheb g,
			grupo_desenvolvimento b,
			man_ordem_servico a
	where	a.nr_seq_grupo_des = b.nr_sequencia
	and		c.nr_sequencia = a.nr_seq_estagio
	and		b.nr_seq_gerencia		= g.nr_sequencia
	and		g.ie_area_gerencia		= ie_area_gerencia_p
	and		c.ie_desenv = 'S'
	and		a.ie_status_ordem <> '3';

elsif (ie_tipo_inf_p = 'QTBACKCLI') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	FROM gerencia_wheb g, man_estagio_processo c, grupo_desenvolvimento b, man_ordem_servico a
LEFT OUTER JOIN man_localizacao m ON (a.nr_seq_localizacao = m.nr_sequencia)
WHERE a.nr_seq_grupo_des = b.nr_sequencia and c.nr_sequencia = a.nr_seq_estagio and b.nr_seq_gerencia		= g.nr_sequencia and g.ie_area_gerencia		= ie_area_gerencia_p  and coalesce(m.ie_terceiro,'S')	= 'S' and coalesce(c.ie_desenv,'X') = 'S' and a.ie_status_ordem <> '3';

elsif (ie_tipo_inf_p = 'QTBACKINT') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	FROM gerencia_wheb g, man_estagio_processo c, grupo_desenvolvimento b, man_ordem_servico a
LEFT OUTER JOIN man_localizacao m ON (a.nr_seq_localizacao = m.nr_sequencia)
WHERE a.nr_seq_grupo_des = b.nr_sequencia and c.nr_sequencia = a.nr_seq_estagio and b.nr_seq_gerencia		= g.nr_sequencia and g.ie_area_gerencia		= ie_area_gerencia_p  and coalesce(m.ie_terceiro,'S')	= 'N' and coalesce(c.ie_desenv,'X') = 'S' and a.ie_status_ordem <> '3';

elsif (ie_tipo_inf_p = 'QTBACKPENDCLI') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	FROM gerencia_wheb g, man_estagio_processo c, os_recebida_gerencia_desenv_v a, man_ordem_servico b
LEFT OUTER JOIN man_localizacao m ON (b.nr_seq_localizacao = m.nr_sequencia)
WHERE c.nr_sequencia = b.nr_seq_estagio and b.nr_sequencia = a.nr_sequencia and a.nr_seq_gerencia		= g.nr_sequencia and g.ie_area_gerencia		= ie_area_gerencia_p  and coalesce(m.ie_terceiro,'S')	= 'S' and coalesce(c.ie_desenv,'X') <> 'S' and b.ie_status_ordem <> '3' and c.ie_acao = 2;

elsif (ie_tipo_inf_p = 'QTBACKPENDVEV') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	from	man_estagio_processo c,
			gerencia_wheb g,
			man_ordem_servico b,
			os_recebida_gerencia_desenv_v a
	where	c.nr_sequencia		= b.nr_seq_estagio
	and		b.nr_sequencia 		= a.nr_sequencia
	and		a.nr_seq_gerencia	= g.nr_sequencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		coalesce(c.ie_testes,'X') = 'S'
	and		b.ie_status_ordem <> '3';

elsif (ie_tipo_inf_p = 'QTSLA') then
	select	count(*)
	into STRICT	qt_total_os_w
	from	man_estagio_processo c,
			gerencia_wheb g,
			grupo_desenvolvimento b,
    		man_ordem_servico  a,
			man_ordem_serv_sla s
	where 	a.nr_sequencia	= s.nr_seq_ordem
	and   	s.nr_seq_status <> 412
	and		c.nr_sequencia	= a.nr_seq_estagio
	and		a.nr_seq_grupo_des	= b.nr_sequencia
	and		b.nr_seq_gerencia	= g.nr_sequencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		coalesce(c.ie_desenv,'N')	= 'S'
	and   	a.ie_status_ordem	<> '3';

elsif (ie_tipo_inf_p = 'QTBACKLOGDEF') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	from	man_estagio_processo c,
			gerencia_wheb g,
			grupo_desenvolvimento b,
			man_ordem_servico a
	where	a.nr_seq_grupo_des		= b.nr_sequencia
	and		c.nr_sequencia			= a.nr_seq_estagio
	and		b.nr_seq_gerencia	= g.nr_sequencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		a.ie_classificacao		= 'E'
	and		coalesce(c.ie_desenv,'X')	= 'S'
	and		a.ie_status_ordem		<> '3';

elsif (ie_tipo_inf_p in ('QTANNE','QTANSI','QTANMA','QTPROG','QTESTA')) then

	select	count(1)
	into STRICT	qt_total_os_w
	from	usuario_grupo_des b,
			gerencia_wheb g,
			grupo_desenvolvimento a
	where	a.nr_sequencia	= b.nr_seq_grupo
	and		a.nr_seq_gerencia	= g.nr_sequencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		a.ie_situacao	= 'A'
	and		b.ie_funcao_usuario = ie_tipo_valor_p;

elsif (ie_tipo_inf_p = 'QAUSEN') then

	qt_total_os_w	:= 0;
	open C01;
	loop
	fetch C01 into
		C01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		dt_inicio_w	:= dt_ref_mes_w;
		dt_final_w	:= dt_fim_mes_w;

		if (PKG_DATE_UTILS.start_of(C01_w.dt_inicio,'month',0) = dt_ref_mes_w) then
			dt_inicio_w	:= C01_w.dt_inicio;
		end if;

		if (PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.END_OF(C01_w.dt_fim, 'MONTH', 0), 'dd', 0) = PKG_DATE_UTILS.start_of(dt_fim_mes_w,'dd',0)) then
			dt_final_w	:= C01_w.dt_fim;
		end if;

		qt_total_os_w	:= qt_total_os_w + obter_dias_entre_datas(dt_inicio_w,dt_final_w) + 1;

		end;
	end loop;
	close C01;

	qt_total_os_w	:= round((dividir(qt_total_os_w,30))::numeric,1);

elsif (ie_tipo_inf_p = 'QTHORADIA') then

	select	dividir(sum(qt_minuto),60)
	into STRICT	qt_total_os_w
	from	MAN_ORDEM_SERV_ATIV a
	where	(a.dt_atividade IS NOT NULL AND a.dt_atividade::text <> '')
	and		(a.dt_fim_atividade IS NOT NULL AND a.dt_fim_atividade::text <> '')
	and		a.dt_atividade between dt_ref_mes_w and dt_fim_mes_w
	and	exists (	SELECT	1
				from	gerencia_wheb w,
					usuario_grupo_des c,
					grupo_desenvolvimento b
				where	b.nr_sequencia		= c.nr_seq_grupo
				and	w.nr_sequencia		= b.nr_seq_gerencia
				and	w.ie_area_gerencia	= ie_area_gerencia_p
				and	b.ie_situacao		= 'A'
				and	w.ie_situacao		= 'A'
				and	c.nm_usuario_grupo	= a.nm_usuario_exec);

elsif (ie_tipo_inf_p = 'QTHORAOS') then
	select	dividir(dividir(sum(qt_minuto),60), count(distinct m.nr_sequencia))
	into STRICT	qt_total_os_w
	from	gerencia_wheb x,
			grupo_desenvolvimento g,
			MAN_ORDEM_SERV_ATIV a,
			man_ordem_servico m
	where	m.nr_sequencia	= a.nr_seq_ordem_serv
	and		m.nr_seq_grupo_des = g.nr_sequencia
	and		g.nr_seq_gerencia	= x.nr_sequencia
	and		x.ie_area_gerencia	= ie_area_gerencia_p
	and		m.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and		m.ie_status_ordem = '3'
	and		(a.dt_atividade IS NOT NULL AND a.dt_atividade::text <> '')
	and		(a.dt_fim_atividade IS NOT NULL AND a.dt_fim_atividade::text <> '')
	and	exists (	SELECT	1
				from	gerencia_wheb w,
						usuario_grupo_des c,
						grupo_desenvolvimento b
				where	b.nr_sequencia	= c.nr_seq_grupo
				and		w.nr_sequencia		= b.nr_seq_gerencia
				and		w.ie_area_gerencia	= ie_area_gerencia_p
				and		b.ie_situacao		= 'A'
				and		w.ie_situacao		= 'A'
				and		c.nm_usuario_grupo	= a.nm_usuario_exec);

elsif (ie_tipo_inf_p = 'QTHORAOSCLI') then
	select	dividir(dividir(sum(qt_minuto),60), count(distinct m.nr_sequencia))
	into STRICT	qt_total_os_w
	from	man_localizacao l,
			gerencia_wheb x,
			grupo_desenvolvimento g,
			MAN_ORDEM_SERV_ATIV a,
			man_ordem_servico m
	where	m.nr_sequencia		= a.nr_seq_ordem_serv
	and		m.nr_seq_grupo_des	= g.nr_sequencia
	and		l.nr_sequencia		= m.nr_seq_localizacao
	and		g.nr_seq_gerencia	= x.nr_sequencia
	and		x.ie_area_gerencia	= ie_area_gerencia_p
	and		coalesce(l.ie_terceiro,'S')	= 'S'
	and		m.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and		m.ie_status_ordem = '3'
	and		(a.dt_atividade IS NOT NULL AND a.dt_atividade::text <> '')
	and		(a.dt_fim_atividade IS NOT NULL AND a.dt_fim_atividade::text <> '')
	and	exists (	SELECT	1
				from	gerencia_wheb w,
						usuario_grupo_des c,
						grupo_desenvolvimento b
				where	b.nr_sequencia		= c.nr_seq_grupo
				and	w.nr_sequencia		= b.nr_seq_gerencia
				and	w.ie_area_gerencia	= ie_area_gerencia_p
				and	b.ie_situacao		= 'A'
				and	w.ie_situacao		= 'A'
				and	c.nm_usuario_grupo	= a.nm_usuario_exec);

elsif (ie_tipo_inf_p = 'QTHORAOSINT') then
	select	dividir(dividir(sum(qt_minuto),60), count(distinct m.nr_sequencia))
	into STRICT	qt_total_os_w
	from	man_localizacao l,
			gerencia_wheb x,
			grupo_desenvolvimento g,
			MAN_ORDEM_SERV_ATIV a,
			man_ordem_servico m
	where	m.nr_sequencia		= a.nr_seq_ordem_serv
	and		m.nr_seq_grupo_des	= g.nr_sequencia
	and		l.nr_sequencia		= m.nr_seq_localizacao
	and		g.nr_seq_gerencia	= x.nr_sequencia
	and		x.ie_area_gerencia	= ie_area_gerencia_p
	and		coalesce(l.ie_terceiro,'S')	= 'N'
	and		m.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and		m.ie_status_ordem = '3'
	and		(a.dt_atividade IS NOT NULL AND a.dt_atividade::text <> '')
	and		(a.dt_fim_atividade IS NOT NULL AND a.dt_fim_atividade::text <> '')
	and	exists (	SELECT	1
				from	gerencia_wheb w,
						usuario_grupo_des c,
						grupo_desenvolvimento b
				where	b.nr_sequencia		= c.nr_seq_grupo
				and		w.nr_sequencia		= b.nr_seq_gerencia
				and		w.ie_area_gerencia	= ie_area_gerencia_p
				and		b.ie_situacao		= 'A'
				and		w.ie_situacao		= 'A'
				and		c.nm_usuario_grupo	= a.nm_usuario_exec);

elsif (ie_tipo_inf_p = 'QTRECEBDIA') then

	dt_ref_mes_w	:= PKG_DATE_UTILS.start_of(dt_parametro_p,'dd',0);
	dt_fim_mes_w	:= PKG_DATE_UTILS.END_OF(dt_ref_mes_w, 'DAY', 0);

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	gerencia_wheb g,
			os_recebida_gerencia_desenv_v a
	where	g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w;

elsif (ie_tipo_inf_p = 'QTRECEBDIACLI') then

	dt_ref_mes_w	:= PKG_DATE_UTILS.start_of(dt_parametro_p,'dd',0);
	dt_fim_mes_w	:= PKG_DATE_UTILS.END_OF(dt_ref_mes_w, 'DAY', 0);

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	man_localizacao b,
			gerencia_wheb g,
			os_recebida_gerencia_desenv_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		a.nr_seq_localizacao	= b.nr_sequencia
	and		coalesce(b.ie_terceiro,'S')	= 'S';

elsif (ie_tipo_inf_p = 'QTRECEBDIAINT') then

	dt_ref_mes_w	:= PKG_DATE_UTILS.start_of(dt_parametro_p,'dd',0);
	dt_fim_mes_w	:= PKG_DATE_UTILS.END_OF(dt_ref_mes_w, 'DAY', 0);

	select 	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	man_localizacao b,
			gerencia_wheb g,
			os_recebida_gerencia_desenv_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		a.nr_seq_localizacao	= b.nr_sequencia
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		coalesce(b.ie_terceiro,'S')	= 'N';

elsif (ie_tipo_inf_p = 'QTPESSOA') then

	SELECT	sum(a.qt_total_pessoas)
	into STRICT	qt_total_os_w
	FROM	gerencia_wheb b,
			w_indicador_desenv_apres a
	WHERE	b.nr_sequencia		= a.nr_seq_gerencia
	and		a.dt_referencia		= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.END_OF(a.dt_referencia, 'MONTH', 0),'dd',0)
	and		b.ie_area_gerencia	= ie_area_gerencia_p
	and		a.ie_abrangencia	= 'GER'
	and		a.dt_referencia between dt_ref_mes_w and dt_fim_mes_w;

end if;

/* Percentual de defeitos por severidade, considerando apenas as OS's que passaram pelo desenvolvimento e tecnologia */

if (ie_tipo_inf_p in ('PRSEV')) then

	select	count(distinct a.nr_sequencia)
	into STRICT	qt_erro_w
	from	gerencia_wheb g,
			os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		a.nr_seq_severidade	= ie_tipo_valor_p;

end if;

if (ie_tipo_inf_p in ('PRDSEV')) then

	select	count(distinct a.nr_sequencia)
	into STRICT	qt_total_os_w
	from	gerencia_wheb g,
			os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		(a.nr_seq_severidade IS NOT NULL AND a.nr_seq_severidade::text <> '');

	select	count(distinct a.nr_sequencia)
	into STRICT	qt_erro_w
	from	gerencia_wheb g,
			os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		a.nr_seq_severidade	= ie_tipo_valor_p;
end if;

/*Retorna a quantidade de defeitos considerando o DOC ERRO*/

if (ie_tipo_inf_p in ('ER','PR','PRD')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');
end if;

/*Retorna a quantidade de defeitos considerando o DOC ERRO por versão*/

if (ie_tipo_inf_p in ('ERV')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.cd_versao_alteracao	= cd_versao_p
		and		((coalesce(dt_parametro_p::text, '') = '') or (a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w));
end if;

/*Retorna a quantidade de defeitos considerando o DOC ERRO*/

if (ie_tipo_inf_p in ('EGW')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.ie_origem_erro <> 'C';
end if;

/*Retorna a quantidade de defeitos considerando o DOC defeitos identificados na base da Wheb*/

if (ie_tipo_inf_p in ('PRIN','PRIND')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.ie_ident_erro	= 'W';
end if;

/*Retorna a quantidade de defeitos considerando o DOC defeitos externamente pelos clientes */

if (ie_tipo_inf_p in ('PREX','QTEXT','PREXD')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.ie_ident_erro	<> 'W';
end if;

/*Retorna a quantidade de defeitos encontrados na base Wheb  fora do VV*/

if (ie_tipo_inf_p in ('PRPHI','QTPHI')) then

		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		a.ie_ident_erro	= 'W'
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.nr_seq_equipamento not in (2897,5818);
end if;

/*Retorna a quantidade de defeitos encontrados pelo VV */

if (ie_tipo_inf_p in ('PRVEV')) then

		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		a.ie_ident_erro	= 'W'
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.nr_seq_equipamento in (2897,5818);
end if;

/*Retorna a quantidade de defeitos considerando o DOC defeitos que foram identificados internamente na Wheb*/

if (ie_tipo_inf_p in ('ERI')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.ie_ident_erro	= 'W';
end if;


/*Retorna a quantidade de defeitos considerando o DOC defeitos que foram identificados internamente na Wheb por versão */

if (ie_tipo_inf_p in ('ERIV')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
			os_erro_gerencia_v a
		where	g.nr_sequencia		= a.nr_seq_gerencia
		and	g.ie_area_gerencia	= ie_area_gerencia_p
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	a.cd_versao_alteracao	= cd_versao_P
		and	((coalesce(dt_parametro_p::text, '') = '') or (a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w))
		and	a.ie_ident_erro	= 'W';
end if;

/*Retorna a quantidade de defeitos considerando o DOC defeitos que foram identificados externamente pelos clientes*/

if (ie_tipo_inf_p in ('ERE')) then
	select	count(distinct a.nr_sequencia)
	into STRICT	qt_erro_w
	from	gerencia_wheb g,
			os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		a.ie_ident_erro	<> 'W';
end if;

/*Retorna a quantidade de defeitos considerando o DOC defeitos que foram identificados externamente pelos clientes por versao */

if (ie_tipo_inf_p in ('EREV')) then
	select	count(distinct a.nr_sequencia)
	into STRICT	qt_erro_w
	from	gerencia_wheb g,
		os_erro_gerencia_v a
	where	g.nr_sequencia		= a.nr_seq_gerencia
	and	g.ie_area_gerencia	= ie_area_gerencia_p
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	a.cd_versao_alteracao	= cd_versao_P
	and		((coalesce(dt_parametro_p::text, '') = '') or (a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w))
	and	a.ie_ident_erro	<> 'W';
end if;


/*Retorna a quantidade de OS encerrada que passou pelo Desenvolvimento/Tecnologia*/

if (ie_tipo_inf_p = 'EN') then
	select	count(*)
	into STRICT	qt_os_encerrada_w
	from	gerencia_wheb g,
			os_encerrada_gerencia_v a
	where	a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p;
end if;

/*Retorna a quantidade de OS encerrada com Grau de Satisfação*/

if ( ie_tipo_inf_p in ('PRI','ENS')) then
	select  count(*)
	into STRICT	qt_os_encerrada_classif_w
	from    gerencia_wheb g,
			os_encerrada_satisf_gerencia_v a
	where   a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p;
end if;

/*Retorna a quantidade de OS encerrada com Grau de Satisfação Irregular*/

if (ie_tipo_inf_p in ('QTI','PRI')) then
	select	count(*)
	into STRICT	qt_os_insatisf_w
	from	gerencia_wheb g,
			os_insatisfacao_gerencia_v a
	where   a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p;
end if;

/*Retorna a quantidade de defeitos considerando o DOC defeitos identificados na base da Wheb - Somente para migração JAVA */

if (ie_tipo_inf_p in ('PRJIN')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.ie_ident_erro	= 'W'
		and		a.ie_forma_origem = '10';
end if;

/*Retorna a quantidade de defeitos considerando o DOC defeitos identificados na base da Wheb - Exceto para migração JAVA */

if (ie_tipo_inf_p in ('PRINSJ')) then
		select	count(distinct a.nr_sequencia)
		into STRICT	qt_erro_w
		from	gerencia_wheb g,
				os_erro_gerencia_v a
		where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
		and		g.nr_sequencia		= a.nr_seq_gerencia
		and		g.ie_area_gerencia	= ie_area_gerencia_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.ie_ident_erro	= 'W'
		and		a.ie_forma_origem <> '10';
end if;

if (ie_tipo_inf_p = 'PRDJAVA') then
	SELECT	count(distinct a.nr_sequencia)
	INTO STRICT	qt_erro_w
	FROM 	gerencia_wheb g,
			os_erro_gerencia_v a
	WHERE	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	AND		a.IE_ORIGEM_ERRO = 'W'
	AND		(a.DT_LIBERACAO IS NOT NULL AND a.DT_LIBERACAO::text <> '')
	AND		a.NR_SEQ_LP = 2;

end if;

/*Percentual de defeitos java identificados pelos clientes*/

if (ie_tipo_inf_p = 'PRDJVCLI') then
	SELECT	count(distinct a.nr_sequencia)
	INTO STRICT	qt_erro_w
	FROM 	gerencia_wheb g,
			os_erro_gerencia_v a
	WHERE	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	AND		a.IE_ORIGEM_ERRO = 'W'
	AND		a.IE_IDENT_ERRO <> 'W'
	AND		(a.DT_LIBERACAO IS NOT NULL AND a.DT_LIBERACAO::text <> '')
	AND		a.NR_SEQ_LP = 2;
end if;

/*Percentual de defeitos Java identificados pela Philips*/

if (ie_tipo_inf_p = 'PRDJVPHI') then
	SELECT	count(distinct a.nr_sequencia)
	INTO STRICT	qt_erro_w
	FROM 	gerencia_wheb g,
			os_erro_gerencia_v a
	WHERE	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	AND		a.IE_ORIGEM_ERRO = 'W'
	AND		a.IE_IDENT_ERRO = 'W'
	AND		(a.DT_LIBERACAO IS NOT NULL AND a.DT_LIBERACAO::text <> '')
	AND		a.NR_SEQ_LP = 2;
end if;

/*Percentual de defeitos Delphi identificados pelo Cliente*/

if (ie_tipo_inf_p = 'PRDDECLI') then
	SELECT	count(distinct a.nr_sequencia)
	INTO STRICT	qt_erro_w
	FROM 	gerencia_wheb g,
			os_erro_gerencia_v a
	WHERE	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	AND		a.IE_ORIGEM_ERRO = 'W'
	AND		a.IE_IDENT_ERRO <> 'W'
	AND		(a.DT_LIBERACAO IS NOT NULL AND a.DT_LIBERACAO::text <> '')
	AND		a.NR_SEQ_LP <> 2;
end if;

/*Percentual de defeitos Delphi identificados pela Philips*/

if (ie_tipo_inf_p = 'PRDDEPHI') then
	SELECT	count(distinct a.nr_sequencia)
	INTO STRICT	qt_erro_w
	FROM 	gerencia_wheb g,
			os_erro_gerencia_v a
	WHERE	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	AND		a.IE_ORIGEM_ERRO = 'W'
	AND		a.IE_IDENT_ERRO = 'W'
	AND		(a.DT_LIBERACAO IS NOT NULL AND a.DT_LIBERACAO::text <> '')
	AND		a.NR_SEQ_LP <> 2;
end if;

if (ie_tipo_inf_p = 'PRDDELPHI') then
	SELECT	count(distinct a.nr_sequencia)
	INTO STRICT	qt_erro_w
	FROM 	gerencia_wheb g,
			os_erro_gerencia_v a
	WHERE	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	AND		a.IE_ORIGEM_ERRO	= 'W'
	AND		(a.DT_LIBERACAO IS NOT NULL AND a.DT_LIBERACAO::text <> '')
	AND		a.NR_SEQ_LP <> 2;

end if;

if (ie_tipo_inf_p in ('VEVOS')) then

	select	count(distinct a.nr_sequencia)
	into STRICT	qt_os_vev_w
	from	gerencia_wheb g,
			os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		a.ie_ident_erro	= 'W'
	and		a.nr_seq_equipamento in (2897,5818);

end if;

if (ie_tipo_inf_p in ('PHIOS')) then

	select	count(distinct a.nr_sequencia)
	into STRICT	qt_os_vev_w
	from	gerencia_wheb g,
			os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and		g.nr_sequencia		= a.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		a.ie_ident_erro	= 'W'
	and		a.nr_seq_equipamento not in (2897,5818);

end if;

if (ie_tipo_inf_p in ('TMAC')) then

	select	dividir(sum(b.qt_minuto), count(distinct a.nr_sequencia)) qt_min_os_alta_complex
	into STRICT	qt_min_os_w
	from	usuario x,
			gerencia_wheb g,
			grupo_desenvolvimento c,
			man_ordem_servico a,
			man_ordem_serv_ativ b
	where	a.nr_sequencia	= b.nr_seq_ordem_serv
	and		c.nr_sequencia	= a.nr_seq_grupo_des
	and		x.nm_usuario	= b.nm_usuario_exec
	and		g.nr_sequencia		= c.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		x.cd_setor_atendimento in (2,7,16)
	and		a.ie_status_ordem = 3
	and		a.nr_seq_complex in (4,5,6)
	and		a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	exists ( SELECT 1
				from	os_recebida_gerencia_desenv_v y
				where	a.nr_sequencia = y.nr_sequencia);

elsif (ie_tipo_inf_p in ('TMBC')) then

	select	dividir(sum(b.qt_minuto), count(distinct a.nr_sequencia)) qt_min_os_alta_complex
	into STRICT	qt_min_os_w
	from	usuario x,
			gerencia_wheb g,
			grupo_desenvolvimento c,
			man_ordem_servico a,
			man_ordem_serv_ativ b
	where	a.nr_sequencia	= b.nr_seq_ordem_serv
	and		a.ie_status_ordem = 3
	and		c.nr_sequencia	= a.nr_seq_grupo_des
	and		x.nm_usuario	= b.nm_usuario_exec
	and		g.nr_sequencia		= c.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		x.cd_setor_atendimento in (2,7,16)
	and		a.nr_seq_complex not in (4,5,6)
	and		a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	exists ( SELECT 1
				from	os_recebida_gerencia_desenv_v y
				where	a.nr_sequencia = y.nr_sequencia);
end if;

if (ie_tipo_inf_p = 'PRANTIGA') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	from	man_estagio_processo c,
			gerencia_wheb g,
			grupo_desenvolvimento b,
			man_ordem_servico a
	where	a.nr_seq_grupo_des	= b.nr_sequencia
	and		c.nr_sequencia		= a.nr_seq_estagio
	and		g.nr_sequencia		= b.nr_seq_gerencia
	and		g.ie_area_gerencia	= ie_area_gerencia_p
	and		coalesce(c.ie_desenv,'X') = 'S'
	and		a.ie_status_ordem	<> '3';
end if;


if (ie_tipo_inf_p in ('QT','QTD','QTDFP','QTDPRJ','QTDPP','QTBACKLOG','QTRECCLI','QTRECINT','QTBACKCLI','QTBACKINT','QTSLA','QTBACKLOGDEF','QTANNE','QTANSI','QTANMA','QTPROG','QTHORAOS','QTHORADIA',
                           'QTHORAOSINT','QTHORAOSCLI','QTRECEBDIA','QTRECEBDIAINT','QTRECEBDIACLI','QTPESSOA','QTESTA','QTBACKPENDCLI','QTBACKPENDVEV','QAUSEN')) then
	return qt_total_os_w;
elsif (ie_tipo_inf_p in ('ER','ERI','ERE','EGW','QTEXT','QTPHI','QTANTIGA', 'ERV', 'EREV', 'ERIV')) then
	return qt_erro_w;
elsif (ie_tipo_inf_p = 'EN') then
	return qt_os_encerrada_w;
elsif (ie_tipo_inf_p in ('PR','PRD','PRSEV','PRDSEV','PRDJAVA','PRDDELPHI','PRDJVCLI','PRDJVPHI','PRDDECLI','PRDDEPHI','PRJIN','PRINSJ','PRVEV','PRPHI','PREX','PREXD','PRIN','PRIND','PRPP','PRANTIGA')) then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'QTI') then
	return	qt_os_insatisf_w;
elsif (ie_tipo_inf_p = 'PRI') then
	return dividir(qt_os_insatisf_w, qt_os_encerrada_classif_w)*100;
elsif (ie_tipo_inf_p = 'ENS') then
	return	qt_os_encerrada_classif_w;
elsif (ie_tipo_inf_p = 'VEVOS') then
	return qt_os_vev_w;
elsif (ie_tipo_inf_p = 'PHIOS') then
	return qt_os_philips_w;
elsif (ie_tipo_inf_p in ('TMBC','TMAC')) then
	return	qt_min_os_w;
else
	return  0;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_info_os_area_versao (dt_parametro_p timestamp, cd_versao_p text, ie_area_gerencia_p text, ie_tipo_inf_p text, ie_tipo_valor_p text) FROM PUBLIC;

