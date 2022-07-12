-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_tabela (cd_edicao_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, ie_opcao_p text, ie_classif_proced_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_procedimento_p bigint, nr_seq_proc_pacote_p bigint, nr_atendimento_p bigint, nr_seq_proc_interno_p bigint default 0, nr_seq_exame_p bigint default 0, cd_proc_tuss_p bigint default 0) RETURNS varchar AS $body$
DECLARE


/*
IE_OPCAO_P
'R' - Relatorio
'X' - XML
'T' - nr_seq_tiss_tabela
'C' - Codigo conversao	OS 238247
'D' - Descricao conversao	OS 238247
*/
cd_tabela_relat_w		varchar(10) := '';
cd_tabela_xml_w			varchar(10) := '';
cd_tabela_w			varchar(255) := '';
cd_edicao_amb_w			bigint;
nr_seq_tiss_tabela_w		bigint;
ie_prioridade_edicao_w		varchar(255) := '';
ie_pacote_w			varchar(255);
cd_grupo_w			bigint;
cd_especialidade_w		bigint;
cd_area_w			bigint;
cd_estabelecimento_w		bigint;
cd_tabela_servico_w		bigint;
cd_procedimento_convenio_w	varchar(255);
ds_procedimento_convenio_w	varchar(255);
ie_clinica_w			integer;
ie_tipo_atendimento_w		smallint;
count_w				bigint;
ie_item_tuss_w			varchar(1);
cd_plano_convenio_w		varchar(10) := 'X';
nr_seq_interno_w			bigint;

c01 CURSOR FOR
SELECT 	nr_seq_tiss_tabela,
	cd_edicao_amb
from	convenio_amb
where (cd_estabelecimento     = cd_estabelecimento_p)
and (cd_convenio            = cd_convenio_p)
and (cd_categoria           = coalesce(cd_categoria_p,cd_categoria))
and (coalesce(ie_situacao,'A')	= 'A')
and	cd_edicao_amb		= coalesce(cd_edicao_p, cd_edicao_amb)
and 	(dt_inicio_vigencia     =
      		(SELECT	max(dt_inicio_vigencia)
	       	from	convenio_amb a
	       	where (a.cd_estabelecimento  = cd_estabelecimento_p)
	        and (a.cd_convenio         = cd_convenio_p)
	        and (a.cd_categoria        = coalesce(cd_categoria_p,cd_categoria))
		and	cd_edicao_amb		= coalesce(cd_edicao_p, cd_edicao_amb)
		and (coalesce(a.ie_situacao,'A')= 'A')
	        and (a.dt_inicio_vigencia <=  dt_vigencia_p)))
order	by ie_prioridade desc;	/*Tem que ter o desc senao ele traz a ultima prioridade 09/11/2007. OS 72948.*/
c02 CURSOR FOR
SELECT	b.nr_seq_tiss_tabela,
	b.cd_tabela_servico,
	b.cd_estabelecimento
from	convenio_servico b
where	b.cd_convenio		= cd_convenio_p
and	b.cd_estabelecimento 	= cd_estabelecimento_p
and	b.cd_categoria		= coalesce(cd_categoria_p, b.cd_categoria)
and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_vigencia_p)	between b.dt_liberacao_tabela and coalesce(b.dt_termino, dt_vigencia_p)
and 	coalesce(b.ie_situacao,'A')	= 'A'
order	by coalesce(b.nr_prioridade,1) desc;


c03 CURSOR FOR
SELECT	NR_SEQ_TISS_TABELA,
	substr(cd_procedimento_convenio,1,255),
	substr(ds_procedimento_convenio,1,255)
from	tiss_regra_tabela_proc
where	cd_estabelecimento				= cd_estabelecimento_p
and	cd_convenio					= cd_convenio_p
and	coalesce(cd_categoria, coalesce(cd_categoria_p,'X'))	= coalesce(cd_categoria_p, 'X')
and	coalesce(cd_procedimento,cd_procedimento_p)		= cd_procedimento_p
and	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0))	= coalesce(nr_seq_proc_interno_p,0)
and	coalesce(CD_GRUPO_PROC,cd_grupo_w)			= cd_grupo_w
and	coalesce(CD_ESPECIALIDADE, cd_especialidade_w)	= cd_especialidade_w
and	coalesce(CD_AREA_PROCEDIMENTO, cd_area_w)		= cd_area_w
and	((coalesce(ie_pacote, 'T') = 'T') or (coalesce(ie_pacote, 'T') = ie_pacote_w))
and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_w,0)) = coalesce(ie_tipo_atendimento_w,0)
and	coalesce(ie_clinica,coalesce(ie_clinica_w,0))			= coalesce(ie_clinica_w,0)
and	coalesce(dt_vigencia_p,clock_timestamp()) between dt_inicio_vigencia and coalesce(dt_fim_vigencia,to_date('01/01/2199','dd/mm/yyyy'))
and	((coalesce(IE_PROC_TUSS,'A') = 'A') or (IE_PROC_TUSS = ie_item_tuss_w))
and	coalesce(cd_plano,cd_plano_convenio_w)	= cd_plano_convenio_w
order by coalesce(nr_seq_proc_interno,0),
	coalesce(cd_procedimento, 0),
	coalesce(CD_GRUPO_PROC, 0),
	coalesce(CD_ESPECIALIDADE, 0),
	coalesce(CD_AREA_PROCEDIMENTO, 0),
	coalesce(cd_categoria,'0'),
	coalesce(cd_plano,'0'),
	coalesce(ie_tipo_atendimento,0),
	ie_pacote,
	dt_inicio_vigencia,
	coalesce(IE_PROC_TUSS,'A');


