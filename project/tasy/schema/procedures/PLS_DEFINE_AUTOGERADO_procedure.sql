-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_define_autogerado ( nr_seq_prestador_solic_p bigint, nr_seq_prestador_prot_p bigint, nr_seq_prestador_exec_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_tipo_acomodacao_p bigint, nr_seq_tipo_atendimento_p bigint, nr_seq_plano_p bigint, nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, ie_tipo_guia_p text, cd_medico_exec_p text, cd_medico_solic_conta_p text, cd_medico_solic_guia_p text, nr_seq_conta_p bigint, ie_tipo_segurado_P text, nr_seq_autogerado_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE

				 
ie_origem_proced_w		bigint;
cd_grupo_proc_w			bigint;
cd_especialidade_w		bigint;
cd_area_procedimento_w		bigint;
nr_seq_classif_prest_solic_w	bigint;
nr_seq_classif_prest_prot_w	bigint;
nr_seq_classif_prest_w		bigint;
ie_tipo_segurado_w		varchar(10);
nr_seq_retorno_w		bigint	:= 0;
nr_seq_autogerado_w		bigint;
nr_seq_autogerado_ww		bigint;
nr_seq_grupo_med_solic_w	bigint;
nr_seq_grupo_med_exec_w		bigint;
ie_medico_exec_w		varchar(10);
ie_medico_solic_w		varchar(10);
ie_origem_medico_solic_w	varchar(10);
cd_medico_solic_w		varchar(20);
ie_primeira_condicao_w		bigint;
ie_segunda_condicao_w		bigint;
nr_seq_prestador_solic_w	bigint;
nr_seq_prestador_exec_w		bigint;
nr_seq_prestador_w		bigint;
qt_prestador_w			bigint;
nr_seq_grupo_servico_w		bigint;
ie_grupo_servico_w		varchar(1)	:= 'S';
nr_seq_tipo_prest_solic_w	bigint;
nr_seq_tipo_prest_prot_w	bigint;
nr_seq_tipo_prestador_w		bigint;
nr_seq_grupo_rec_w		bigint;
cd_prestador_w			varchar(30);
nr_seq_prest_condicao_um_w	bigint;
nr_grupo_prest_condicao_um_w	bigint;
nr_seq_prest_condicao_dois_w	bigint;
nr_seq_excecao_w		bigint;
qt_excecao_w			bigint;
nr_seq_grupo_prest_solic_w	pls_regra_autogerado.nr_seq_grupo_prest_solic%type;
nr_seq_grupo_prest_exec_w	pls_regra_autogerado.nr_seq_grupo_prest_exec%type;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_seq_grupo_servico, 
		a.ie_origem_medico_solic, 
		a.nr_seq_grupo_med_solic, 
		a.nr_seq_grupo_med_exec 
	from	pls_regra_autogerado	a 
	where	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	a.ie_situacao		= 'A' 
	and	((coalesce(a.cd_procedimento::text, '') = '') or (a.cd_procedimento 	= cd_procedimento_p)) 
	and	((coalesce(a.ie_origem_proced::text, '') = '') or (a.ie_origem_proced = ie_origem_proced_w)) 
	and	((coalesce(a.cd_grupo_proc::text, '') = '') or (a.cd_grupo_proc	= cd_grupo_proc_w)) 
	and	((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade	= cd_especialidade_w)) 
	and	((coalesce(a.cd_area_procedimento::text, '') = '') or (a.cd_area_procedimento = cd_area_procedimento_w)) 
	and	((coalesce(a.nr_seq_tipo_acomodacao::text, '') = '') or (a.nr_seq_tipo_acomodacao = nr_seq_tipo_acomodacao_p)) 
	and	((coalesce(a.nr_seq_tipo_atendimento::text, '') = '') or (a.nr_seq_tipo_atendimento = nr_seq_tipo_atendimento_p)) 
	and	((coalesce(a.nr_seq_prestador::text, '') = '') or (a.nr_seq_prestador = coalesce(nr_seq_prestador_exec_p,0))) 
	and	((coalesce(a.nr_seq_plano::text, '') = '') or (a.nr_seq_plano = nr_seq_plano_p)) 
	and	((coalesce(a.nr_seq_classif_solic::text, '') = '') or (a.nr_seq_classif_solic	= nr_seq_classif_prest_solic_w)) 
	and	((coalesce(a.nr_seq_classif_prot::text, '') = '') or (a.nr_seq_classif_prot	= nr_seq_classif_prest_prot_w)) 
	and	((coalesce(a.nr_seq_classificacao::text, '') = '') or (a.nr_seq_classificacao	= nr_seq_classif_prest_w)) 
	and	((coalesce(a.ie_tipo_guia::text, '') = '') or (a.ie_tipo_guia = ie_tipo_guia_p)) 
	and	((coalesce(a.cd_prestador::text, '') = '') or (a.cd_prestador = coalesce(cd_prestador_w,'0'))) 
	and	((coalesce(a.ie_tipo_segurado::text, '') = '') or (a.ie_tipo_segurado = ie_tipo_segurado_w)) 
	and	((coalesce(a.nr_seq_grupo_prest_exec::text, '') = '') or ((SELECT	count(z.nr_sequencia) 
							 from		pls_preco_prestador z 
							 where		z.nr_seq_grupo = a.nr_seq_grupo_prest_exec 
							 and		z.nr_seq_prestador = nr_seq_prestador_exec_p) > 0)) 
	and	((coalesce(a.nr_seq_grupo_prest_solic::text, '') = '') or ((select	count(z.nr_sequencia) 
							 from		pls_preco_prestador z 
							 where		z.nr_seq_grupo = a.nr_seq_grupo_prest_solic 
							 and		z.nr_seq_prestador = nr_seq_prestador_solic_p) > 0)) 
	and	((coalesce(a.nr_seq_tipo_prest_solic::text, '') = '') or (a.nr_seq_tipo_prest_solic = coalesce(nr_seq_tipo_prest_solic_w,''))) 
	and	((coalesce(a.nr_seq_tipo_prest_prot::text, '') = '') or (a.nr_seq_tipo_prest_prot = coalesce(nr_seq_tipo_prest_prot_w,''))) 
	and	((coalesce(a.nr_seq_tipo_prestador::text, '') = '') or (a.nr_seq_tipo_prestador = coalesce(nr_seq_tipo_prestador_w,''))) 
	and	((coalesce(a.nr_seq_grupo_rec::text, '') = '') or (coalesce(a.nr_seq_grupo_rec,0)	= coalesce(nr_seq_grupo_rec_w,0)))							  
	order by coalesce(nr_seq_grupo_rec,0), 
		coalesce(a.ie_tipo_guia,0), 
		coalesce(a.nr_seq_tipo_prestador,0), 
		coalesce(a.nr_seq_classificacao,0), 
		coalesce(a.cd_procedimento,0), 
		coalesce(a.cd_grupo_proc,0), 
		coalesce(a.cd_especialidade,0), 
		coalesce(a.cd_area_procedimento,0);


BEGIN 
 
SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w) INTO STRICT cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w;
 
