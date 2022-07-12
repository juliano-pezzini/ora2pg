-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_informacao_os_usuario ( dt_parametro_p timestamp, nm_usuario_p text, ie_tipo_inf_p text, ie_tipo_valor_p text) RETURNS bigint AS $body$
DECLARE


/*

T		- total de OS com registro de atividades realizadas do usuário, no período
CA 		- Total de OS com registro de atividades realizadas do usuário, classificadas com complexidade Alta, Muito alta ou Alto risco.
CAE		- Total de OS encerrada pelo usuário, classificadas com complexidade Alta, Muito alta ou Alto risco.
CAEU 	- Total de OS encerrada, classificadas com complexidade Alta, Muito alta ou Alto risco. que o usuário teve atividade realizada e esta como executor.
ECPE		- Total de OS's encerradas com atividade realizada pelo usuário e com o mesmo como executor da OS.
HRAD	- Horas adicionais registradas pelo usuário
EANA	- Total de OS Encerradas no período e que tiveram atividade registrada por um analista., e que ele esteja como executor previsto da OS.
ENC		- Total de OS Encerrada pelo usuário no período
DEF		- Total de Defeitos documentados e liberados em nome do usuário no mês
DEFAP	- Total de Defeitos documentados e liberados em nome de qualquer usuário do grupo do analista, dividido pela quantidade de pessoas do grupo no mês.


QT - Quantidade total de OS no mês
QTD - Quantidade total de OS no mês do desenvolvimento
ER - Quantidade total de Erros no mês
ERI- Quantidade de erros identificados internamente na wheb
ERE-Quantidade de erros identificados externamente pelo cliente
QTI - Quantidade total de Insatisfação no mês
QTY - Quantidade total de Insatisfação no mês do desenvolvimento
QTDPE - Quantidade média de defeitos por pessoa do grupo
PRI - Percentual de insatisfação
EN - Quantidade total de OS encerrada
ENS - Quantidade total de OS encerrada com satisfação
PR - Percentual de erro no mês
PRIN- Percentual de erro no mês identificados internamente na Philips
PREX- Percentual de erro no mês identificados externamente pelos clientes
VEVOS - Quantidade de O.Ss de defeito do setor de VeV
PHIOS - Quantidade de O.Ss de defeito identificados na Philips que não são do VV
PRVEV - Percentual de O.Ss de defeito do setor de VeV
PRPHI - Percentual de O.Ss de defeito identificados na Philips que não são do VV
PRANTIGA - Percental de OS's antigas pendentes no desenvolvimento
QTANTIGA - Quantidade de OS's antigas pendentes no desenvolvimento
QTSLA - Quantidade de SLA pendentes no desenvolvimento.
QTBACKLOGDEF = Quantidade de defeitos pendentes no desenvolvimento
QTBACKLOG - Quantidade de OS's pendentes no desenvolvimento no momento.
QTANNE - Quantidade de analistas de negócio
QTANSI - Quantidade de analistas de sistema
QTANMA - Quantidade de analistas de manutenção
QTPROG - Quantidade de programadores
QTESTA - Quantidade de estagiários
QTHORADIA - Quantidade de horas registradas em ordens de serviço por dia no periodo
QTHORAOS - Quantidade de horas registradas para encerrar cada ordens de serviço no periodo
QTHORADIA - Quantidade de horas registradas em ordens de serviço por dia no periodo
QTHORAOSINT - Quantidade de horas registradas para encerrar cada ordens de serviço interna (aberta pela Philips) no periodo
QTHORAOSCLI - Quantidade de horas registradas para encerrar cada ordens de serviço externa (aberta pelo cliente) no periodo
QTRECEBDIA - Quantidade de OS's recebidas no dia corrente.
QTRECEBDIACLI - Quantidade de OS's recebidas no dia corrente abertas por clientes
QTRECEBDIAINT - Quantidade de OS's recebidas no dia corrente abertas internamente
QTRECCLI - Quantidade de OS's recebidas dos clientes. Fora OS's abertas internamente.
QTRECINT - Quantidade de OS's abertas internamente na Philips.
QTBACKCLI - Quantidade de OS's pendentes no desenvolvimento que foram abertas pelos clientes
QTBACKINT - Quantidade de OS's pendentes no desenvolvimento que foram abertas internamente pela Philips.
QTBACKPENDCLI - Quantidade de OS's que passaram pelo desenvolvimento e que no momento estão pendentes com o cliente.
QTBACKPENDVEV - Quantidade de OS's que foram customizadas pelo desenvolvimento e que estão pendentes de testes pelo VeV
QAUSEN - Quantidade de dias de ausência da pessoa (férias ou afastamentos atestados por períodos maiores.)


*/
qt_os_w				bigint;
qt_total_os_w			bigint;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
dt_entrada_w			timestamp;
dt_saida_w			timestamp;
dt_ref_mes_w			timestamp;
dt_fim_mes_w			timestamp;
dt_inicio_w			timestamp;
qt_min_extra_w			double precision;
qt_min_realizados_w		bigint;
qt_min_intervalo_w		bigint;
qt_pessoas_grupo_w		bigint;
nr_seq_grupo_w			bigint;
qt_tota_pf_grupos_w		bigint;
qt_total_os_grupos_w	bigint;
ds_dia_semana_w			varchar(10);
cd_pessoa_fisica_w		varchar(10);
ie_somar_w			varchar(10);

