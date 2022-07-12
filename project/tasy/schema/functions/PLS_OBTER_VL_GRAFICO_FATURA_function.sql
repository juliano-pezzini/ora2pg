-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_vl_grafico_fatura ( nr_seq_fatura_p bigint, ie_rejeitada_p text, ie_tipo_p text ) RETURNS bigint AS $body$
DECLARE

/* 
ie_rejeitada_p			 
S - Rejeitada 
N - Aceita 
 
ie_tipo_p 
Q - Quantidade 
P - Porcentagem do valor 
*/
 
	 
nr_retorno_w			double precision;
vl_glosado_w			pls_conta_proc.vl_procedimento_imp%type;
vl_fatura_w			ptu_nota_servico.vl_procedimento%type;
qt_glosado_w			integer;
qt_total_w			integer;
nr_seq_grupo_pre_analise_w	pls_parametros.nr_seq_grupo_pre_analise%type;
cd_estabelecimento_w		ptu_fatura.cd_estabelecimento%type;
	

BEGIN 
 
if (nr_seq_fatura_p IS NOT NULL AND nr_seq_fatura_p::text <> '') then 
 
	select	a.cd_estabelecimento 
	into STRICT	cd_estabelecimento_w 
	from	ptu_fatura a 
	where	a.nr_sequencia	= nr_seq_fatura_p;
 
	begin 
	select	a.nr_seq_grupo_pre_analise 
	into STRICT	nr_seq_grupo_pre_analise_w 
	from	pls_parametros a 
	where	a.cd_estabelecimento	= cd_estabelecimento_w;
	exception 
		when others then 
		nr_seq_grupo_pre_analise_w	:= null;
	end;
 
	if (ie_tipo_p = 'P') then 
 
		vl_fatura_w	:= (replace(ptu_obter_dados_label(nr_seq_fatura_p,'VTF'),'.',''))::numeric;
 
		select	sum(vl_glosado) 
		into STRICT	vl_glosado_w 
		from ( 
			SELECT	coalesce(sum(b.vl_procedimento_imp),0) vl_glosado 
			from	pls_conta_proc	b, 
				pls_conta	a 
			where	a.nr_sequencia	= b.nr_seq_conta 
			and	a.nr_seq_fatura	= nr_seq_fatura_p 
			and (exists (SELECT	1 
					 from	pls_analise_glo_ocor_grupo y, 
						pls_ocorrencia_benef x 
					 where	x.nr_seq_conta	= a.nr_sequencia 
					 and	x.nr_sequencia	= y.nr_seq_ocor_benef 
					 and	x.ie_pre_analise = 'S' 
					 and	y.ie_status	in ('E','N','G','P') 
					 and	y.nr_seq_grupo	= nr_seq_grupo_pre_analise_w 
					 and	x.nr_seq_conta_proc = b.nr_sequencia 
					 
union
 
					 select	1 
					 from	pls_analise_glo_ocor_grupo y, 
						pls_ocorrencia_benef x 
					 where	x.nr_seq_conta	= a.nr_sequencia 
					 and	x.nr_sequencia	= y.nr_seq_ocor_benef 
					 and	x.ie_pre_analise = 'S' 
					 and	y.ie_status	in ('E','N','G','P') 
					 and	y.nr_seq_grupo	= nr_seq_grupo_pre_analise_w 
					 and	coalesce(x.nr_seq_conta_proc::text, '') = '' 
					 and	coalesce(x.nr_seq_conta_mat::text, '') = '' 
					 and	coalesce(x.nr_seq_proc_partic::text, '') = '') 
				or	coalesce(a.nr_seq_segurado::text, '') = '') 
			
union all
 
			select	coalesce(sum(b.vl_material_imp),0) vl_glosado 
			from	pls_conta_mat	b, 
				pls_conta		a 
			where	a.nr_sequencia	= b.nr_seq_conta 
			and	a.nr_seq_fatura	= nr_seq_fatura_p 
			and (exists (select	1 
					 from	pls_analise_glo_ocor_grupo y, 
						pls_ocorrencia_benef x 
					 where	x.nr_seq_conta	= a.nr_sequencia 
					 and	x.nr_sequencia	= y.nr_seq_ocor_benef 
					 and	x.ie_pre_analise = 'S' 
					 and	y.ie_status	in ('E','N','G','P') 
					 and	y.nr_seq_grupo	= nr_seq_grupo_pre_analise_w 
					 and	x.nr_seq_conta_mat = b.nr_sequencia 
					 
union
 
					 select	1 
					 from	pls_analise_glo_ocor_grupo y, 
						pls_ocorrencia_benef x 
					 where	x.nr_seq_conta	= a.nr_sequencia 
					 and	x.nr_sequencia	= y.nr_seq_ocor_benef 
					 and	x.ie_pre_analise = 'S' 
					 and	y.ie_status	in ('E','N','G','P') 
					 and	y.nr_seq_grupo	= nr_seq_grupo_pre_analise_w 
					 and	coalesce(x.nr_seq_conta_proc::text, '') = '' 
					 and	coalesce(x.nr_seq_conta_mat::text, '') = '' 
					 and	coalesce(x.nr_seq_proc_partic::text, '') = '') 
				or	coalesce(a.nr_seq_segurado::text, '') = '') 
			) alias21;
			 
		nr_retorno_w := dividir(vl_glosado_w, vl_fatura_w) * 100;	
		 
		if (ie_rejeitada_p = 'S') then		 
			nr_retorno_w := Greatest(100 - nr_retorno_w,0);
		end if;
		 
	elsif (ie_tipo_p = 'Q') then 
 
		select	count(a.nr_sequencia) 
		into STRICT	qt_total_w 
		from	pls_conta a 
		where	a.nr_seq_fatura	= nr_seq_fatura_p;
			 
		select	count(a.nr_sequencia) 
		into STRICT	qt_glosado_w 
		from	pls_conta a 
		where	a.nr_seq_fatura	= nr_seq_fatura_p	 
		and (coalesce(a.nr_seq_segurado::text, '') = '' 
			or	 exists (SELECT	1 
					 from	pls_analise_glo_ocor_grupo y, 
						pls_ocorrencia_benef x 
					 where	x.nr_seq_conta	= a.nr_sequencia 
					 and	x.nr_sequencia	= y.nr_seq_ocor_benef 
					 and	x.ie_pre_analise = 'S' 
					 and	y.ie_status	in ('E','N','G','P') 
					 and	y.nr_seq_grupo	= nr_seq_grupo_pre_analise_w) 
			);
			 
		if (ie_rejeitada_p = 'N') then		 
			nr_retorno_w := Greatest(qt_total_w - qt_glosado_w,0);
		else 
			nr_retorno_w := qt_glosado_w;
		end if;				
	end if;
end if;
 
return	nr_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_vl_grafico_fatura ( nr_seq_fatura_p bigint, ie_rejeitada_p text, ie_tipo_p text ) FROM PUBLIC;
