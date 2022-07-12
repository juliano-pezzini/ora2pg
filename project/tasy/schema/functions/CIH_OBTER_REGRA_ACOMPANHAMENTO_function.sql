-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_obter_regra_acompanhamento (nr_ficha_ocorrencia_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_data_referencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
/* 
ie_data_referencia_p 
0 = Data da ficha/contato 
1 = Data da alta 
*/
 
			 
ds_retorno_w		varchar(1)	:= 'N';
nr_sequencia_w		bigint;
qt_dias_w		integer;
ie_forma_acomp_w	varchar(1);
dt_ficha_w		timestamp;
dt_referencia_w		timestamp;
qt_dif_atual_ficha_w	integer;
qt_dif_atual_contato_w	integer;
cd_area_procedimento_w	bigint;
cd_especialidade_w	bigint;
cd_grupo_proc_w		bigint;
cd_procedimento_w	bigint;
	
C01 CURSOR FOR 
	SELECT	coalesce(a.nr_sequencia,0), 
		a.qt_dias, 
		a.ie_forma_acomp 
	from	cih_regra_proced_acomp a 
	where	coalesce(a.cd_estabelecimento,cd_estabelecimento_p)		= cd_estabelecimento_p 
	and	coalesce(a.cd_area_procedimento, cd_area_procedimento_w)	= cd_area_procedimento_w 
	and	coalesce(a.cd_especialidade, cd_especialidade_w)		= cd_especialidade_w 
	and	coalesce(a.cd_grupo_proc, cd_grupo_proc_w)			= cd_grupo_proc_w 
	and	coalesce(a.cd_procedimento, cd_procedimento_p)		= cd_procedimento_p 
	and	((coalesce(a.cd_procedimento::text, '') = '') or ((a.ie_origem_proced = ie_origem_proced_p) or (coalesce(a.ie_origem_proced::text, '') = ''))) 
	and	a.ie_situacao	= 'A' 
	and	a.ie_tipo_acomp	= 'C' 
	and (coalesce(a.nr_seq_equipamento::text, '') = '' 
	or exists (	SELECT	1 
			from	cih_cirurgia b, 
				agenda_paciente c, 
				agenda_pac_equip d 
			where	b.nr_ficha_ocorrencia = nr_ficha_ocorrencia_p 
			and	b.nr_seq_cirurgia_pac = c.nr_cirurgia 
			and	c.nr_sequencia = d.nr_seq_agenda 
			and	b.cd_procedimento = cd_procedimento_p 
			and	b.ie_origem_proced = ie_origem_proced_p 
			and	d.nr_seq_classif_equip = a.nr_seq_equipamento)) 
	order by coalesce(a.cd_procedimento,0), 
		coalesce(a.cd_grupo_proc,0), 
		coalesce(a.cd_especialidade,0), 
		coalesce(a.cd_area_procedimento,0);
	

BEGIN 
 
select	coalesce(max(cd_grupo_proc), 0), 
	coalesce(max(cd_especialidade), 0), 
	coalesce(max(cd_area_procedimento), 0) 
into STRICT	cd_grupo_proc_w, 
	cd_especialidade_w, 
	cd_area_procedimento_w 
from	estrutura_procedimento_v 
where	cd_procedimento		= cd_procedimento_p 
and	ie_origem_proced	= ie_origem_proced_p;
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w, 
	qt_dias_w, 
	ie_forma_acomp_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (ie_data_referencia_p = 0) then 
	 
		select	max(dt_ficha) 
		into STRICT	dt_ficha_w 
		from	cih_ficha_ocorrencia 
		where	nr_ficha_ocorrencia	= nr_ficha_ocorrencia_p;
		 
		select	coalesce(max(dt_contato),dt_ficha_w) 
		into STRICT	dt_referencia_w 
		from	cih_contato 
		where	nr_ficha_ocorrencia	= nr_ficha_ocorrencia_p;
		 
	elsif (ie_data_referencia_p = 1) then 
	 
		select	max(Obter_data_alta_Atend(nr_atendimento)) 
		into STRICT	dt_referencia_w 
		from	cih_ficha_ocorrencia 
		where	nr_ficha_ocorrencia	= nr_ficha_ocorrencia_p;
		 
	end if;
				 
	if (dt_referencia_w IS NOT NULL AND dt_referencia_w::text <> '') then 
		qt_dif_atual_contato_w	:= clock_timestamp() - dt_referencia_w;
		 
		if (qt_dif_atual_contato_w <= coalesce(qt_dias_w,qt_dif_atual_contato_w)) then 
			if (ie_forma_acomp_w	= 'D') then 
				ds_retorno_w	:= 'S';
			elsif (ie_forma_acomp_w	= 'S') and (qt_dif_atual_contato_w	>= 7) then 
				ds_retorno_w	:= 'S';
			elsif (ie_forma_acomp_w	= 'M') and (qt_dif_atual_contato_w	>= 30) then 
				ds_retorno_w	:= 'S';
			elsif (ie_forma_acomp_w	= 'A') and (qt_dif_atual_contato_w	>= 365) then 
				ds_retorno_w	:= 'S';
			else 
				ds_retorno_w	:= 'N';
			end if;
		end if;
	else 
		ds_retorno_w	:= 'S';
	end if;
	 
	end;
end loop;
close C01;
 
 
return	ds_Retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_obter_regra_acompanhamento (nr_ficha_ocorrencia_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_data_referencia_p bigint) FROM PUBLIC;
