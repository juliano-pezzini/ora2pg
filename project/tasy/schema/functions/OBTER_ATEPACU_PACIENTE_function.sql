-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atepacu_paciente ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/* UNIDADE DO PACIENTE				*/

/*	P = Primeira Unidade          			*/

/* 	A = Unidade Atual  				*/

/*	PI = Primeira Unidade Internacao		*/

/*	PIO = Primeira Unidade Internacao Controla Ocupacao */

/*	IA = Internacao Atual			*/

/*	IA = Internacao Atual	+ RN		*/

/*	IAA = Internacao Atual OU Unidade Atual 	*/

/*	IAAP = Internacao Atual ou Unidade Atual e PS		*/

/* 	AA = Unidade Atual do atendimento		*/

/*	MTI = Maior tempo unidade Internacao, CC ou UTI	*/

/*	IAC = Internacao Atual OU Unidade Atual  Considera CC	*/

/*	UAA = Unidade Anterior a atual		*/

/*  UUA = Ultima unidade integrada ao sistema Aghos  */

/*	IAR = Internacao + RN	*/

/* 	MCD = Medico Che*/

nr_seq_atepacu_w			bigint;
nr_seq_atepacu_ww			bigint;
hr_diferenca_w				bigint;

C01 CURSOR FOR
SELECT	a.nr_seq_interno,
	(coalesce(a.dt_saida_unidade,clock_timestamp()) - a.dt_entrada_unidade)
from	setor_atendimento b,
	atend_paciente_unidade a
where	a.nr_atendimento		= nr_atendimento_p
and	a.cd_setor_atendimento	= b.cd_setor_atendimento
and	b.cd_classif_setor		in ('2','3','4','12')
order by	2;

C02 CURSOR FOR
SELECT	a.nr_seq_interno
from 	setor_atendimento c,
	atend_paciente_unidade a
where	a.nr_atendimento 		= nr_atendimento_p
  and	c.cd_setor_atendimento		= a.cd_setor_atendimento
  and 	c.cd_classif_setor in (3,4,8,12)
order by coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999) desc;

C03 CURSOR FOR
SELECT	a.nr_seq_interno
from 	setor_atendimento c,
	atend_paciente_unidade a
where	a.nr_atendimento 		= nr_atendimento_p
  and	c.cd_setor_atendimento		= a.cd_setor_atendimento
  and 	c.cd_classif_setor in (3,4,8,9,12)
order by coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999) desc;


BEGIN

