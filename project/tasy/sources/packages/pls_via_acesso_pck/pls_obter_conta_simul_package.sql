-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_via_acesso_pck.pls_obter_conta_simul ( dt_procedimento_p timestamp, dt_inicio_proc_p timestamp, dados_conta_p pls_via_acesso_pck.dados_conta, nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE
	
--Rotina mais importante do processo de via de acesso responsável pela verificação se o procedimento se encaixa na regra que se está verificando
ie_retorno_w			varchar(1)	:= 'N';
qt_proc_conta_tot_w		integer	:= 0;
ie_pegou_w			varchar(15)	:= 'N';
qt_max_proced_w			pls_proc_via_acesso.qt_proc_final%type;
qt_min_proced_w			pls_proc_via_acesso.qt_procedimento%type;
cd_proc_regra_w			pls_proc_via_acesso.cd_procedimento%type;
ie_origem_proced_regra_w	pls_proc_via_acesso.ie_origem_proced%type;
ie_valido_w			varchar(255)	:= 'S';
qt_proc_regra_w			integer;
ie_considerar_horario_w		pls_proc_via_acesso.ie_considerar_horario%type;
qt_horario_w			pls_proc_via_acesso.qt_horario%type;
ie_tipo_qt_horario_w		pls_proc_via_acesso.ie_tipo_qt_horario%type;
qt_minuto_w			integer;

--Irá varer as regras	
C00 CURSOR(nr_seq_regra_pc	pls_proc_via_acesso.nr_seq_regra%type)FOR
	SELECT	max(a.qt_procedimento) 	qt_procedimento,
		sum(a.qt_proc_final)	qt_proc_final,
		a.cd_procedimento	cd_procedimento,
		a.ie_origem_proced	ie_origem_proced,	
		coalesce(max(a.ie_considerar_horario),'S') ie_considerar_horario,
		coalesce(max(a.qt_horario),0)	qt_horario,
		max(a.ie_tipo_qt_horario)	ie_tipo_qt_horario
	from	pls_proc_via_acesso a
	where	a.nr_seq_regra		= nr_seq_regra_pc
	and	a.ie_situacao		= 'A'
	group by a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_seq_grupo_servico;
		
--Irá varer os procedimento respeitando a data e a guia de referencia
C01 CURSOR(	cd_guia_referencia_pc		pls_conta_proc_v.cd_guia_referencia%type,
		nr_seq_segurado_pc		pls_conta_proc_v.nr_seq_segurado%type,
		dt_procedimento_pc		pls_conta_proc_v.dt_procedimento_trunc%type,
		hr_inicio_proc_pc		pls_conta_proc_v.hr_inicio_proc%type,
		ie_considerar_horario_pc	pls_proc_via_acesso.ie_considerar_horario%type,
		qt_minuto_pc			integer)FOR
	SELECT	a.qt_procedimento_imp,
		a.cd_procedimento,
		a.ie_origem_proced
	from	pls_conta_proc_v	a
	where	a.nr_seq_segurado	= nr_seq_segurado_pc
	and	a.ie_via_obrigatoria	= 'S'
	and	((cd_guia_referencia_pc = a.cd_guia_referencia) or (cd_guia_referencia_pc = a.cd_guia)
	or (coalesce(cd_guia_referencia_pc::text, '') = '' and coalesce(a.cd_guia_referencia::text, '') = '' and coalesce(a.cd_guia::text, '') = ''))
	and	a.dt_procedimento_trunc	= dt_procedimento_pc
	and	((a.hr_inicio_proc	= hr_inicio_proc_pc AND ie_considerar_horario_pc = 'S') or
		((pls_obter_minutos_intervalo(a.hr_inicio_proc,hr_inicio_proc_pc, qt_minuto_pc) = 'S')and (ie_considerar_horario_pc = 'N')))
	and	a.ie_glosa		= 'N'
	and	coalesce(a.nr_seq_proc_ref::text, '') = ''
	order by	a.cd_procedimento,
			a.ie_origem_proced;

BEGIN

ie_retorno_w	:= 'N';

for r_C00_w in C00(nr_seq_regra_p) loop
	begin
	qt_min_proced_w			:= r_C00_w.qt_procedimento;
	qt_max_proced_w			:= r_C00_w.qt_proc_final;
	cd_proc_regra_w			:= r_C00_w.cd_procedimento;
	ie_origem_proced_regra_w	:= r_C00_w.ie_origem_proced;
	ie_considerar_horario_w		:= r_C00_w.ie_considerar_horario;
	qt_horario_w			:= r_C00_w.qt_horario;
	ie_tipo_qt_horario_w		:= r_C00_w.ie_tipo_qt_horario;
	qt_proc_conta_tot_w		:= 0;
	ie_pegou_w			:= 'S';
	if (ie_tipo_qt_horario_w = 'H') then
		qt_minuto_w := coalesce(qt_horario_w,0) * 60;
	elsif (ie_tipo_qt_horario_w = 'M') then
		qt_minuto_w := coalesce(qt_horario_w,0);
	end if;
	if (ie_valido_w = 'S') then
		-- Verificar se todos os procedimentos com mesmo horário estão dentro da regra de via de acesso
		--Será verificado se na conta existe agum procedimento que não se encaixa na via de acesso no caso do retorno ser positivo a regra será inválida
		select	count(1)
		into STRICT	qt_proc_regra_w
		from	pls_conta_proc_v	a
		where	a.nr_seq_segurado	= dados_conta_p.nr_seq_segurado
		and	a.ie_via_obrigatoria	= 'S'
		and	((dados_conta_p.cd_guia_referencia = a.cd_guia_referencia) or (dados_conta_p.cd_guia_referencia = a.cd_guia)
		or (coalesce(dados_conta_p.cd_guia_referencia::text, '') = '' and coalesce(a.cd_guia_referencia::text, '') = '' and coalesce(a.cd_guia::text, '') = ''))
		and	a.dt_procedimento_trunc	= dt_procedimento_p
		and	((a.hr_inicio_proc	= dt_inicio_proc_p AND ie_considerar_horario_w = 'S') or
			((pls_obter_minutos_intervalo(a.hr_inicio_proc,dt_inicio_proc_p, qt_minuto_w) = 'S')and (ie_considerar_horario_w = 'N')))
		and	a.ie_glosa		= 'N'
		and	coalesce(a.nr_seq_proc_ref::text, '') = ''
		and	((coalesce(a.ie_status::text, '') = '' ) or ( a.ie_status 	!= 'D'))
		and	not exists (	SELECT	1
					from	pls_proc_via_acesso b
					where	b.cd_procedimento	= a.cd_procedimento
					and	b.ie_origem_proced	= a.ie_origem_proced
					and	b.nr_seq_regra		= nr_seq_regra_p
					and	b.ie_situacao		= 'A');
		if (qt_proc_regra_w = 0) then
			--Irá verificar se existe alguma regra válida para o procedimento em questão além de ser verificado se a quantidade de procedimento é permitida pela regra de quantidade de execução
	
			for r_C01_w in C01(	dados_conta_p.cd_guia_referencia,
						dados_conta_p.nr_seq_segurado,
						dt_procedimento_p,
						dt_inicio_proc_p,
						ie_considerar_horario_w,
						qt_minuto_w) loop
				begin
				
				
				
				if (r_C01_w.cd_procedimento	= cd_proc_regra_w) and (r_C01_w.ie_origem_proced	= ie_origem_proced_regra_w) then
					qt_proc_conta_tot_w	:= qt_proc_conta_tot_w + r_C01_w.qt_procedimento_imp;
				
				end if;
				end;
			end loop;
			
			if	not (qt_proc_conta_tot_w >= qt_min_proced_w AND qt_proc_conta_tot_w <= qt_max_proced_w) then
			
				ie_valido_w := 'N';	
			end if;
		else
			ie_valido_w := 'N';
		
		end if;
	end if;
	
	end;
end loop;

if (ie_pegou_w = 'S') then
	ie_retorno_w	:= ie_valido_w;
end if;

return	ie_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_via_acesso_pck.pls_obter_conta_simul ( dt_procedimento_p timestamp, dt_inicio_proc_p timestamp, dados_conta_p pls_via_acesso_pck.dados_conta, nr_seq_regra_p bigint) FROM PUBLIC;