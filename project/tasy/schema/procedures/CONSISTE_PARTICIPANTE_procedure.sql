-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_participante ( nr_interno_conta_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w				varchar(4000) 	:= ' ';
cd_procedimento_w			bigint;
ie_origem_proced_w			bigint;
cd_edicao_amb_w				varchar(240);
dt_conta_w				timestamp;
qt_partic_funcao_w			bigint;
nr_auxiliares_w				bigint;
qt_porte_anestesico_w			bigint;
ie_auxiliar_w				varchar(10);
ie_anestesista_w			varchar(10);
ie_consiste_partic_menor_w		varchar(1);
cd_estabelecimento_w		smallint;
cd_convenio_w			procedimento_paciente.cd_convenio%type;
cd_categoria_w			procedimento_paciente.cd_categoria%type;
ie_existe2230_w				integer;
ie_existe2220_w				integer;
ie_existe2221_w				integer;
ie_existe2222_w				integer;

C01 CURSOR FOR
SELECT a.cd_procedimento,
	 a.ie_origem_proced,
	 a.cd_edicao_amb,
	 a.dt_conta,
	 coalesce(c.ie_auxiliar,'N'),
	 coalesce(c.ie_anestesista,'N'),
	 count(*),
	 a.cd_convenio,
	 a.cd_categoria
from	 funcao_medico c,
	 procedimento_participante b,
	 procedimento_paciente a
where	 a.nr_interno_conta	= nr_interno_conta_p
and	 a.nr_sequencia		= b.nr_sequencia
and	 c.cd_funcao		= somente_numero(b.ie_funcao)
and	 a.ie_origem_proced	not in (2,3)
and (coalesce(c.ie_auxiliar,'N')	= 'S' or
	  coalesce(c.ie_anestesista,'N') 	= 'S')
group	 by
	 a.cd_procedimento,
	 a.ie_origem_proced,
	 a.cd_edicao_amb,
	 a.dt_conta,
	 coalesce(c.ie_auxiliar,'N'),
	 coalesce(c.ie_anestesista,'N'),
	 a.cd_convenio,
	 a.cd_categoria,
	 a.nr_sequencia;

C02 CURSOR FOR
SELECT 	 a.cd_procedimento,
	 a.ie_origem_proced,
	 a.cd_edicao_amb,
	 a.dt_conta,
	 count(*),
	 a.cd_convenio,
	 a.cd_categoria
from	 procedimento_paciente a
where	 a.nr_interno_conta	= nr_interno_conta_p
and	 a.ie_origem_proced	 not in (2,3)
and	 not exists (	SELECT	1
			from	procedimento_participante x,
			funcao_medico d
			where	x.nr_sequencia = a.nr_sequencia
			and d.cd_funcao		= somente_numero(x.ie_funcao)
			and	 coalesce(d.ie_auxiliar,'N')	= 'S')
group	 by
	 a.cd_procedimento,
	 a.ie_origem_proced,
	 a.cd_edicao_amb,
	 a.dt_conta,
	 a.cd_convenio,
	 a.cd_categoria;



BEGIN
ds_erro_w		:= '';

select		max(cd_estabelecimento)
into STRICT		cd_estabelecimento_w
from		conta_paciente
where		nr_interno_conta = nr_interno_conta_p;

select		coalesce(max(ie_consiste_partic_menor),'N')
into STRICT		ie_consiste_partic_menor_w
from		parametro_faturamento
where		cd_estabelecimento = cd_estabelecimento_w;

OPEN C01;
LOOP
FETCH C01 	into
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_edicao_amb_w,
		dt_conta_w,
		ie_auxiliar_w,
		ie_anestesista_w,
		qt_partic_funcao_w,
		cd_convenio_w,
		cd_categoria_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select 	coalesce(position(' 2230' in ds_erro_w), 0),
		coalesce(position(' 2220' in ds_erro_w), 0), 
		coalesce(position(' 2221' in ds_erro_w), 0),
		coalesce(position(' 2222' in ds_erro_w), 0)
	into STRICT ie_existe2230_w, 
	     ie_existe2220_w, 
	     ie_existe2221_w, 
	     ie_existe2222_w 
	;
	
	/* obter qtd de participante da tabela de preço */

	if (ie_origem_proced_w in (1,4,5,8)) then
		begin
		select	coalesce(somente_numero(obter_dados_preco_proc(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_edicao_amb_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_w, 'X')),0),
			coalesce(somente_numero(obter_dados_preco_proc(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_edicao_amb_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_w, 'P')),0)
		into STRICT	nr_auxiliares_w,
			qt_porte_anestesico_w
		;
		end;
	else
		begin
		nr_auxiliares_w		:= 0;
	 	qt_porte_anestesico_w	:= 0;
		end;
	end if;

	/* Valida quantidades de auxiliares - Quantidade superior */

	if (ie_auxiliar_w	= 'S')		and (qt_partic_funcao_w	> nr_auxiliares_w) 	and
		((length(ds_erro_w) <= 2500) or (coalesce(ds_erro_w::text, '') = '')) and (ie_existe2220_w = 0) then
		
		ds_erro_w	:= ds_erro_w ||'2220'||'('||to_char(cd_procedimento_w)||') ';
	end if;

	/* Valida quantidades de auxiliares - Quantidade inferior */

	if (ie_auxiliar_w	= 'S')		and (qt_partic_funcao_w	< nr_auxiliares_w) 	and (ie_consiste_partic_menor_w = 'S')	and
		((length(ds_erro_w) <= 2500) or (coalesce(ds_erro_w::text, '') = '')) and (ie_existe2230_w = 0) then
		
		ds_erro_w	:= ds_erro_w ||'2230'||'('||to_char(cd_procedimento_w)||') ';
	end if;

	/* Valida quantidades de anestesistas */

	if (ie_anestesista_w	= 'S')	and (qt_porte_anestesico_w	= 0)	and (qt_partic_funcao_w > 0)	and
		((length(ds_erro_w) <= 2500) or (coalesce(ds_erro_w::text, '') = '')) and (ie_existe2221_w = 0) 	then
		
		ds_erro_w	:= ds_erro_w ||'2221'||'('||to_char(cd_procedimento_w)||') ';
	end if;
	if (ie_anestesista_w	= 'S')	and (qt_partic_funcao_w > 1)	and
		((length(ds_erro_w) <= 2500) or (coalesce(ds_erro_w::text, '') = '')) and (ie_existe2222_w = 0) then
		
		ds_erro_w	:= ds_erro_w ||'2222'||'('||to_char(cd_procedimento_w)||') ';
	end if;
	end;
	
END LOOP;
CLOSE C01;


if (ie_consiste_partic_menor_w = 'S') then
	begin
	OPEN C02;
	LOOP
	FETCH C02 	into
			cd_procedimento_w,
			ie_origem_proced_w,
			cd_edicao_amb_w,
			dt_conta_w,
			qt_partic_funcao_w,
			cd_convenio_w,
			cd_categoria_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		
		select coalesce(position(' 2230' in ds_erro_w),0)
		into STRICT ie_existe2230_w 
		;		
		
		/* obter qtd de participante da tabela de preço */

		if (ie_origem_proced_w in (1,4,5,8)) then
			begin
			select	coalesce(somente_numero(obter_dados_preco_proc(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_edicao_amb_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_w, 'X')),0),
				coalesce(somente_numero(obter_dados_preco_proc(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_edicao_amb_w, cd_procedimento_w, ie_origem_proced_w, dt_conta_w, 'P')),0)
			into STRICT	nr_auxiliares_w,
				qt_porte_anestesico_w
			;
			end;
		else
			begin
			nr_auxiliares_w		:= 0;
		 	qt_porte_anestesico_w	:= 0;
			end;
		end if;

		/* Valida quantidades de auxiliares - Quantidade inferior */

		if (nr_auxiliares_w > 0) 	and
			((length(ds_erro_w) <= 2500) or (coalesce(ds_erro_w::text, '') = '')) and (ie_existe2230_w = 0) then
			
			ds_erro_w	:= ds_erro_w ||'2230'||'('||to_char(cd_procedimento_w)||') ';			
		end if;	

		end;
	END LOOP;
	CLOSE C02;
	end;	
end if;

ds_erro_p		:= substr(ds_erro_w,1,255);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_participante ( nr_interno_conta_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
