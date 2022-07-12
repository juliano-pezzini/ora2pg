-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_proc_grau_oc_partic ( nr_seq_proc_grau_partic_p bigint, nr_seq_grau_partic_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint) RETURNS varchar AS $body$
DECLARE


ie_partic_obrigatorio_w		varchar(1);
ds_retorno_w                    varchar(1) 	:= 'N';
nr_seq_conta_proc_w		bigint;
qt_registros_w			bigint;
qt_reg_w                        integer;
qt_grau_partic_w                integer;
dt_procedimento_w		timestamp;
dt_fim_vigencia_w		timestamp;
dt_inicio_vigencia_w		timestamp;

/*	S = DEVE GERAR A OCORRÊNCIA
	N = NÃO DEVE GERAR A OCORRÊNCIA

	Criada com base na pls_obter_se_proc_grau_partic;	*/
BEGIN
select  count(1)
into STRICT    qt_reg_w
from    pls_oc_regra_proc_partic
where   cd_procedimento         = cd_procedimento_p
and     ie_origem_proced        = ie_origem_proced_p
and	nr_sequencia		= nr_seq_proc_grau_partic_p  LIMIT 1;

/*se tem regra para o procedimento*/

if (qt_reg_w > 0) then
	/*seleciona o seq do procedimento da conta*/

	/*select	max(nr_sequencia)
	into	nr_seq_conta_proc_w
	from 	pls_conta_proc
	where 	nr_seq_conta		= nr_seq_conta_p
	and 	cd_procedimento         = cd_procedimento_p
	and     ie_origem_proced        = ie_origem_proced_p;*/
	select 	max(ie_partic_obrigatorio)
	into STRICT 	ie_partic_obrigatorio_w
	from 	pls_oc_regra_proc_partic
	where   cd_procedimento         = cd_procedimento_p
	and     ie_origem_proced        = ie_origem_proced_p
	and	nr_sequencia		= nr_seq_proc_grau_partic_p;

	if (coalesce(nr_seq_grau_partic_p::text, '') = '') and (ie_partic_obrigatorio_w = 'S')	then
		ds_retorno_w	:= 'S';
	elsif (coalesce(nr_seq_grau_partic_p::text, '') = '') and (coalesce(ie_partic_obrigatorio_w,'N') = 'N') then
		ds_retorno_w	:= 'N';
	else
		select  count(1)
		into STRICT    qt_grau_partic_w
		from    pls_proc_grau_partic
		where   nr_seq_regra            = nr_seq_proc_grau_partic_p
		and     nr_seq_grau_partic      = nr_seq_grau_partic_p
		and	ie_situacao 		= 'A'  LIMIT 1;

		if (qt_grau_partic_w = 0) then
			ds_retorno_w := 'S';
		elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
			begin
			select	trunc(dt_procedimento)
			into STRICT	dt_procedimento_w
			from 	pls_conta_proc
			where 	nr_sequencia	= nr_seq_conta_proc_p;
			exception
			when others then
				dt_procedimento_w	:= clock_timestamp();
			end;

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_proc_grau_partic		a,
				pls_oc_regra_proc_partic	b
			where	a.nr_seq_regra		= b.nr_sequencia
			and	b.nr_sequencia		= nr_seq_proc_grau_partic_p
			and     a.nr_seq_grau_partic   	= nr_seq_grau_partic_p
			and	a.ie_situacao 		= 'A'
			and	b.cd_procedimento	= cd_procedimento_p
			and     b.ie_origem_proced     	= ie_origem_proced_p
			and	((dt_procedimento_w 	>= a.dt_inicio_vigencia and (a.dt_inicio_vigencia IS NOT NULL AND a.dt_inicio_vigencia::text <> '')) or (coalesce(a.dt_inicio_vigencia::text, '') = ''))
			and	((dt_procedimento_w 	<= a.dt_fim_vigencia and (a.dt_fim_vigencia IS NOT NULL AND a.dt_fim_vigencia::text <> '')) or (coalesce(a.dt_fim_vigencia::text, '') = ''))  LIMIT 1;

			if (qt_registros_w = 0) then
				ds_retorno_w	:= 'S';
			else
				ds_retorno_w	:= 'N';
			end if;

			/*begin
			select  dt_fim_vigencia,
				dt_inicio_vigencia
			into    dt_fim_vigencia_w,
				dt_inicio_vigencia_w
			from    pls_proc_grau_partic
			where   nr_seq_regra            = nr_seq_proc_grau_partic_p
			and     nr_seq_grau_partic      = nr_seq_grau_partic_p
			and	ie_situacao 		= 'A';
			exception
			when others then
				dt_fim_vigencia_w	:= sysdate;
				dt_inicio_vigencia_w	:= null;
			end;*/
			/*if	(dt_inicio_vigencia_w  is not null)	then
				if	(dt_procedimento_w between dt_inicio_vigencia_w	and dt_fim_vigencia_w)	then
					ds_retorno_w := 'N';
				else
					ds_retorno_w	:= 'S';
				end if;
			end if;*/
		end if;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_proc_grau_oc_partic ( nr_seq_proc_grau_partic_p bigint, nr_seq_grau_partic_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint) FROM PUBLIC;