select	max(nr_seq_grupo_rec)   
into STRICT	nr_seq_grupo_rec_w     
from	procedimento        
where	cd_procedimento		= cd_procedimento_p  
and	ie_origem_proced	= ie_origem_proced_p;
 
/* Obter dados do beneficiário */
 
ie_tipo_segurado_w := ie_tipo_segurado_p;
 
 
/* Obter dados do prestador solicitante */
		 
begin 
select	nr_seq_classificacao, 
	nr_seq_tipo_prestador 
into STRICT	nr_seq_classif_prest_solic_w, 
	nr_seq_tipo_prest_solic_w 
from	pls_prestador 
where	nr_sequencia	= nr_seq_prestador_solic_p;
exception 
when others then 
	nr_seq_classif_prest_w		:= null;
	nr_seq_tipo_prest_solic_w	:= null;
end;
 
/* Obter dados do prestador do protocolo */
 
begin 
select	nr_seq_classificacao, 
	nr_seq_tipo_prestador 
into STRICT	nr_seq_classif_prest_prot_w, 
	nr_seq_tipo_prest_prot_w 
from	pls_prestador 
where	nr_sequencia	= nr_seq_prestador_prot_p;
exception 
when others then 
	nr_seq_classif_prest_w		:= null;
	nr_seq_tipo_prest_prot_w	:= null;
