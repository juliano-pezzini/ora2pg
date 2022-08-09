-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_profissionais_duplic ( nr_seq_proc_p bigint, nr_Seq_conta_p bigint, nr_seq_segurado_p bigint, cd_guia_referencia_p text, nr_Seq_grau_partic_p bigint, nr_seq_proc_partic_p bigint, nm_usuario_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp, ds_observacao_p INOUT text, ie_duplicado_p INOUT text, nr_Seq_estrutura_oc_p bigint, cd_area_procedimento_regra_p bigint, cd_especialidade_regra_p bigint, cd_grupo_proc_regra_p bigint, cd_medico_p text) AS $body$
DECLARE


nr_Seq_proc_partic_w		bigint;
nr_seq_conta_dup_w		bigint;
nm_profissional_w		varchar(255);
cd_procedimento_ww		bigint;
ie_origem_proced_ww		bigint;
ie_estrutura_ww			varchar(1);
ds_observacao_w			varchar(4000);
ds_grau_partic_w		varchar(255);
nr_seq_grau_partic_w		bigint;
ie_estrutura_ok_w		varchar(1);
qt_mesmo_grau_partic_w		bigint;
nr_Seq_conta_dup_ww		bigint;
ie_tipo_guia_conta_w		varchar(2);
cd_medico_dup_w			varchar(10);
ie_tipo_guia_conta_dup_w	varchar(2);
cd_medico_w			varchar(10);
qt_existe_w			smallint;
qt_hi_gerada_w			bigint;
nr_seq_participante_hi_w	bigint;
dt_procedimento_w		timestamp;
dt_inicio_proc_w		varchar(15);
dt_fim_proc_w			varchar(15);
nr_seq_proc_ref_w		bigint;
nr_seq_conta_proc_w		bigint;
qt_aux_w			bigint	:= 0;
nm_profissional_ant_w		varchar(255)	:= '';
nr_seq_conta_proc_ant_w		bigint	:= 0;
nr_seq_proc_princ_w		bigint;
qt_participante_w		bigint;
qt_partic_cancelado_w		bigint;
qt_medico_partic_w		bigint;
nm_profissional_ant_ww		varchar(255)	:= '';
nm_medico_executor_imp_w	varchar(255);
/*LITORAL 1099*/

--mesmo item
C03 CURSOR FOR
	SELECT	/*+ USE_CONCAT */		c.nr_sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		substr(obter_nome_pf(b.cd_medico),1,255) nm_medico,
		a.nr_sequencia,
		b.nm_medico_executor_imp
	from 	pls_conta_proc 		a,
		pls_proc_participante 	b,
		pls_conta		c
	where 	a.nr_sequencia 		= b.nr_seq_conta_proc
	and	c.nr_sequencia 		= a.nr_seq_conta
	and	coalesce(a.ie_glosa,'N')	<> 'S'
	and	trunc(a.dt_procedimento,'dd')	= trunc(dt_procedimento_w,'dd')
	and	((to_char(a.dt_inicio_proc,'hh24:mi:ss')	= dt_inicio_proc_w)  or
		((coalesce(dt_inicio_proc_w::text, '') = '') and (coalesce(a.dt_inicio_proc::text, '') = '')))
	and	((to_char(a.dt_fim_proc,'hh24:mi:ss')	= dt_fim_proc_w) or (coalesce(dt_fim_proc_w::text, '') = '') or (coalesce(a.dt_fim_proc::text, '') = ''))
	and	a.cd_procedimento	= cd_procedimento_p
	and	a.ie_origem_proced	= ie_origem_proced_p
	and	c.cd_guia_ok 		= cd_guia_referencia_p
	and	c.nr_seq_segurado 	=  nr_seq_segurado_p
	and	coalesce(b.nr_seq_grau_partic,0) 	= coalesce(nr_seq_grau_partic_p ,0)
	and	coalesce(b.ie_status,'U')	<> 'C'
	and	a.ie_status	!= 'D'
	order by 	b.cd_medico,
			a.nr_sequencia;
