-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_valor_apres_orig ( nr_seq_conta_p bigint, ie_origem_valor_p text, vl_minimo_p bigint) RETURNS varchar AS $body$
DECLARE


vl_apresentado_proc_w		double precision:= 0;
vl_apresentado_mat_w		double precision:= 0;
ds_retorno_w			varchar(1) := 'N';
cd_guia_w			varchar(30);
cd_guia_referencia_w		varchar(30);
nr_seq_segurado_w		bigint;



BEGIN

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	/*ORIGEM VALOR GUIA = VERIFICA O VALOR DO ATENDIMENTO TODO - TODAS AS CONTAS COM A MESMA LIGAÇÃO DE GUIAS*/

	if (ie_origem_valor_p = 'G') then

		/*obter dados da conta*/

		begin
		select 	cd_guia,
			cd_guia_referencia,
			nr_seq_segurado
		into STRICT 	cd_guia_w,
			cd_guia_referencia_w,
			nr_seq_segurado_w
		from 	pls_conta
		where	nr_sequencia = nr_seq_conta_p;
		exception
		when others then
			nr_seq_segurado_w := null;
		end;

		if (coalesce(nr_seq_segurado_w,0) > 0) then

			select 	coalesce(sum(b.vl_procedimento_imp),0)
			into STRICT	vl_apresentado_proc_w
			from   	pls_conta_proc		b,
				pls_conta		a
			where  	a.nr_sequencia		= b.nr_seq_conta
			and	(((a.cd_guia_referencia = coalesce(cd_guia_referencia_w,cd_guia_w)) and (a.cd_guia_referencia IS NOT NULL AND a.cd_guia_referencia::text <> '')) or
				((a.cd_guia = coalesce(cd_guia_referencia_w,cd_guia_w)) and (a.cd_guia IS NOT NULL AND a.cd_guia::text <> '')))
			and	a.nr_seq_segurado	= nr_seq_segurado_w
			and	a.ie_glosa	= 'N';

			select 	coalesce(sum(b.vl_material_imp),0)
			into STRICT	vl_apresentado_mat_w
			from   	pls_conta_mat		b,
				pls_conta		a
			where  	a.nr_sequencia		= b.nr_seq_conta
			and	(((a.cd_guia_referencia = coalesce(cd_guia_referencia_w,cd_guia_w)) and (a.cd_guia_referencia IS NOT NULL AND a.cd_guia_referencia::text <> '')) or
				((a.cd_guia = coalesce(cd_guia_referencia_w,cd_guia_w)) and (a.cd_guia IS NOT NULL AND a.cd_guia::text <> '')))
			and	a.nr_seq_segurado	= nr_seq_segurado_w
			and	a. ie_glosa = 'N';
		end if;


	/*ORIGEM VALOR CONTA = SOMENTE VERIFICA O VALOR CALCULADO DA CONTA A SER CONSISTIDA*/

	elsif ( ie_origem_valor_p = 'C') then

		if (coalesce(nr_seq_conta_p,0) > 0) then
			select	coalesce(sum(vl_procedimento_imp),0)
			into STRICT	vl_apresentado_proc_w
			from	pls_conta_proc
			where	nr_seq_conta = nr_seq_conta_p;

			select	coalesce(sum(vl_material_imp),0)
			into STRICT	vl_apresentado_mat_w
			from	pls_conta_mat
			where	nr_seq_conta = nr_seq_conta_p;
		end if;
	end if;

	/*VERIFICA SE O VALOR CALCULADO ESTA DE ACORDO COM O VALOR MINIMO DA REGRA*/

	if	((coalesce(vl_apresentado_proc_w,0) + coalesce(vl_apresentado_mat_w,0)) >= vl_minimo_p) then
		ds_retorno_w := 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_valor_apres_orig ( nr_seq_conta_p bigint, ie_origem_valor_p text, vl_minimo_p bigint) FROM PUBLIC;
