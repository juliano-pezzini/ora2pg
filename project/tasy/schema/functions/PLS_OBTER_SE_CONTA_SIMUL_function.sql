-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_conta_simul ( dt_procedimento_p timestamp, dt_inicio_proc_p timestamp, dt_fim_proc_p timestamp, nr_seq_conta_p bigint, nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1)	:= 'N';
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_proc_conta_w			bigint	:= 0;
qt_proc_conta_tot_w		bigint	:= 0;
cd_guia_referencia_w		varchar(20);
nr_seq_segurado_w		bigint;
dt_inicio_proc_w		varchar(15);
ie_pegou_w			varchar(15)	:= 'N';
qt_max_proced_w			bigint;
qt_min_proced_w			bigint;
cd_proc_regra_w			bigint;
ie_origem_proced_regra_w	bigint;
ie_valido_w			varchar(255)	:= 'S';
qt_proc_regra_conta_w		bigint;
ie_via_acesso_w			varchar(255);
qt_conta_regra_proc_w		bigint;
qt_proc_regra_w			bigint;
dt_procedimento_w		timestamp;
dt_proc_fim_dia_w		timestamp;
ie_considerar_horario_w		varchar(1);
qt_horario_w			smallint;
ie_tipo_qt_horario_w		varchar(5);
qt_minuto_w			bigint;

C00 CURSOR FOR
	SELECT	max(a.qt_procedimento),
		sum(a.qt_proc_final),
		a.cd_procedimento,
		a.ie_origem_proced,
		max(a.ie_via_acesso),
		max(a.ie_considerar_horario),
		coalesce(max(a.qt_horario),0),
		max(a.ie_tipo_qt_horario)
	from	pls_proc_via_acesso a
	where	a.nr_seq_regra		= nr_seq_regra_p
	and	a.ie_situacao		= 'A'
	group by a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_seq_grupo_servico;

C01 CURSOR FOR
	SELECT	/*+ USE_CONCAT */		b.qt_procedimento_imp,
		b.cd_procedimento,
		b.ie_origem_proced
	from	pls_conta_proc	b,
		pls_conta	c
	where	b.nr_seq_conta		= c.nr_sequencia
	and	((cd_guia_referencia_w = c.cd_guia_referencia) or (cd_guia_referencia_w = c.cd_guia)
	or (coalesce(cd_guia_referencia_w::text, '') = '' and coalesce(c.cd_guia_referencia::text, '') = '' and coalesce(c.cd_guia::text, '') = ''))
	and	c.nr_seq_segurado	= nr_seq_segurado_w
	and	coalesce(b.ie_via_obrigatoria,'N') 	= 'S'
	and	trunc(b.dt_procedimento,'dd')= trunc(dt_procedimento_p,'dd')
	and	(((to_char(b.dt_inicio_proc,'hh24:mi:ss')	= to_char(dt_inicio_proc_p,'hh24:mi:ss')) and (coalesce(ie_considerar_horario_w,'S') = 'S')) or
		((pls_obter_minutos_intervalo(b.dt_inicio_proc,dt_inicio_proc_p, qt_minuto_w) = 'S')and (ie_considerar_horario_w = 'N')))
	and	((coalesce(b.ie_glosa::text, '') = '') or (b.ie_glosa <> 'S'))
	and	coalesce(b.nr_seq_proc_ref::text, '') = ''
	order by	b.cd_procedimento,
			b.ie_origem_proced;


BEGIN
/* se existe na conta os procedimentos da regra*/

select	coalesce(coalesce(cd_guia_referencia,cd_guia),'0'),
	nr_seq_segurado
into STRICT	cd_guia_referencia_w,
	nr_seq_segurado_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

ie_retorno_w	:= 'N';

open C00;
loop
fetch C00 into
	qt_min_proced_w,
	qt_max_proced_w,
	cd_proc_regra_w,
	ie_origem_proced_regra_w,
	ie_via_acesso_w,
	ie_considerar_horario_w,
	qt_horario_w,
	ie_tipo_qt_horario_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin
	qt_proc_conta_tot_w	:= 0;
	ie_pegou_w		:= 'S';
	if (ie_tipo_qt_horario_w = 'H') then
		qt_minuto_w := coalesce(qt_horario_w,0) * 60;
	elsif (ie_tipo_qt_horario_w = 'M') then
		qt_minuto_w := coalesce(qt_horario_w,0);
	end if;

	if (ie_valido_w = 'S') then
		-- Verificar se todos os procedimentos com mesmo horário estão dentro da regra de via de acesso
		select	/*+ USE_CONCAT */			count(1)
		into STRICT	qt_proc_regra_w
		from	pls_conta_proc	b,
			pls_conta	c
		where	b.nr_seq_conta		= c.nr_sequencia
		and	((cd_guia_referencia_w = c.cd_guia_referencia) or (cd_guia_referencia_w = c.cd_guia)
		or (coalesce(cd_guia_referencia_w::text, '') = '' and coalesce(c.cd_guia_referencia::text, '') = '' and coalesce(c.cd_guia::text, '') = ''))
		and	c.nr_seq_segurado	= nr_seq_segurado_w
		and	trunc(b.dt_procedimento,'dd')= trunc(dt_procedimento_p,'dd')
		and	(((to_char(b.dt_inicio_proc,'hh24:mi:ss')	= to_char(dt_inicio_proc_p,'hh24:mi:ss')) and (coalesce(ie_considerar_horario_w,'S') = 'S'))or
			((pls_obter_minutos_intervalo(b.dt_inicio_proc,dt_inicio_proc_p, qt_minuto_w) = 'S')and (ie_considerar_horario_w = 'N')))
		and	coalesce(b.ie_glosa,'N')	<> 'S'
		and	coalesce(b.ie_status,'U')	<> 'D'
		and	coalesce(b.nr_seq_proc_ref::text, '') = ''
		and	coalesce(b.ie_via_obrigatoria,'N') = 'S'
		and	not exists (	SELECT	/*+ USE_CONCAT */ 1
					from	pls_proc_via_acesso a
					where	a.cd_procedimento	= b.cd_procedimento
					and	a.ie_origem_proced	= b.ie_origem_proced
					and	a.nr_seq_regra		= nr_seq_regra_p
					and	a.ie_situacao		= 'A')  LIMIT 1;

		if (qt_proc_regra_w = 0) then
			open C01;
			loop
			fetch C01 into
				qt_proc_conta_w,
				cd_procedimento_w,
				ie_origem_proced_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin

				if (cd_procedimento_w	= cd_proc_regra_w) and (ie_origem_proced_w	= ie_origem_proced_regra_w) then
					qt_proc_conta_tot_w	:= qt_proc_conta_tot_w + qt_proc_conta_w;
				end if;
				end;
			end loop;
			close C01;

			if	not (qt_proc_conta_tot_w >= qt_min_proced_w AND qt_proc_conta_tot_w <= qt_max_proced_w) then

				ie_valido_w := 'N';
			end if;
		else
			ie_valido_w := 'N';
		end if;
	end if;
	end;
end loop;
close C00;

if (ie_pegou_w = 'S') then
	ie_retorno_w	:= ie_valido_w;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_conta_simul ( dt_procedimento_p timestamp, dt_inicio_proc_p timestamp, dt_fim_proc_p timestamp, nr_seq_conta_p bigint, nr_seq_regra_p bigint) FROM PUBLIC;