--outras contas com equipe
C02 CURSOR FOR
	SELECT	/*+ USE_CONCAT */		c.nr_Sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		b.cd_medico,
		c.ie_tipo_guia,
		b.nr_seq_grau_partic
	from 	pls_conta_proc 		a,
		pls_proc_participante 	b,
		pls_conta		c
	where 	a.nr_Sequencia 		= b.nr_Seq_conta_proc
	and (coalesce(b.nr_seq_grau_partic,0) = coalesce(nr_seq_grau_partic_p ,0))--mesmo grau
	and	c.nr_sequencia 		= a.nr_seq_conta
	and	c.nr_sequencia 		<> nr_seq_conta_p  --outra conta
	and	c.nr_seq_segurado 	=  nr_seq_segurado_p  --mesmo benef
	and	trunc(a.dt_procedimento) 		= trunc(dt_procedimento_p) --mesma data de procedimento
	and	c.cd_guia_ok 		= cd_guia_referencia_p  --dentro do mesmo atendimento
	and (to_char(a.dt_inicio_proc,'hh24:mi:ss')	= dt_inicio_proc_w)
	and 	coalesce(a.ie_glosa,'N') <> 'S'
	and	coalesce(b.ie_status,'U')	<> 'C'
	and	coalesce(a.nr_Seq_proc_princ::text, '') = ''
	and	a.ie_status	!= 'D'
	and	coalesce(b.IE_GERADA_CTA_HONORARIO,'N') <> 'S'
	and	not exists (	SELECT	1
			from	pls_conta_proc x
			where	b.nr_sequencia	= x.nr_seq_participante_hi);

-- Outras contas sem participante
C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.cd_procedimento,
		a.ie_origem_proced,
		b.cd_medico_executor,
		b.nr_seq_grau_partic,
		a.nr_seq_participante_hi,
		b.ie_tipo_guia
	from 	pls_conta_proc		a,
		pls_conta		b
	where 	a.nr_Seq_conta 		= b.nr_sequencia
	and	coalesce(b.nr_seq_grau_partic,0) 	= coalesce(nr_Seq_grau_partic_p,0) --mesmo grau
	and	b.nr_sequencia 		<> nr_Seq_conta_p  --outro item
	and	b.nr_seq_segurado 	=  nr_seq_segurado_p  --mesmo benef
	and	trunc(a.dt_procedimento) 		= trunc(dt_procedimento_p) --mesma data de procedimento
	and	b.cd_guia_ok 		= cd_guia_referencia_p  --dentro do mesmo atendimento
	and (to_char(a.dt_inicio_proc,'hh24:mi:ss')	= dt_inicio_proc_w)
	and 	coalesce(a.ie_glosa,'N') <> 'S'
	and	a.ie_status	!= 'D'
	and	coalesce(a.nr_Seq_proc_princ::text, '') = ''
	and	not exists (	SELECT 	1
				from  	pls_proc_participante
				where	nr_Seq_conta_proc = a.nr_sequencia
				and	coalesce(ie_status,'U')	<> 'C'
				and (coalesce(IE_GERADA_CTA_HONORARIO,'N') <> 'S'));


BEGIN
ds_observacao_p	:= '';
ie_duplicado_p	:= 'N';

begin
	select	coalesce(a.dt_procedimento,clock_timestamp()),
		to_char(a.dt_inicio_proc,'hh24:mi:ss'),
		to_char(a.dt_fim_proc,'hh24:mi:ss'),
		b.ie_tipo_guia,
		a.nr_seq_proc_ref,
		a.nr_seq_proc_princ
	into STRICT	dt_procedimento_w,
		dt_inicio_proc_w,
		dt_fim_proc_w,
		ie_tipo_guia_conta_w,
		nr_seq_proc_ref_w,
		nr_seq_proc_princ_w
	from	pls_conta_proc	a,
		pls_conta	b
	where	b.nr_sequencia 	= a.nr_seq_conta
	and	a.nr_sequencia	= nr_Seq_proc_p;
exception
when others then
	dt_procedimento_w	:= null;
	dt_inicio_proc_w	:= null;
	dt_fim_proc_w		:= null;
end;

/*VERIFICA AS CONTAS QUE NAO POSSUEM PARTICIPANTES MAS TEM GRAU DE PARTICIPAÇÃO NA CONTA, GUIAS DE HI POR EXEMPLO*/

select	count(1)
into STRICT	qt_mesmo_grau_partic_w
from 	pls_conta_proc 		a,
	pls_proc_participante 	b,
	pls_conta		c
where 	a.nr_Sequencia 		= b.nr_Seq_conta_proc
and	c.nr_sequencia		= a.nr_seq_conta
and	b.nr_seq_grau_partic 	= nr_Seq_grau_partic_p
and	trunc(a.dt_procedimento,'dd')	= trunc(dt_procedimento_w,'dd')
and	((to_char(a.dt_inicio_proc,'hh24:mi:ss')	= dt_inicio_proc_w)  or
	((coalesce(dt_inicio_proc_w::text, '') = '') and (coalesce(a.dt_inicio_proc::text, '') = '')))
and	((to_char(a.dt_fim_proc,'hh24:mi:ss')	= dt_fim_proc_w) or (coalesce(dt_fim_proc_w::text, '') = '') or (coalesce(a.dt_fim_proc::text, '') = ''))
and	a.cd_procedimento	= cd_procedimento_p
and	a.ie_origem_proced	= ie_origem_proced_p
and	a.ie_status	!= 'D'
and	coalesce(a.ie_glosa,'N')	<> 'S'
and	c.cd_guia_ok 		= cd_guia_referencia_p
and	c.nr_seq_segurado  	= nr_seq_segurado_p
and	not exists (	SELECT	1
			from	pls_conta_proc x
			where	b.nr_sequencia	= x.nr_seq_participante_hi);
