-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_medico_partic_dif ( nr_seq_conta_p bigint, nr_seq_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


cd_guia_referencia_w		varchar(20);
cd_medico_w			varchar(10);
cd_medico_executor_w		varchar(10);
ie_tipo_guia_w			varchar(2);
ie_medico_partic_w		varchar(1) := 'N';
ie_retorno_w			varchar(1);
nr_seq_grau_partic_w		bigint;
nr_seq_partic_w			bigint;
qt_reg_w			bigint;
nr_seq_grau_partic_ww		bigint;
qt_participantes_w		bigint;

C01 CURSOR FOR
	SELECT	/*+USE_CONCAT*/		c.cd_medico,
		c.nr_seq_grau_partic,
		c.nr_sequencia
	from	pls_proc_participante	c,
		pls_conta_proc		b,
		pls_conta		a
	where	b.nr_sequencia		= c.nr_seq_conta_proc
	and	a.nr_sequencia		= b.nr_seq_conta
	and	b.cd_procedimento	= cd_procedimento_p
	and	b.ie_origem_proced 	= ie_origem_proced_p
	and	a.cd_guia		= cd_guia_referencia_w
	
union all

	SELECT	c.cd_medico,
		c.nr_seq_grau_partic,
		c.nr_sequencia
	from	pls_proc_participante	c,
		pls_conta_proc		b,
		pls_conta		a
	where	b.nr_sequencia		= c.nr_seq_conta_proc
	and	a.nr_sequencia		= b.nr_seq_conta
	and	b.cd_procedimento	= cd_procedimento_p
	and	b.ie_origem_proced 	= ie_origem_proced_p
	and	a.cd_guia_referencia	= cd_guia_referencia_w;


BEGIN
select	coalesce(cd_guia_referencia,cd_guia),
	ie_tipo_guia,
	cd_medico_executor,
	nr_seq_grau_partic
into STRICT	cd_guia_referencia_w,
	ie_tipo_guia_w,
	cd_medico_executor_w,
	nr_seq_grau_partic_ww
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

if (ie_tipo_guia_w <> '6') then
	select	count(*)
	into STRICT	qt_participantes_w
	from	pls_proc_participante
	where	nr_seq_conta_proc = nr_seq_proc_p;
	if (qt_participantes_w > 0) then
		open C01;
		loop
		fetch C01 into
			cd_medico_w,
			nr_seq_grau_partic_w,
			nr_seq_partic_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			select	sum(qt_itens)
			into STRICT	qt_reg_w
			from (SELECT	count(1) qt_itens
				from	pls_proc_participante	c,
					pls_conta_proc		b,
					pls_conta		a
				where	b.nr_sequencia		= c.nr_seq_conta_proc
				and	a.nr_sequencia		= b.nr_seq_conta
				and	c.cd_medico		= cd_medico_w
				and	c.nr_seq_grau_partic 	<> nr_seq_grau_partic_w
				and	c.nr_sequencia 		<> nr_seq_partic_w
				and	b.cd_procedimento	= cd_procedimento_p
				and	b.ie_origem_proced 	= ie_origem_proced_p
				and	a.cd_guia		= cd_guia_referencia_w
				
union all

				SELECT	count(1) qt_itens
				from	pls_proc_participante	c,
					pls_conta_proc		b,
					pls_conta		a
				where	b.nr_sequencia		= c.nr_seq_conta_proc
				and	a.nr_sequencia		= b.nr_seq_conta
				and	c.cd_medico		= cd_medico_w
				and	c.nr_seq_grau_partic 	<> nr_seq_grau_partic_w
				and	c.nr_sequencia 		<> nr_seq_partic_w
				and	b.cd_procedimento	= cd_procedimento_p
				and	b.ie_origem_proced 	= ie_origem_proced_p
				and	a.cd_guia_referencia	= cd_guia_referencia_w) alias3;

			if (qt_reg_w = 0) then
				select	sum(qt_itens)
				into STRICT	qt_reg_w
				from (SELECT	count(1) qt_itens
					from	pls_conta_proc	b,
						pls_conta	a
					where	a.nr_sequencia		= b.nr_seq_conta
					and	cd_guia			= cd_guia_referencia_w
					and	cd_medico_executor	= cd_medico_w
					and	nr_seq_grau_partic 	<> nr_seq_grau_partic_w
					and	b.cd_procedimento	= cd_procedimento_p
					and	b.ie_origem_proced 	= ie_origem_proced_p
					
union all

					SELECT	count(1) qt_itens
					from	pls_conta_proc	b,
						pls_conta	a
					where	a.nr_sequencia		= b.nr_seq_conta
					and	cd_guia_referencia	= cd_guia_referencia_w
					and	cd_medico_executor	= cd_medico_w
					and	nr_seq_grau_partic 	<> nr_seq_grau_partic_w
					and	b.cd_procedimento	= cd_procedimento_p
					and	b.ie_origem_proced 	= ie_origem_proced_p) alias4;
			end if;

			if (qt_reg_w > 0) then
				ie_medico_partic_w := 'S';
				goto final;
			end if;
			end;
		end loop;
		close C01;

		<<final>>
		qt_reg_w := 0;
	else 	select	sum(qt_itens) -- tratamento realizado para verificar o médico da conta (Demitrius) OS - 399074
		into STRICT	qt_reg_w
		from (SELECT	count(1) qt_itens
			 from	pls_conta_proc	b,
				pls_conta	a
			 where	a.nr_sequencia		= b.nr_seq_conta
   			 and	a.cd_guia		= cd_guia_referencia_w
			 and	cd_medico_executor	= cd_medico_executor_w--cd_medico_w
			 and	nr_seq_grau_partic 	<> nr_seq_grau_partic_ww--nr_seq_grau_partic_w
			 and	a.nr_sequencia		<> nr_seq_conta_p
			 and	b.cd_procedimento	= cd_procedimento_p
			 and	b.ie_origem_proced 	= ie_origem_proced_p
			
union all

			 SELECT	count(1) qt_itens
			 from	pls_conta_proc	b,
				pls_conta	a
			 where	a.nr_sequencia		= b.nr_seq_conta
			 and	a.cd_guia_referencia	= cd_guia_referencia_w
			 and	cd_medico_executor	= cd_medico_executor_w--cd_medico_w
			 and	nr_seq_grau_partic 	<> nr_seq_grau_partic_ww--nr_seq_grau_partic_w
			 and	a.nr_sequencia		<> nr_seq_conta_p
			 and	b.cd_procedimento	= cd_procedimento_p
			 and	b.ie_origem_proced 	= ie_origem_proced_p) alias3;

		if (qt_reg_w > 0) then
			ie_medico_partic_w := 'S';
		end if;
	end if;
else
	/*SE EH GUIA DE HONORARIO INDIVIDUAL*/

	/*Askono -25-11-11 - Ajustado na OS 377046 , trocadas as variaveis  cd_medico_w para cd_medico_executor_w. nr_seq_grau_partic_w para nr_seq_grau_partic_ww */

	select	sum(qt_itens)
	into STRICT	qt_reg_w
	from (SELECT	count(1) qt_itens
		from	pls_conta_proc	b,
			pls_conta	a
		where	a.nr_sequencia		= b.nr_seq_conta
		and	a.cd_guia		= cd_guia_referencia_w
		and	cd_medico_executor	= cd_medico_executor_w--cd_medico_w
		and	nr_seq_grau_partic 	<> nr_seq_grau_partic_ww--nr_seq_grau_partic_w
		and	a.nr_sequencia		<> nr_seq_conta_p
		and	b.cd_procedimento	= cd_procedimento_p
		and	b.ie_origem_proced 	= ie_origem_proced_p
		
union all

		SELECT	count(1) qt_itens
		from	pls_conta_proc	b,
			pls_conta	a
		where	a.nr_sequencia		= b.nr_seq_conta
		and	a.cd_guia_referencia	= cd_guia_referencia_w
		and	cd_medico_executor	= cd_medico_executor_w--cd_medico_w
		and	nr_seq_grau_partic 	<> nr_seq_grau_partic_ww--nr_seq_grau_partic_w
		and	a.nr_sequencia		<> nr_seq_conta_p
		and	b.cd_procedimento	= cd_procedimento_p
		and	b.ie_origem_proced 	= ie_origem_proced_p) alias3;

	if (qt_reg_w = 0) then
		select	sum(qt_itens)
		into STRICT	qt_reg_w
		from (SELECT	count(1) qt_itens
			from	pls_proc_participante	c,
				pls_conta_proc		b,
				pls_conta		a
			where	b.nr_sequencia		= c.nr_seq_conta_proc
			and	a.nr_sequencia		= b.nr_seq_conta
			and	a.cd_guia		= cd_guia_referencia_w
			and	c.cd_medico		= cd_medico_executor_w
			and	c.nr_seq_grau_partic 	<> nr_seq_grau_partic_ww
			and	b.cd_procedimento	= cd_procedimento_p
			and	b.ie_origem_proced 	= ie_origem_proced_p
			
union all

			SELECT	count(1) qt_itens
			from	pls_proc_participante	c,
				pls_conta_proc		b,
				pls_conta		a
			where	b.nr_sequencia		= c.nr_seq_conta_proc
			and	a.nr_sequencia		= b.nr_seq_conta
			and	a.cd_guia_referencia	= cd_guia_referencia_w
			and	c.cd_medico		= cd_medico_executor_w
			and	c.nr_seq_grau_partic 	<> nr_seq_grau_partic_ww
			and	b.cd_procedimento	= cd_procedimento_p
			and	b.ie_origem_proced 	= ie_origem_proced_p) alias4;
	end if;

	if (qt_reg_w > 0) then
		ie_medico_partic_w := 'S';
	end if;
end if;

ie_retorno_w := ie_medico_partic_w;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_medico_partic_dif ( nr_seq_conta_p bigint, nr_seq_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) FROM PUBLIC;