c01 CURSOR FOR
SELECT	dt_entrada,
	coalesce(dt_saida, fim_dia(dt_entrada)),
	qt_min_intervalo
from	usuario_controle
where	nm_usuario	= nm_usuario_p
 and	dt_entrada  between dt_inicial_w and fim_dia(dt_final_w);

c02 CURSOR FOR
SELECT	nr_seq_grupo
from	usuario_grupo_des
where	nm_usuario_grupo = nm_usuario_p;




C03 CURSOR FOR
SELECT	x.dt_inicio,
	x.dt_fim
from	ausencia_tasy x
where	x.nm_usuario_ausente	= nm_usuario_p
and	x.cd_motivo_ausencia in (1,2,3,4,5,6,13);

c03_w c03%rowtype;



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


select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	usuario
where	nm_usuario	= nm_usuario_p;

if (ie_tipo_inf_p = 'T') then

	select	count(distinct b.nr_seq_ordem_serv)
	into STRICT	qt_os_w
	from	man_ordem_serv_ativ b
	where	dt_atividade between dt_ref_mes_w AND dt_fim_mes_w
	and	nm_usuario_exec	= nm_usuario_p;

elsif (ie_tipo_inf_p = 'CA') then
	select	count(distinct b.nr_seq_ordem_serv)
	into STRICT	qt_os_w
	from	man_ordem_servico a,
		man_ordem_serv_ativ b
	where	a.nr_sequencia	= b.nr_seq_ordem_serv
	and	a.nr_seq_complex in (4,5,6)
	and	b.dt_atividade between dt_ref_mes_w AND dt_fim_mes_w
	and	b.nm_usuario_exec = nm_usuario_p;

elsif (ie_tipo_inf_p = 'CAE') then
	select	count(distinct x.nr_seq_ordem_serv)
	into STRICT	qt_os_w
	from	w_avaliacao_usuario x,
		man_ordem_servico a
	where	a.nr_sequencia	= x.NR_SEQ_ORDEM_SERV
	and	a.nr_seq_complex in (4,5,6)
	and	x.ie_referencia	= 'E'
	and	x.nm_usuario_cor = 'TASY'
	and	x.dt_referencia between dt_ref_mes_w AND dt_fim_mes_w
	and	x.nm_usuario = nm_usuario_p;

elsif (ie_tipo_inf_p = 'ENC') then
	select	count(distinct x.nr_seq_ordem_serv)
	into STRICT	qt_os_w
	from	w_avaliacao_usuario x,
			man_ordem_servico a
	where	a.nr_sequencia	= x.NR_SEQ_ORDEM_SERV
	and	x.ie_referencia	= 'E'
	and	x.nm_usuario_cor = 'TASY'
	and	x.dt_referencia between dt_ref_mes_w AND dt_fim_mes_w
	and	x.nm_usuario = nm_usuario_p;

elsif (ie_tipo_inf_p = 'CAEU') then
	select	count(distinct a.nr_sequencia)
	into STRICT	qt_os_w
	from	man_ordem_servico m,
			os_encerrada_gerencia_v a
	where	a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	a.nr_sequencia	= m.nr_sequencia
	and	m.nr_seq_complex in (4,5,6)
	and	exists (	SELECT	1
				from	man_ordem_serv_ativ b
				where	a.nr_sequencia		= b.nr_seq_ordem_serv
				and	b.nm_usuario_exec	= nm_usuario_p)
	and	exists (	select	1
				from	man_ordem_servico_exec c
				where	a.nr_sequencia		= c.nr_seq_ordem
				and	c.nm_usuario_exec	= nm_usuario_p);

elsif (ie_tipo_inf_p = 'EANA') then
	select	count(distinct a.nr_seq_ordem_serv)
	into STRICT	qt_os_w
	from	man_ordem_servico b,
		man_ordem_serv_ativ a
	where	b.nr_sequencia 		= a.nr_seq_ordem_serv
	and	a.nm_usuario_exec 	= nm_usuario_p
	and	b.ie_status_ordem	= 3
	and	exists (SELECT	1
				from	man_ordem_servico_exec x
				where	x.nr_seq_ordem = b.nr_sequencia
				and	x.nm_usuario_exec = nm_usuario_p)
	and	b.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w;

elsif (ie_tipo_inf_p = 'DEF') then
	select	count(distinct x.nr_seq_ordem_serv)
	into STRICT	qt_os_w
	from	w_avaliacao_usuario x
	where	x.ie_referencia	= 'ER'
	and	x.nm_usuario_cor = 'TASY'
	and	x.dt_referencia between dt_ref_mes_w AND dt_fim_mes_w
	and	x.nm_usuario = nm_usuario_p;