/*VERIFICA GRAU DE PARTICIPAÇÃO DUPLICADO NO MESMO ITEM*/

if (qt_mesmo_grau_partic_w > 1) then
	qt_medico_partic_w := 0;
	open C03;
	loop
	fetch C03 into
		nr_seq_conta_dup_w,
		cd_procedimento_ww,
		ie_origem_proced_ww,
		nm_profissional_w,
		nr_seq_conta_proc_w,
		nm_medico_executor_imp_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		ie_estrutura_ww		:= '';
		ie_estrutura_ok_w 	:= '';

		if (coalesce(nm_medico_executor_imp_w,'X') <> 'X' )	and (coalesce(nm_profissional_w,'X') = 'X')		then
			nm_profissional_w	:= nm_medico_executor_imp_w;
		end if;

		if (coalesce(nm_profissional_w,'X')	<>	coalesce(nm_profissional_ant_ww,'X')) then
			nm_profissional_ant_ww := nm_profissional_w;
			begin
				select	ds_grau_participacao
				into STRICT	ds_grau_partic_w
				from 	pls_grau_participacao
				where 	nr_sequencia 	= nr_Seq_grau_partic_p;
			exception
			when others then
				ds_grau_partic_w	:= '_';
			end;
			ds_observacao_w		:= substr(ds_observacao_w||	' Mesmo item: '||nr_seq_conta_dup_w||
										--' Profissional.: '||nm_profissional_w|| Retirado o profissional, pois a regra é de participacao e item OS - 424313
										' Grau partic.: '||ds_grau_partic_w||chr(13)||chr(10) ,1,4000);
			qt_medico_partic_w := qt_medico_partic_w +1;
		end if;
		if	(((coalesce(nm_profissional_w,'X')	<>	coalesce(nm_profissional_ant_w,'X')) and (coalesce(nr_seq_conta_proc_w,0) 	<> 	coalesce(nr_seq_conta_proc_ant_w,0)))or
			((coalesce(nm_profissional_w,'X')	=	coalesce(nm_profissional_ant_w,'X')) and (coalesce(nr_seq_conta_proc_w,0) 	= 	coalesce(nr_seq_conta_proc_ant_w,0))) or
			((coalesce(nm_profissional_w,'X')	<>	coalesce(nm_profissional_ant_w,'X')) and (coalesce(nr_seq_conta_proc_w,0) 	= 	coalesce(nr_seq_conta_proc_ant_w,0)))) then
			qt_aux_w := qt_aux_w + 1;
			nm_profissional_ant_w 	:= nm_profissional_w;
			nr_seq_conta_proc_ant_w := nr_seq_conta_proc_w;
		end if;

		if (qt_aux_w > 1) then
			ie_duplicado_p		:= 'S';
		end if;

		end;
	end loop;
	close C03;
end if;
if	not(qt_medico_partic_w > 1) then
	ds_observacao_w := '';
end if;
/*verifica grau de participação duplicado em outras contas*/

open C02;
loop
fetch C02 into
	nr_seq_conta_dup_w,
	cd_procedimento_ww,
	ie_origem_proced_ww,
	cd_medico_dup_w,
	ie_tipo_guia_conta_dup_w,
	nr_seq_grau_partic_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	ie_estrutura_ww		:= 'N';
	ie_estrutura_ok_w 	:= 'N';

	if (coalesce(nr_seq_conta_dup_ww,0) <> coalesce(nr_seq_conta_dup_w,0) ) then
		/*verifica se o serviço da possivel conta duplicada é da mesma estrutura informada na regra*/

		if	(cd_procedimento_ww = cd_procedimento_p AND ie_origem_proced_ww = ie_origem_proced_p) then

			if (ie_tipo_guia_conta_dup_w = '6') and (ie_tipo_guia_conta_w = '5') then
				begin
					select 	1
					into STRICT	qt_existe_w
					from 	pls_conta 		a,
						pls_conta_proc 		b,
						pls_proc_participante 	c
					where	a.nr_Sequencia 		= b.nr_seq_conta
					and	c.nr_seq_conta_proc 	= b.nr_Sequencia
					and	b.nr_Sequencia 		= nr_seq_proc_p
					and	c.nr_Seq_grau_partic	= nr_seq_grau_partic_w
					and	c.cd_medico 		= cd_medico_dup_w
					and	coalesce(c.ie_status,'U')	<> 'C'
					and (coalesce(c.IE_GERADA_CTA_HONORARIO,'N') <> 'S')
					and	coalesce(b.nr_seq_proc_princ::text, '') = ''
					
