-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_informacao_os_ger_loc ( dt_parametro_p timestamp, nr_seq_gerencia_p bigint, ie_tipo_inf_p text, ie_tipo_valor_p text, nr_seq_localizacao_p bigint, cd_funcao_p bigint default -1) RETURNS bigint AS $body$
DECLARE


/*
ie_tipo_inf_p
QT - Quantidade total de OS no mês
ER - Quantidade total de Erros no mês
ERI- Quantidade de erros identificados internamente na wheb
ERE-Quantidade de erros identificados externamente pelo cliente
QTI - Quantidade total de Insatisfação no mês
PRI - Percentual de insatisfação
EN - Quantidade total de OS encerrada
ENS - Quantidade total de OS encerrada com satisfação
PR - Percentual de erro no mês
PRIN- Percentual de erro no mês identificados internamente na Wheb
PREX- Percentual de erro no mês identificados externamente pelos clientes
PREXANO - Percentual de erro no mês identificados externamente pelos clientes acumulados no 

ano (Utilizado no PPM)
PREXO - Percentual de erro no mês identificados externamente pelos clientes do produto Tasy 

Operadora
PREXP - Percentual de erro no mês identificados externamente pelos clientes do produto Tasy 

Prestadora
PREXM - Percentual de erro no mês identificados externamente pelos clientes do produto 

Multimed
VEVOS - Quantidade de O.Ss de defeito do setor de VeV
*/
		
qt_total_os_w			double precision;	
qt_total_tec_w			double precision := 0;	
qt_erro_w			double precision;	
qt_retorno_w			double precision;	
qt_os_encerrada_w		double precision;
qt_os_encerrada_classif_w	double precision;
qt_os_insatisf_w		double precision;
dt_ref_mes_w			timestamp;
dt_fim_mes_w			timestamp;
dt_ref_ano_w			timestamp;
dt_fim_ano_w			timestamp;
qt_os_vev_w			double precision := 0;
qt_os_philips_w			double precision := 0;


BEGIN
dt_ref_mes_w			:= PKG_DATE_UTILS.start_of(dt_parametro_p,'month', 0);
dt_fim_mes_w			:= PKG_DATE_UTILS.END_OF(dt_ref_mes_w, 'MONTH', 0);
dt_ref_ano_w			:= PKG_DATE_UTILS.start_of(dt_parametro_p,'year', 0);
dt_fim_ano_w			:= PKG_DATE_UTILS.END_OF(dt_ref_ano_w, 'MONTH', 0);

if (coalesce(ie_tipo_valor_p,'X')	= 'A') then
	begin
	dt_ref_mes_w			:= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(dt_parametro_p,'month', 0), -11, 0);
	dt_fim_mes_w			:= PKG_DATE_UTILS.start_of(dt_parametro_p,'month', 0);
	end;
end if;

/*Quantidade de OS recebidas independetente se passou para o Desenvolvimento/Tecnologia*/

if (ie_tipo_inf_p in ('QT','PR','PRIN','PREX','PREXP','PREXO','PREXM','PRPHI','PRVEV'))