elsif (ie_tipo_inf_p = 'DEFAP') then

	select	count(distinct x.nr_seq_ordem_serv)
	into STRICT	qt_total_os_grupos_w
	from	w_avaliacao_usuario x
	where	x.ie_referencia	= 'ER'
	and	x.nm_usuario_cor = 'TASY'
	and	x.dt_referencia between dt_ref_mes_w AND dt_fim_mes_w
	and	x.nm_usuario in (	SELECT	distinct a.nm_usuario_grupo
					from	usuario_grupo_des a
					where	nr_seq_grupo in (select	distinct b.nr_seq_grupo
								from	usuario_grupo_des b
								where	b.nm_usuario_grupo = nm_usuario_p));

	select	count(distinct a.nm_usuario_grupo)
	into STRICT	qt_tota_pf_grupos_w
	from	usuario_grupo_des a
	where	a.nr_seq_grupo	in (	SELECT	distinct b.nr_seq_grupo
					from	usuario_grupo_des b
					where	b.nm_usuario_grupo = nm_usuario_p);

	qt_os_w	:= dividir(qt_total_os_grupos_w, qt_tota_pf_grupos_w);

elsif (ie_tipo_inf_p = 'ECPE') then
	select	count(distinct a.nr_sequencia)
	into STRICT	qt_os_w
	from	os_encerrada_gerencia_v a
	where	a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	exists (	SELECT	1
				from	MAN_ORDEM_SERV_ATIV b
				where	a.nr_sequencia		= b.nr_seq_ordem_serv
				and	b.nm_usuario_exec	= nm_usuario_p)
	and	exists (	select	1
				from	MAN_ORDEM_SERVICO_EXEC c
				where	a.nr_sequencia		= c.nr_seq_ordem
				and	c.nm_usuario_exec	= nm_usuario_p);

elsif (ie_tipo_inf_p = 'QTBACKPENDVEV') then
	select	COUNT(*)
	into STRICT	qt_total_os_w
	from	man_estagio_processo c,
			os_recebida_gerencia_desenv_v b,
			man_ordem_servico a
	where	c.nr_sequencia		= a.nr_seq_estagio
	and		a.nr_sequencia		= b.nr_sequencia
	and		coalesce(c.ie_testes,'X') = 'S'
	and		a.ie_status_ordem <> '3';
	--and		((a.nr_seq_grupo_des = nr_seq_grupo_des_p) or (nr_seq_grupo_des_p = 0));
elsif (ie_tipo_inf_p = 'HRAD') then

	qt_min_extra_w	:= 0;
	open C01;
	loop
	fetch C01 into
		dt_entrada_w,
		dt_saida_w,
		qt_min_intervalo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		qt_min_realizados_w		:= Obter_Min_Entre_Datas(dt_entrada_w, dt_saida_w, 1) - qt_min_intervalo_w;
		ds_dia_semana_w			:= substr(obter_dia_semana(dt_entrada_w),1,3);

		if (ds_dia_semana_w in (obter_desc_expressao(630387),obter_desc_expressao(630382))) then
			qt_min_extra_w	:= qt_min_extra_w + qt_min_realizados_w;
		else
			qt_min_extra_w	:= qt_min_extra_w + (qt_min_realizados_w - 525);
		end if;

	end loop;
	close C01;

	qt_min_extra_w	:= qt_min_extra_w / 60; --Transformar em horas
elsif (ie_tipo_inf_p = 'QAUSEN') then

	qt_total_os_w	:= 0;
	open C03;
	loop
	fetch C03 into
		C03_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		dt_inicio_w	:= dt_ref_mes_w;
		dt_final_w	:= dt_fim_mes_w;
		ie_somar_w	:= 'N';

		if (C03_w.dt_inicio >= dt_ref_mes_w) and (C03_w.dt_inicio <= dt_fim_mes_w) then
			dt_inicio_w	:= C03_w.dt_inicio;
			ie_somar_w	:= 'S';
		end if;

		if (C03_w.dt_fim <= dt_fim_mes_w) and (C03_w.dt_fim >= dt_inicio_w) then
			dt_final_w	:= C03_w.dt_fim;
			ie_somar_w	:= 'S';
		end if;

		if (ie_somar_w = 'S') then
			qt_total_os_w	:= qt_total_os_w + obter_dias_entre_datas(dt_inicio_w,dt_final_w);
		end if;

		end;
	end loop;
	close C03;

end if;

if (ie_tipo_inf_p = 'HRAD') then
	return	qt_min_extra_w;
elsif (ie_tipo_inf_p = 'QAUSEN') then
	return	qt_total_os_w;
elsif (ie_tipo_inf_p in ('T','CA','CAE','EANA','ECPE','CAEU', 'ENC','DEF','DEFAP')) then
	return	qt_os_w;
else
	return -1;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_informacao_os_usuario ( dt_parametro_p timestamp, nm_usuario_p text, ie_tipo_inf_p text, ie_tipo_valor_p text) FROM PUBLIC;