BEGIN

if (coalesce(nr_atendimento_p, 0) > 0) then

	nr_seq_interno_w	:= obter_atecaco_atendimento(nr_atendimento_p);
	
	begin
	select	coalesce(b.cd_plano_convenio,'X')		
	into STRICT	cd_plano_convenio_w		
	from	atend_categoria_convenio b,
		atendimento_paciente a
	where	a.nr_atendimento	= b.nr_atendimento
	and	b.nr_seq_interno	= nr_seq_interno_w	
	and	a.nr_atendimento	= nr_atendimento_p  LIMIT 1;
	exception
	when others then
		cd_plano_convenio_w	:= 'X';		
	end;

end if;

				
if (coalesce(nr_atendimento_p,0) > 0) then

	begin
	select	coalesce(ie_tipo_atendimento,0),
		coalesce(ie_clinica,0)
	into STRICT	ie_tipo_atendimento_w,
		ie_clinica_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;
	exception
	when others then
		ie_tipo_atendimento_w	:= 0;
		ie_clinica_w		:= 0;
	end;	
		
end if;


if (coalesce(nr_seq_proc_pacote_p, 0) = 0) then					-- Se nao tem pacote informado, entao nao eh pacote
	ie_pacote_w		:= 'F';
elsif (coalesce(nr_seq_procedimento_p, 0) = coalesce(nr_seq_proc_pacote_p, 0)) then	-- Se pacote informado e o pacote eh igual ao nr_sequencia, entao eh o proprio pacote
	ie_pacote_w		:= 'P';
else										-- Se pacote informado e o pacote eh diferente do nr_sequencia, entao eh item de pacote
	ie_pacote_w		:= 'I';
end if;

begin
select 	b.cd_grupo_proc,
	b.cd_especialidade,
	b.cd_area_procedimento
into STRICT	cd_grupo_w,
	cd_especialidade_w,
	cd_area_w
from	estrutura_procedimento_v b
where 	b.cd_procedimento	= cd_procedimento_p
and	b.ie_origem_proced	= ie_origem_proced_p  LIMIT 1;
exception
when others then
	cd_grupo_w		:= null;
	cd_especialidade_w	:= null;
	cd_area_w		:= null;
end;

if (ie_opcao_p = 'C') then
	begin
		select	count(1)
		into STRICT	count_w
		from	tiss_regra_tabela_proc
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_convenio			= cd_convenio_p
		and	(cd_procedimento_convenio IS NOT NULL AND cd_procedimento_convenio::text <> '')
		and coalesce(cd_plano, cd_plano_convenio_w)	= cd_plano_convenio_w  LIMIT 1;	
	exception
	when others then
		count_w	:= 0;
	end;
elsif (ie_opcao_p = 'D') then
	begin
		select	count(1)
		into STRICT	count_w
		from	tiss_regra_tabela_proc
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_convenio			= cd_convenio_p
		and	(ds_procedimento_convenio IS NOT NULL AND ds_procedimento_convenio::text <> '')
		and coalesce(cd_plano, cd_plano_convenio_w)	= cd_plano_convenio_w  LIMIT 1;	
	exception
	when others then
		count_w	:= 0;
	end;
end if;

