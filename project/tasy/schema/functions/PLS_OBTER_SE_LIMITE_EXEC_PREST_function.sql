-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_limite_exec_prest ( nr_seq_ocor_lim_prest_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_preco_p text, qt_solicitada_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Verificar se o prestador ultrapassou o limite de cotas de procedimentos no mes (Dia 1º até dia 30 ou 31) 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
qt_registros_w			bigint;
qt_limite_execucao_w		bigint;
ds_retorno_w			varchar(2)	:= 'N';
nr_seq_grupo_servico_w		bigint;
ie_grupo_servico_w		varchar(2);
ie_preco_regra_w		varchar(255);

C01 CURSOR FOR 
	SELECT	nr_seq_grupo_servico 
	from	pls_limite_prestador_item 
	where	nr_seq_ocor_lim_prest	= nr_seq_ocor_lim_prest_p 
	and (coalesce(cd_procedimento::text, '') = '' or cd_procedimento	= cd_procedimento_p) 
	and (coalesce(ie_origem_proced::text, '') = ''	or ie_origem_proced	= ie_origem_proced_p) 
	order by coalesce(cd_procedimento,0), 
		 coalesce(nr_seq_grupo_servico,0);


BEGIN 
 
begin 
	select	qt_limite_execucao, 
		ie_preco 
	into STRICT	qt_limite_execucao_w, 
		ie_preco_regra_w 
	from	pls_ocorrencia_lim_prest 
	where	nr_sequencia	= nr_seq_ocor_lim_prest_p 
	and (coalesce(ie_preco::text, '') = '' or ie_preco	= ie_preco_p);
exception 
when others then 
	qt_limite_execucao_w	:= null;
	ie_preco_regra_w	:= null;
end;
 
select 	trunc(clock_timestamp(),'MM'), 
	trunc(last_day(clock_timestamp()),'DD') 
into STRICT	dt_inicio_w, 
	dt_fim_w
;
 
if (qt_limite_execucao_w	> 0) then 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_grupo_servico_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ie_grupo_servico_w	:= 'S';
		 
		if (nr_seq_grupo_servico_w IS NOT NULL AND nr_seq_grupo_servico_w::text <> '') then 
			ie_grupo_servico_w	:= pls_se_grupo_preco_servico(nr_seq_grupo_servico_w, cd_procedimento_p, ie_origem_proced_p);
		end if;
		 
		if (ie_grupo_servico_w	= 'S') then 
			if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
				select	sum(b.qt_autorizada) 
				into STRICT	qt_registros_w 
				from	pls_plano		c, 
					pls_guia_plano_proc	b, 
					pls_guia_plano		a 
				where	a.nr_sequencia		= b.nr_seq_guia 
				and	a.nr_seq_plano		= c.nr_sequencia 
				and	(((ie_preco_regra_w IS NOT NULL AND ie_preco_regra_w::text <> '') 
				and	c.ie_preco		= ie_preco_p) 
				or	coalesce(ie_preco_regra_w::text, '') = '') 
				and	a.nr_sequencia		<> nr_seq_guia_p 
				and	a.nr_seq_prestador	= nr_seq_prestador_p 
				and	a.ie_status		= 1 
				and	b.cd_procedimento	= cd_procedimento_p 
				and	b.ie_origem_proced	= ie_origem_proced_p 
				and	a.dt_solicitacao	between	dt_inicio_w and dt_fim_w;
				 
				if	((coalesce(qt_registros_w,0) + qt_solicitada_p)	> qt_limite_execucao_w) then 
					ds_retorno_w	:= 'S';
				end if;
			elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
				select	sum(b.qt_procedimento) 
				into STRICT	qt_registros_w 
				from	pls_plano		c, 
					pls_requisicao_proc	b, 
					pls_requisicao		a 
				where	a.nr_sequencia		= b.nr_seq_requisicao 
				and	a.nr_seq_plano		= c.nr_sequencia 
				and	(((ie_preco_regra_w IS NOT NULL AND ie_preco_regra_w::text <> '') 
				and	c.ie_preco		= ie_preco_p) 
				or	coalesce(ie_preco_regra_w::text, '') = '') 
				and	a.nr_sequencia		<> nr_seq_requisicao_p 
				and	a.nr_seq_prestador	= nr_seq_prestador_p 
				and	a.ie_estagio		= 2 
				and	b.cd_procedimento	= cd_procedimento_p 
				and	b.ie_origem_proced	= ie_origem_proced_p 
				and	a.dt_requisicao		between	dt_inicio_w and dt_fim_w;
 
				if	((coalesce(qt_registros_w,0) + qt_solicitada_p)	> qt_limite_execucao_w) then 
					ds_retorno_w	:= 'S';
				end if;
			elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then 
				select	sum(b.qt_item) 
				into STRICT	qt_registros_w 
				from	pls_plano		d, 
					pls_requisicao		c, 
					pls_execucao_req_item	b, 
					pls_execucao_requisicao	a 
				where	a.nr_sequencia		= b.nr_seq_execucao 
				and	a.nr_seq_requisicao	= c.nr_sequencia 
				and	c.nr_seq_plano		= d.nr_sequencia 
				and	(((ie_preco_regra_w IS NOT NULL AND ie_preco_regra_w::text <> '') 
				and	d.ie_preco		= ie_preco_p) 
				or	coalesce(ie_preco_regra_w::text, '') = '') 
				and	a.nr_sequencia		<> nr_seq_execucao_p 
				and	a.nr_seq_prestador	= nr_seq_prestador_p 
				and	b.ie_situacao		in ('S','P') 
				and	b.cd_procedimento	= cd_procedimento_p 
				and	b.ie_origem_proced	= ie_origem_proced_p 
				and	a.dt_execucao		between	dt_inicio_w and dt_fim_w;
 
				if	((coalesce(qt_registros_w,0) + qt_solicitada_p)	> qt_limite_execucao_w) then 
					ds_retorno_w	:= 'S';
				end if;
			end if;
		end if;
		end;
	end loop;
	close C01;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_limite_exec_prest ( nr_seq_ocor_lim_prest_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_preco_p text, qt_solicitada_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint) FROM PUBLIC;

