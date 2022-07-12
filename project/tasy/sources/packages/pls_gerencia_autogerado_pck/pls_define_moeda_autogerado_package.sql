-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_autogerado_pck.pls_define_moeda_autogerado ( dt_mes_competencia_p pls_conta_proc_v.dt_mes_competencia%type, dt_referencia_p pls_conta_proc_v.dt_procedimento%type, nr_seq_prestador_exec_p pls_conta_proc_v.nr_seq_prestador_exec%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_regra_p INOUT bigint, vl_autogerado_p INOUT bigint, cd_moeda_p INOUT bigint, cd_prestador_exec_p pls_conta_proc_v.cd_prestador_exec%type, nr_seq_lote_p INOUT pls_lote_auto_gerado.nr_sequencia%type, dt_lote_p INOUT pls_lote_auto_gerado.dt_inicio%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type) AS $body$
DECLARE


										
/*
	A procedure dever? ser chamada dentro da PLS_DEFINE_PRECO_PROC;
	Somente deve ser executada se o procecimento for um autogerado;
	Fazer o cursor lendo a PLS_REGRA_PRECO_AUTOGERADO
	Se encontrar registro ent?o faz um SUm(qt_procedimento) do prestador 
		na PLS_CONTA_PROC do m?s anterior ao par?metro DT_REFERENCIA onde IE_AUTOGERADO = "S"
	Faz um sum(qt_procedimento) em toda a produ??o desse prestador do m?s anterior ao par?metro DT_REFERENCIA
	Com esses valores buscar a regra correspondente na tabela PLS_PRECO_AUTOGERADO
	Buscar a moeda e buscar o valor dela com a rotina obter_valor_cotacao_moeda_data(cd_moeda_w, dt_referencia_p)
	Na PLS_DEFINE_PRECO_PROC, se retornar valor de autogerado, ent?o utilizar esse valor
	
*/

nr_seq_regra_w		bigint;
pr_valor_total_w	double precision;
cd_moeda_w			bigint;
vl_autogerado_w		double precision;
nr_seq_lote_w		pls_lote_auto_gerado.nr_sequencia%type;
qt_cd_prest_w		bigint;
dt_utilizada_w		pls_conta_proc_v.dt_procedimento%type;
cd_moeda_regra_w	moeda.cd_moeda%type;
cd_especialidade_w	varchar(4000);
ie_valido_w			varchar(1);
cd_moeda_filha_w	pls_preco_regra_autogerado.cd_moeda%type;

C01 CURSOR FOR
	SELECT	a.cd_moeda,
			a.nr_sequencia nr_seq_autogerado,
			b.nr_seq_grupo_servico,
			b.nr_seq_grupo_prestador,
			b.cd_especialidade_prest,
			b.cd_moeda cd_moeda_regra_autogerado,
			b.nr_sequencia,
			(SELECT count(1) from cotacao_moeda where cd_moeda = b.cd_moeda and dt_cotacao <= dt_referencia_p) qt_cot_anterior_moeda_regra,
			a.nr_sequencia nr_seq_regra
	FROM pls_preco_autogerado a
LEFT OUTER JOIN pls_preco_regra_autogerado b ON (a.nr_sequencia = b.nr_seq_preco_auto)
WHERE a.ie_situacao = 'A'  and pr_valor_total_w between coalesce(pr_inicio,0) and coalesce(pr_fim,100) and dt_referencia_p between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia, dt_referencia_p) order by
			a.dt_inicio_vigencia,
			coalesce(b.nr_seq_grupo_servico,0),
			coalesce(b.nr_seq_grupo_prestador,0),
			coalesce(b.cd_especialidade_prest,0),
			qt_cot_anterior_moeda_regra;
	
BEGIN

--Primeiramente utiliza a data m?s compet?ncia do protocolo para localizar

--o ?ltimo lote gerado antes dessa data

nr_seq_lote_w := pls_gerencia_autogerado_pck.pls_obter_lote_autogerado(dt_mes_competencia_p, cd_prestador_exec_p);

--Caso  n?o encontrar nada com a data m?s protocolo, ent?o utiliza a data refer?ncia(Conforme vinha sendo utlizada)

if (coalesce(nr_seq_lote_w::text, '') = '') then

	nr_seq_lote_w := pls_gerencia_autogerado_pck.pls_obter_lote_autogerado(dt_referencia_p, cd_prestador_exec_p);

	dt_utilizada_w	:= dt_referencia_p;
