-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bloqueio_proc_adic_apac ( nr_sequencia_p bigint, cd_proc_secundario_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w			varchar(1) := 'N';
ie_apac_inicial_w		varchar(1);
ie_apac_continuidade_w		varchar(1);
qt_maxima_w			smallint;
ie_maxima_w			varchar(4);	
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;


BEGIN 
if (nr_sequencia_p	> 0) then 
 
	/* obter dados do laudo	*/
 
	select	a.cd_procedimento_solic, 
		a.ie_origem_proced 
	into STRICT	cd_procedimento_w, 
		ie_origem_proced_w 
	from	pessoa_fisica		c, 
	 	atendimento_paciente	b, 
	 	sus_laudo_paciente 	a 
	where	a.nr_seq_interno	= nr_sequencia_p 
	and	a.nr_atendimento	= b.nr_atendimento 
	and	b.cd_pessoa_fisica	= c.cd_pessoa_fisica;
 
	begin 
	select	ie_apac_inicial, 
		ie_apac_continuidade, 
		CASE WHEN ie_maxima='C2' THEN 13 WHEN ie_maxima='C3' THEN 9  ELSE somente_numero(coalesce(ie_maxima,'0')) END , 
		ie_maxima 
	into STRICT	ie_apac_inicial_w, 
		ie_apac_continuidade_w, 
		qt_maxima_w, 
		ie_maxima_w 
	from	sus_apac_regra_tela 
	where	cd_proc_principal	= cd_procedimento_w 
	and	cd_proc_secundario	= cd_proc_secundario_p;
	exception 
		when others then 
		begin 
		ie_apac_inicial_w	:= 'X';
		ie_apac_continuidade_w	:= 'X';
		end;
	end;
	if (ie_origem_proced_w		<> 7) and (ie_apac_inicial_w		= 'X') 	and (ie_apac_continuidade_w 	= 'X') 	then 
		ds_retorno_w	:= 'S';
		end if;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bloqueio_proc_adic_apac ( nr_sequencia_p bigint, cd_proc_secundario_p bigint) FROM PUBLIC;