end;
 
/* Obter dados do prestador executor */
 
begin 
select	nr_seq_classificacao, 
	cd_prestador, 
	nr_seq_tipo_prestador 
into STRICT	nr_seq_classif_prest_w, 
	cd_prestador_w, 
	nr_seq_tipo_prestador_w 
from	pls_prestador 
where	nr_sequencia	= nr_seq_prestador_exec_p;
exception 
when others then 
	nr_seq_classif_prest_w	:= null;
	nr_seq_tipo_prestador_w	:= null;
end;
 
open C01;
loop 
fetch C01 into 
	nr_seq_autogerado_ww, 
	nr_seq_grupo_servico_w, 
	ie_origem_medico_solic_w, 
	nr_seq_grupo_med_solic_w, 
	nr_seq_grupo_med_exec_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ie_grupo_servico_w	:= 'S';
	nr_seq_excecao_w	:= 0;
	 
	/* Grupo de serviços */
 
	if (coalesce(nr_seq_grupo_servico_w,0) > 0) then 
		ie_grupo_servico_w	:= pls_se_grupo_preco_servico(nr_seq_grupo_servico_w, cd_procedimento_p, ie_origem_proced_p);
	end if;	
 
	ie_medico_exec_w	:= 'S';
	ie_medico_solic_w	:= 'S';
	if (coalesce(ie_origem_medico_solic_w,'C') = 'C') then 
		cd_medico_solic_w	:= cd_medico_solic_conta_p;
	else 
		cd_medico_solic_w	:= cd_medico_solic_guia_p;
	end if;
	 
	if (coalesce(nr_seq_grupo_med_exec_w,0)		<> 0) then 
		ie_medico_exec_w	:= pls_obter_se_grupo_medico(nr_seq_grupo_med_exec_w, cd_medico_exec_p);
	end if;
	 
	if (coalesce(nr_seq_grupo_med_solic_w,0)	<> 0) then 
		ie_medico_solic_w	:= pls_obter_se_grupo_medico(nr_seq_grupo_med_solic_w, cd_medico_solic_w);
	end if;	
	 
	if (ie_grupo_servico_w	= 'S') and (ie_medico_exec_w	= 'S') and (ie_medico_solic_w	= 'S') then 
		select	count(1) 
		into STRICT	qt_excecao_w 
		from	pls_excecao_autogerado 
		where	nr_seq_regra	= nr_seq_autogerado_ww;
		 
		if (qt_excecao_w > 0) then		 
			nr_seq_excecao_w := pls_obter_excecao_autogerado(nr_seq_autogerado_ww, cd_procedimento_p, ie_origem_proced_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_excecao_w);
		end if;
		 
		if (nr_seq_excecao_w = 0) then		 
			nr_seq_autogerado_w	:= nr_seq_autogerado_ww;
		end if;
	end if;
	end;
end loop;
close C01;
 