then
	begin
	select 	count(distinct nr_sequencia)
	into STRICT	qt_total_os_w
	from	os_recebida_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and      ((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

if (ie_tipo_inf_p in ('PREXANO'))   then
	begin
	select 	count(distinct nr_sequencia)
	into STRICT	qt_total_os_w
	from	os_recebida_gerencia_v a
	where	dt_ordem_servico between dt_ref_ano_w and dt_fim_ano_w
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and      ((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;


/*Retorna a quantidade de erros considerando o DOC ERRO*/

if (ie_tipo_inf_p in ('ER','PR')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;	
end if;

/*Retorna a quantidade de erros considerando o DOC ERRO identificados na base da Wheb*/

if (ie_tipo_inf_p in ('PRIN')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	= 'W'
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de erros considerando o DOC ERRO externamente pelos clientes */

if (ie_tipo_inf_p in ('PREX','QTEXT')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	<> 'W'
	AND 	((EXISTS      (SELECT 1 
					    FROM  proj_projeto x
						WHERE  x.nr_sequencia = a.nr_seq_proj_def 
						AND	  ((x.dt_fim_real IS NOT NULL AND x.dt_fim_real::text <> '')
						AND (obter_dias_entre_datas(x.dt_fim_real,a.dt_ordem_servico) > 120))))
	OR (coalesce(a.nr_seq_proj_def::text, '') = ''))
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

if (ie_tipo_inf_p in ('PREXANO')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_ano_w and dt_fim_ano_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	<> 'W'
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de erros encontrados na base Wheb  fora do VV*/

if (ie_tipo_inf_p in ('PRPHI','QTPHI')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	= 'W'
	and	nr_seq_equipamento not in (2897,5818)
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de erro no mês identificados externamente pelos clientes do produto 

Tasy Operadora */
if (ie_tipo_inf_p in ('PREXO')) then
	begin
	
	select 	count(distinct nr_sequencia)
	into STRICT	qt_total_os_w
	from	os_recebida_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and      ((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1))
	and	a.nr_seq_gerencia = 7;
	
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	a.ie_ident_erro	<> 'W'
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (a.nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1))
	and	a.nr_seq_gerencia = 7;
	end;
end if;

/*Retorna a quantidade de erro no mês identificados externamente pelos clientes do produto 

Tasy Prestadora*/
if (ie_tipo_inf_p in ('PREXP')) then
	begin
	
	select 	count(distinct nr_sequencia)
	into STRICT	qt_total_os_w
	from	os_recebida_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and      ((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1))
	and	a.nr_seq_grupo_des in (	SELECT	x.nr_sequencia
					from	gerencia_wheb z,
						grupo_desenvolvimento x
					where	x.nr_seq_gerencia = z.nr_sequencia
					and 	z.ie_area_gerencia = 'DES'
					and	z.nr_sequencia <> 7);
	
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	a.dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	a.ie_ident_erro	<> 'W'
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (a.nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1))
	and	a.nr_seq_grupo_des in (	SELECT	x.nr_sequencia
					from	gerencia_wheb z,
						grupo_desenvolvimento x
					where	x.nr_seq_gerencia = z.nr_sequencia
					and 	z.ie_area_gerencia = 'DES'
					and	z.nr_sequencia <> 7);
	end;
end if;

/*Retorna a quantidade de erro no mês identificados externamente pelos clientes do produto 

Tasy Multimed*/
if (ie_tipo_inf_p in ('PREXM')) then
	begin
	
	select 	count(distinct nr_sequencia)
	into STRICT	qt_total_os_w
	from	os_recebida_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and      ((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1))
	and	a.nr_seq_grupo_des in (	SELECT	x.nr_sequencia
					from	grupo_desenvolvimento x
					where	x.nr_seq_gerencia in (20,21));
	
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	<> 'W'
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1))
	and	a.nr_seq_grupo_des in (	SELECT	x.nr_sequencia
					from	grupo_desenvolvimento x
					where	x.nr_seq_gerencia in (20,21));
	end;
end if;

/*Retorna a quantidade de erros encontrados pelo VV */

if (ie_tipo_inf_p in ('PRVEV')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	= 'W'
	and	nr_seq_equipamento in (2897,5818)
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de erros considerando o DOC ERRO que foram identificados internamente 

na Wheb*/
if (ie_tipo_inf_p in ('ERI')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	= 'W'
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de erros considerando o DOC ERRO que foram identificados externamente 

pelos clientes*/
if (ie_tipo_inf_p in ('ERE')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	<> 'W'
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de OS encerrada que passou pelo Desenvolvimento/Tecnologia*/

if (ie_tipo_inf_p = 'EN') then
	begin
	select   count(*)
	into STRICT	 qt_os_encerrada_w
	from     os_encerrada_gerencia_v a
	where	((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and	dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de OS encerrada com Grau de Satisfação*/

if (ie_tipo_inf_p in ('PRI','ENS')) then
	begin
	select   count(*)
	into STRICT	 qt_os_encerrada_classif_w
	from     os_encerrada_satisf_gerencia_v a
	where   ((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and	dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

/*Retorna a quantidade de OS encerrada com Grau de Satisfação Irregular*/

if (ie_tipo_inf_p in ('QTI','PRI')) then
	begin
	select	count(*)
	into STRICT	qt_os_insatisf_w
	from	os_insatisfacao_gerencia_v a
	where   ((nr_seq_gerencia_p = 0) or (NR_SEQ_GERENCIA = nr_seq_gerencia_p))
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and	dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

if (ie_tipo_inf_p in ('VEVOS')) then
	begin
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	= 'W'
	and	nr_seq_equipamento in (2897,5818)
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	end;
end if;

if (ie_tipo_inf_p in ('PHIOS')) then
	
	select	count(distinct nr_sequencia)
	into STRICT	qt_erro_w
	from	os_erro_gerencia_v a
	where	dt_ordem_servico between dt_ref_mes_w and dt_fim_mes_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_ident_erro	= 'W'
	and	nr_seq_equipamento not in (2897,5818)
	and	((a.nr_seq_localizacao = nr_seq_localizacao_p) or (nr_seq_localizacao_p = 0))
	and (nr_seq_gerencia = nr_seq_gerencia_p or nr_seq_gerencia_p = 0)
	and	((a.cd_funcao = cd_funcao_p) or (cd_funcao_p = -1));
	
end if;

if (ie_tipo_inf_p = 'QT') then
	return qt_total_os_w;
elsif (ie_tipo_inf_p = 'ER') or (ie_tipo_inf_p = 'ERI') or (ie_tipo_inf_p = 'ERE') then
	return qt_erro_w;
elsif (ie_tipo_inf_p = 'EN') then
	return qt_os_encerrada_w;
elsif (ie_tipo_inf_p = 'PR') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PRIN') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PREX') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PREXANO') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PREXP') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PREXO') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PREXM') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PRPHI') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'PRVEV') then
	return dividir(qt_erro_w, qt_total_os_w)*100;
elsif (ie_tipo_inf_p = 'QTI') then
	return qt_os_insatisf_w;
elsif (ie_tipo_inf_p = 'PRI') then
	return dividir(qt_os_insatisf_w, qt_os_encerrada_classif_w)*100;
elsif (ie_tipo_inf_p = 'ENS') then
	return qt_os_encerrada_classif_w;
elsif (ie_tipo_inf_p = 'VEVOS') then
	return qt_erro_w;
elsif (ie_tipo_inf_p = 'PHIOS') then
	return qt_os_philips_w;
elsif (ie_tipo_inf_p = 'QTEXT') then
	return	qt_erro_w;
elsif (ie_tipo_inf_p = 'QTPHI') then
	return	qt_erro_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_informacao_os_ger_loc ( dt_parametro_p timestamp, nr_seq_gerencia_p bigint, ie_tipo_inf_p text, ie_tipo_valor_p text, nr_seq_localizacao_p bigint, cd_funcao_p bigint default -1) FROM PUBLIC;