if (ie_opcao_p = 'P') then
	select	coalesce(min(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	  and 	dt_entrada_unidade	=
		(SELECT min(dt_entrada_unidade)
		from atend_paciente_unidade b
		where nr_atendimento 		= nr_atendimento_p);
elsif (ie_opcao_p = 'A') then
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	  and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
		(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
		from atend_paciente_unidade b
		where b.nr_atendimento 	= nr_atendimento_p);
elsif (ie_opcao_p = 'UAA') then
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
		(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
		from atend_paciente_unidade b
		where b.nr_atendimento 	= nr_atendimento_p);
		
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_ww
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	and 	a.nr_seq_interno <> nr_seq_atepacu_w
	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
		(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
		from atend_paciente_unidade b
		where b.nr_atendimento 	= nr_atendimento_p
		and 	b.nr_seq_interno <> nr_seq_atepacu_w);
	nr_seq_atepacu_w := nr_seq_atepacu_ww;	
elsif (ie_opcao_p = 'PI') then
	select	coalesce(min(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	  and 	dt_entrada_unidade	=
		(SELECT min(dt_entrada_unidade)
		from 	Setor_Atendimento y,
			atend_paciente_unidade b
		where 	nr_atendimento 		= nr_atendimento_p
		  and 	b.cd_setor_atendimento	= y.cd_setor_atendimento
		  and 	y.cd_classif_setor in (3,4,8,12));
elsif (ie_opcao_p = 'PIO') then
	select	coalesce(min(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	  and 	dt_entrada_unidade	=
		(SELECT min(dt_entrada_unidade)
		from 	Setor_Atendimento y,
			atend_paciente_unidade b
		where 	nr_atendimento 		= nr_atendimento_p
		  and 	b.cd_setor_atendimento	= y.cd_setor_atendimento
		  and 	y.cd_classif_setor in (3,4,8,12)
		  and	y.ie_ocup_hospitalar = 'S');		
elsif (ie_opcao_p = 'IA') then
	nr_seq_atepacu_w	:= 0;
	open C02;
	loop
	fetch C02 into	
		nr_seq_atepacu_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		nr_seq_atepacu_w	:= nr_seq_atepacu_w;
		exit;
		end;
	end loop;
	close C02;
elsif (ie_opcao_p = 'IAR') or (ie_opcao_p = 'IARR') then
	nr_seq_atepacu_w	:= 0;
	open C03;
	loop
	fetch C03 into	
		nr_seq_atepacu_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		nr_seq_atepacu_w	:= nr_seq_atepacu_w;
		exit;
		end;
	end loop;
	close C03;	
	
	if (ie_opcao_p = 'IAR') and
		((coalesce(nr_seq_atepacu_w::text, '') = '') or (nr_seq_atepacu_w = 0)) then	
		select	coalesce(max(nr_seq_interno),0)
		into STRICT	nr_seq_atepacu_w
		from 	atend_paciente_unidade a
		where	a.nr_atendimento 		= nr_atendimento_p
	  	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
			(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
			from atend_paciente_unidade b
			where b.nr_atendimento 	= nr_atendimento_p);
	end if;
	
/*	OS  130763 Edilson /Coelho/Ricardo em 09/03/2009
	select	nvl(max(nr_seq_interno),0)
	into	nr_seq_atepacu_w
	from 	setor_atendimento c,
		atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	  and	c.cd_setor_atendimento		= a.cd_setor_atendimento
	  and 	c.cd_classif_setor in (3,4,8)--Feltrin - OS118241
	  and 	nvl(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	= 
		(select max(nvl(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
		from 	Setor_Atendimento y,
			atend_paciente_unidade b
		where nr_atendimento 	= nr_atendimento_p
		  and 	b.cd_setor_atendimento	= y.cd_setor_atendimento
		  and 	y.cd_classif_setor in (3,4,8)); */
elsif (ie_opcao_p = 'IAA') then
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a,
			Setor_Atendimento c
	where	a.nr_atendimento 		= nr_atendimento_p
	AND 	a.cd_setor_atendimento	= c.cd_setor_atendimento		
	AND		c.cd_classif_setor IN (3,4,8,12)
	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
			(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
			from 	Setor_Atendimento y,
					atend_paciente_unidade b
			where 	nr_atendimento 	= nr_atendimento_p
			and 	b.cd_setor_atendimento	= y.cd_setor_atendimento
			and 	y.cd_classif_setor in (3,4,8,12));
	if (coalesce(nr_seq_atepacu_w::text, '') = '') or (nr_seq_atepacu_w = 0) then	
		select	coalesce(max(nr_seq_interno),0)
		into STRICT	nr_seq_atepacu_w
		from 	atend_paciente_unidade a
		where	a.nr_atendimento 		= nr_atendimento_p
	  	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
			(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
			from atend_paciente_unidade b
			where b.nr_atendimento 	= nr_atendimento_p);
	end if;
elsif (ie_opcao_p = 'IAAP') then
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a,
			Setor_Atendimento c
	where	a.nr_atendimento 		= nr_atendimento_p
	AND 	a.cd_setor_atendimento	= c.cd_setor_atendimento		
	AND		c.cd_classif_setor IN (3,4,8,12,1)
	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
			(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
			from 	Setor_Atendimento y,
					atend_paciente_unidade b
			where 	nr_atendimento 	= nr_atendimento_p
			and 	b.cd_setor_atendimento	= y.cd_setor_atendimento
			and 	y.cd_classif_setor in (3,4,8,12,1));
	if (coalesce(nr_seq_atepacu_w::text, '') = '') or (nr_seq_atepacu_w = 0) then	
		select	coalesce(max(nr_seq_interno),0)
		into STRICT	nr_seq_atepacu_w
		from 	atend_paciente_unidade a
		where	a.nr_atendimento 		= nr_atendimento_p
	  	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
			(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
			from atend_paciente_unidade b
			where b.nr_atendimento 	= nr_atendimento_p);
	end if;	
elsif (ie_opcao_p = 'AA') then
	select	coalesce(coalesce(nr_seq_unid_atual,nr_seq_unid_int),0)
	into STRICT	nr_seq_atepacu_w
	from 	atendimento_paciente a
	where	a.nr_atendimento 		= nr_atendimento_p;
elsif (ie_opcao_p = 'MTI') then
	begin
	nr_seq_atepacu_w	:= 0;
	open C01;
	loop
	fetch c01 into
		nr_seq_atepacu_w,
		hr_diferenca_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_seq_atepacu_w	:= nr_seq_atepacu_w;
		end;
	end loop;
	close C01;
	end;
elsif (ie_opcao_p = 'IAC') then
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	  and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
		(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
		from 	Setor_Atendimento y,
			atend_paciente_unidade b
		where nr_atendimento 	= nr_atendimento_p
		  and 	b.cd_setor_atendimento	= y.cd_setor_atendimento
		  and 	y.cd_classif_setor in (2,3,4,8,12));
	if (coalesce(nr_seq_atepacu_w::text, '') = '') or (nr_seq_atepacu_w = 0) then	
		select	coalesce(max(nr_seq_interno),0)
		into STRICT	nr_seq_atepacu_w
		from 	atend_paciente_unidade a
		where	a.nr_atendimento 		= nr_atendimento_p
	  	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
			(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
			from atend_paciente_unidade b
			where b.nr_atendimento 	= nr_atendimento_p);
	end if;	
elsif (ie_opcao_p = 'UUA') then
	select	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	and		coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
				(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
				from 	Setor_Atendimento y,
						atend_paciente_unidade b
				where 	b.nr_atendimento 	= nr_atendimento_p
				and 	b.cd_setor_atendimento	= y.cd_setor_atendimento
				and 	(y.cd_setor_externo IS NOT NULL AND y.cd_setor_externo::text <> ''));
elsif (ie_opcao_p = 'MCD') then
	select	coalesce(max(cd_departamento),0)
	into STRICT	nr_seq_atepacu_w
	from 	atend_paciente_unidade a
	where	a.nr_atendimento 		= nr_atendimento_p
	and 	coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999)	=
				(SELECT max(coalesce(b.dt_saida_unidade, b.dt_entrada_unidade + 9999))
				 from atend_paciente_unidade b
				 where b.nr_atendimento 	= nr_atendimento_p);
end if;

RETURN nr_seq_atepacu_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atepacu_paciente ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