if (coalesce(nr_seq_autogerado_w,0) > 0) then 
	select	a.ie_primeira_condicao, 
		a.ie_segunda_condicao, 
		a.nr_seq_grupo_prest_solic, 
		a.nr_seq_grupo_prest_exec 
	into STRICT	ie_primeira_condicao_w, 
		ie_segunda_condicao_w, 
		nr_seq_grupo_prest_solic_w, 
		nr_seq_grupo_prest_exec_w 
	from	pls_regra_autogerado	a 
	where	a.nr_sequencia	= nr_seq_autogerado_w;
	 
	if (ie_primeira_condicao_w = 1) then /* Prestador executor */
 
		nr_seq_prest_condicao_um_w	:= nr_seq_prestador_exec_p;
	elsif (ie_primeira_condicao_w = 2) then /* Prestador do protocolo */
 
		nr_seq_prest_condicao_um_w	:= nr_seq_prestador_prot_p;
	elsif (ie_primeira_condicao_w = 3) then /* Prestador solicitante na conta */
 
		nr_seq_prest_condicao_um_w	:= nr_seq_prestador_solic_p;	
	elsif (ie_primeira_condicao_w = 4) then	-- Grupo prestador executor 
 
		begin 
		select	z.nr_seq_grupo 
		into STRICT	nr_seq_prest_condicao_um_w 
		from	pls_preco_prestador z 
		where	z.nr_seq_grupo 		= nr_seq_grupo_prest_exec_w 
		and	z.nr_seq_prestador 	= nr_seq_prestador_exec_p;
		exception 
		when others then 
			nr_seq_prest_condicao_um_w	:= -1;
		end;
	 
	elsif (ie_primeira_condicao_w = 5) then	-- Grupo prestador solicitante 
		 
		begin 
		select	z.nr_seq_grupo 
		into STRICT	nr_seq_prest_condicao_um_w 
		from	pls_preco_prestador z 
		where	z.nr_seq_grupo 		= nr_seq_grupo_prest_solic_w 
		and	z.nr_seq_prestador 	= nr_seq_prestador_solic_p;
		exception 
		when others then 
			nr_seq_prest_condicao_um_w	:= -1;
		end;
		 
	end if;
	 
	if (ie_segunda_condicao_w = 1) then /* Prestador executor */
 
		nr_seq_prest_condicao_dois_w	:= nr_seq_prestador_exec_p;
	elsif (ie_segunda_condicao_w = 2) then /* Prestador do protocolo */
 
		nr_seq_prest_condicao_dois_w	:= nr_seq_prestador_prot_p;
	elsif (ie_segunda_condicao_w = 3) then /* Prestador solicitante na conta */
 
		nr_seq_prest_condicao_dois_w	:= nr_seq_prestador_solic_p;	
	elsif (ie_segunda_condicao_w = 4) then	-- Grupo prestador executor 
 
		begin 
		select	z.nr_seq_grupo 
		into STRICT	nr_seq_prest_condicao_dois_w 
		from	pls_preco_prestador z 
		where	z.nr_seq_grupo 		= nr_seq_grupo_prest_exec_w 
		and	z.nr_seq_prestador 	= nr_seq_prestador_exec_p;
		exception 
		when others then 
			nr_seq_prest_condicao_dois_w	:= -1;
		end;
	 
	elsif (ie_segunda_condicao_w = 5) then	-- Grupo prestador solicitante 
		 
		begin 
		select	z.nr_seq_grupo 
		into STRICT	nr_seq_prest_condicao_dois_w 
		from	pls_preco_prestador z 
		where	z.nr_seq_grupo 		= nr_seq_grupo_prest_solic_w 
		and	z.nr_seq_prestador 	= nr_seq_prestador_solic_p;
		exception 
		when others then 
			nr_seq_prest_condicao_dois_w	:= -1;
		end;
		 
	end if;
	 
	if (nr_seq_prest_condicao_um_w IS NOT NULL AND nr_seq_prest_condicao_um_w::text <> '') then 
		if (nr_seq_prest_condicao_um_w <> nr_seq_prest_condicao_dois_w) then 
			nr_seq_autogerado_w	:= null;
		end if;
	end if;
end if;
 
nr_seq_autogerado_p	:= nr_seq_autogerado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_define_autogerado ( nr_seq_prestador_solic_p bigint, nr_seq_prestador_prot_p bigint, nr_seq_prestador_exec_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_tipo_acomodacao_p bigint, nr_seq_tipo_atendimento_p bigint, nr_seq_plano_p bigint, nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, ie_tipo_guia_p text, cd_medico_exec_p text, cd_medico_solic_conta_p text, cd_medico_solic_guia_p text, nr_seq_conta_p bigint, ie_tipo_segurado_P text, nr_seq_autogerado_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