if (ie_opcao_p not in ('C','D')) or (count_w > 0) then	
	
	ie_item_tuss_w := 'N';

	if (coalesce(cd_proc_tuss_p, 0) > 0) then
		
		ie_item_tuss_w := 'S';
			
	elsif (coalesce(nr_seq_exame_p, 0) > 0
		and coalesce(define_proc_tuss_exame(nr_seq_exame_p, cd_convenio_p, cd_categoria_p, null, 0), 0) <> 0) then			
			
		ie_item_tuss_w := 'S';
		
	elsif (coalesce(nr_seq_proc_interno_p, 0) > 0
		and coalesce(Define_procedimento_TUSS(cd_estabelecimento_p, nr_seq_proc_interno_p, cd_convenio_p, cd_categoria_p, 
			obter_tipo_atendimento(nr_atendimento_p), clock_timestamp(), 0, 0, null, null, null), 0) <> 0) then
			
		ie_item_tuss_w := 'S';
			
	end if;

	nr_seq_tiss_tabela_w	:= null;
	open c03;
	loop
	fetch c03 into
		NR_SEQ_TISS_TABELA_w,
		cd_procedimento_convenio_w,
		ds_procedimento_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
	end loop;
	close c03;

	if (coalesce(nr_seq_tiss_tabela_w,0) > 0) then

		nr_seq_tiss_tabela_w	:= nr_seq_tiss_tabela_w;

	elsif (ie_classif_proced_p = 1) then

		select	coalesce(max(ie_prioridade_edicao_amb), 'N')
		into STRICT	ie_prioridade_edicao_w
		from	parametro_faturamento
		where	cd_estabelecimento	= cd_estabelecimento_p;

		if (ie_prioridade_edicao_w = 'S') then
			open c01;
			loop
			fetch c01 into
				nr_seq_tiss_tabela_w,
				cd_edicao_amb_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
			end loop;
			close c01;
		else
			select 	max(nr_seq_tiss_tabela),
				max(cd_edicao_amb)
			into STRICT	nr_seq_tiss_tabela_w,
				cd_edicao_amb_w
			from 	convenio_amb
			where (cd_estabelecimento     = cd_estabelecimento_p)
			and (cd_convenio            = cd_convenio_p)
			and (cd_categoria           = cd_categoria_p)
			and (coalesce(ie_situacao,'A')	= 'A')
			and 	(dt_inicio_vigencia     =
					(SELECT	max(dt_inicio_vigencia)
					from 	convenio_amb a
					where (a.cd_estabelecimento  = cd_estabelecimento_p)
			and (a.cd_convenio         = cd_convenio_p)
			and (a.cd_categoria        = cd_categoria_p)
			and (coalesce(a.ie_situacao,'A')= 'A')
			and	cd_edicao_amb		= coalesce(cd_edicao_p, cd_edicao_amb)
			and (a.dt_inicio_vigencia <=  dt_vigencia_p)));
		end if;

		if (coalesce(nr_seq_tiss_tabela_w,0) = 0) then
			begin
			select	b.nr_sequencia
			into STRICT	nr_seq_tiss_tabela_w
			from	tiss_tipo_tabela b,
				edicao_amb a
			where	a.nr_seq_tiss_tabela	= b.nr_sequencia
			and	a.cd_edicao_amb		= coalesce(cd_edicao_amb_w, cd_edicao_p);
			exception
			when no_data_found then
				nr_seq_tiss_tabela_w	:= null;
			end;
		end if;

	else
		open c02;
		loop
		fetch c02 into
			nr_seq_tiss_tabela_w,
			cd_tabela_servico_w,
			cd_estabelecimento_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			if (coalesce(nr_seq_tiss_tabela_w::text, '') = '') then
				select	nr_seq_tiss_tabela
				into STRICT	nr_seq_tiss_tabela_w
				from	tabela_servico
				where	cd_tabela_servico	= cd_tabela_servico_w
				and	cd_estabelecimento	= cd_estabelecimento_w;
			end if;
		end loop;
		close c02;

	end if;

	if (coalesce(nr_seq_tiss_tabela_w,0) > 0) then
		select	cd_tabela_relat,
			cd_tabela_xml
		into STRICT	cd_tabela_relat_w,
			cd_tabela_xml_w
		from	tiss_tipo_tabela
		where	nr_sequencia		= nr_seq_tiss_tabela_w;
	end if;
end if;

if (ie_opcao_p = 'R') then
	cd_tabela_w	:= cd_tabela_relat_w;
elsif (ie_opcao_p = 'X') then
	cd_tabela_w	:= cd_tabela_xml_w;
elsif (ie_opcao_p = 'T') then
	cd_tabela_w	:= nr_seq_tiss_tabela_w;
elsif (ie_opcao_p = 'C') then
	cd_tabela_w	:= cd_procedimento_convenio_w;
elsif (ie_opcao_p = 'D') then
	cd_tabela_w	:= ds_procedimento_convenio_w;
end if;

return	cd_tabela_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_tabela (cd_edicao_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, ie_opcao_p text, ie_classif_proced_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_procedimento_p bigint, nr_seq_proc_pacote_p bigint, nr_atendimento_p bigint, nr_seq_proc_interno_p bigint default 0, nr_seq_exame_p bigint default 0, cd_proc_tuss_p bigint default 0) FROM PUBLIC;