else
	dt_utilizada_w	:= dt_mes_competencia_p;
end if;

select	count(1)
into STRICT	qt_cd_prest_w
from	pls_auto_ger_itens a
where	a.cd_prestador = cd_prestador_exec_p
and 	a.nr_seq_lote = nr_seq_lote_w;

if (qt_cd_prest_w	<> 0) then
	select	max(a.pr_total)
	into STRICT	pr_valor_total_w
	from	pls_auto_ger_itens	a
	where	a.cd_prestador = cd_prestador_exec_p
	and	a.nr_seq_lote = nr_seq_lote_w;
else
	select	max(a.pr_total)
	into STRICT	pr_valor_total_w
	from	pls_auto_ger_itens a
	where	a.nr_seq_prestador = nr_seq_prestador_exec_p
	and	a.nr_seq_lote = nr_seq_lote_w;
end if;	

if (coalesce(pr_valor_total_w::text, '') = '') then
	pr_valor_total_w	:= 0;
end if;
	
	cd_especialidade_w := null;
	cd_moeda_filha_w := null;
	for r_c01_w in C01 loop
	
		cd_moeda_w := r_C01_w.cd_moeda;
		nr_seq_regra_w := r_c01_w.nr_seq_regra;
		ie_valido_w := 'S';	
		if (r_C01_w.nr_seq_grupo_servico IS NOT NULL AND r_C01_w.nr_seq_grupo_servico::text <> '') then
			ie_valido_w := pls_se_grupo_preco_servico(r_C01_w.nr_seq_grupo_servico, cd_procedimento_p, ie_origem_proced_p);
		end if;
		
		if (r_C01_w.nr_seq_grupo_prestador IS NOT NULL AND r_C01_w.nr_seq_grupo_prestador::text <> '') and (ie_valido_w = 'S') then
			ie_valido_w := pls_obter_se_grupo_prestador( nr_seq_prestador_exec_p, r_C01_w.nr_seq_grupo_prestador );
		end if;
		
		if (r_C01_w.cd_especialidade_prest IS NOT NULL AND r_C01_w.cd_especialidade_prest::text <> '') and
			not(cd_especialidade_w like('%'||r_c01_w.cd_especialidade_prest||',%')) then
			ie_valido_w := 'N';
		end if;
		
		--Se n?o tem nenhuma cota??o vigente na moeda selecionada na regra filha, ent?o n?o considera v?lida

		if ( r_c01_w.qt_cot_anterior_moeda_regra =  0) then
		
			ie_valido_w := 'N';
		
		end if;
		
		if ( ie_valido_w = 'S') then

			cd_moeda_filha_w := r_C01_w.cd_moeda_regra_autogerado;
			
		end if;
	
	end loop;
	
-- se encontrou uma moeda em regra filha, prioriza ela ao inv?s da moeda da regra pai

if (cd_moeda_filha_w IS NOT NULL AND cd_moeda_filha_w::text <> '') then

	cd_moeda_w := cd_moeda_filha_w;
end if;


select	max(dt_inicio)
into STRICT	dt_lote_p
from	pls_lote_auto_gerado
where	nr_sequencia = nr_seq_lote_w;

nr_seq_lote_p	:= nr_seq_lote_w;

vl_autogerado_w	:= obter_valor_cotacao_moeda_data(cd_moeda_w, dt_referencia_p);
nr_seq_regra_p	:= nr_seq_regra_w;

vl_autogerado_p	:= vl_autogerado_w;

cd_moeda_p	:= cd_moeda_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_autogerado_pck.pls_define_moeda_autogerado ( dt_mes_competencia_p pls_conta_proc_v.dt_mes_competencia%type, dt_referencia_p pls_conta_proc_v.dt_procedimento%type, nr_seq_prestador_exec_p pls_conta_proc_v.nr_seq_prestador_exec%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_regra_p INOUT bigint, vl_autogerado_p INOUT bigint, cd_moeda_p INOUT bigint, cd_prestador_exec_p pls_conta_proc_v.cd_prestador_exec%type, nr_seq_lote_p INOUT pls_lote_auto_gerado.nr_sequencia%type, dt_lote_p INOUT pls_lote_auto_gerado.dt_inicio%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type) FROM PUBLIC;