union all

					SELECT 	1
					from 	pls_conta 		a,
						pls_conta_proc 		b
					where	a.nr_Sequencia 		= b.nr_seq_conta
					and	b.nr_Sequencia 		= nr_seq_proc_p
					and	a.nr_Seq_grau_partic	= nr_seq_grau_partic_w
					and	a.cd_medico_executor	= cd_medico_dup_w
					and	coalesce(b.nr_seq_proc_princ::text, '') = '';
				exception
				when others then
					qt_existe_w	:= 0;
				end;

				if (qt_existe_w > 0) then
					goto final1;
				end if;
			end if;

			select  substr(obter_nome_pf(cd_medico_dup_w),1,255)
			into STRICT    nm_profissional_w
			;

			begin
				select	ds_grau_participacao
				into STRICT	ds_grau_partic_w
				from 	pls_grau_participacao
				where 	nr_sequencia 	= nr_Seq_grau_partic_p;
			exception
			when others then
				ds_grau_partic_w	:= '_';
			end;
			ds_observacao_w		:= substr(ds_observacao_w||'# Conta: '||nr_seq_conta_dup_w||
									--'      Profissional.: '||nm_profissional_w||
									'      Grau partic.: '||ds_grau_partic_w||chr(13)||chr(10) ,1,4000);

			ie_duplicado_p		:= 'S';
			nr_seq_conta_dup_ww	:= nr_seq_conta_dup_w;
		end if;
	end if;

	<<final1>>

	ie_duplicado_p := ie_duplicado_p;

	end;
end loop;
close C02;

select	count(1)
into STRICT	qt_participante_w
from	pls_conta_proc  b,
	pls_proc_participante a
where	b.nr_sequencia = nr_seq_proc_p
and	b.nr_sequencia = a.nr_seq_conta_proc;

select	count(1)
into STRICT	qt_partic_cancelado_w
from	pls_conta_proc  b,
	pls_proc_participante a
where	b.nr_sequencia = nr_seq_proc_p
and	((coalesce(a.ie_status,'U') 	= 'C') or (coalesce(IE_GERADA_CTA_HONORARIO,'N') = 'S'))
and	b.nr_sequencia = a.nr_seq_conta_proc;

if (qt_partic_cancelado_w <> qt_participante_w) or (qt_participante_w = 0 ) then
--Verifica as contas que nao tem participantes mas tem grau informado na conta.
	open C01;
	loop
	fetch C01 into
		nr_seq_conta_dup_w,
		cd_procedimento_ww,
		ie_origem_proced_ww,
		cd_medico_w,
		nr_seq_grau_partic_w,
		nr_seq_participante_hi_w,
		ie_tipo_guia_conta_dup_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (coalesce(nr_Seq_conta_dup_ww,0) <> coalesce(nr_seq_conta_dup_w,0)) and (coalesce(nr_seq_participante_hi_w,9999) <> coalesce(nr_seq_proc_partic_p,0)) then
			ie_estrutura_ww		:= null;
			ie_estrutura_ok_w 	:= null;

			/*verifica se o serviço da possivel conta duplicada é da mesma estrutura informada na regra*/

			if	(cd_procedimento_ww = cd_procedimento_p AND ie_origem_proced_ww = ie_origem_proced_p) then
				select  substr(obter_nome_pf(cd_medico_w),1,255)
				into STRICT    nm_profissional_w
				;

				begin
					select	ds_grau_participacao
					into STRICT	ds_grau_partic_w
					from 	pls_grau_participacao
					where 	nr_sequencia 	= nr_Seq_grau_partic_p;
				exception
				when others then
					ds_grau_partic_w	:= '_';
				end;

				ds_observacao_w		:= substr(ds_observacao_w||'$ Conta: '||nr_seq_conta_dup_w||
										--'      Profissional.: '||nm_profissional_w||
										'      Grau partic.: '||ds_grau_partic_w||chr(13)||chr(10) ,1,4000);
				ie_duplicado_p		:= 'S';
				nr_Seq_conta_dup_ww	:=  nr_Seq_conta_dup_w;
			end if;
			<<final>>
			ie_duplicado_p := ie_duplicado_p;


		end if;
		end;
	end loop;
	close C01;
end if;

ds_observacao_p	:= ds_observacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_profissionais_duplic ( nr_seq_proc_p bigint, nr_Seq_conta_p bigint, nr_seq_segurado_p bigint, cd_guia_referencia_p text, nr_Seq_grau_partic_p bigint, nr_seq_proc_partic_p bigint, nm_usuario_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp, ds_observacao_p INOUT text, ie_duplicado_p INOUT text, nr_Seq_estrutura_oc_p bigint, cd_area_procedimento_regra_p bigint, cd_especialidade_regra_p bigint, cd_grupo_proc_regra_p bigint, cd_medico_p text) FROM PUBLIC;
