-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_preco_amb ( nr_sequencia_p bigint, ie_campo_p text) RETURNS bigint AS $body$
DECLARE

 
/* ie_campo_p 
'O' = vl_custo_operacional_w 
'F' = qt_filme_w */
 
 
qt_retorno_w			double precision;
vl_custo_operacional_w		double precision;
qt_filme_w			double precision;


BEGIN 
 
begin 
select	a.vl_custo_operacional, 
	a.qt_filme 
into STRICT	vl_custo_operacional_w, 
	qt_filme_w 
from	procedimento_paciente b, 
	preco_amb a 
where	b.nr_sequencia = nr_sequencia_p 
and	b.cd_edicao_amb = a.cd_edicao_amb 
and	b.cd_procedimento = a.cd_procedimento 
and	b.ie_origem_proced = a.ie_origem_proced 
and	a.dt_inicio_vigencia = ( 
	SELECT	max(x.dt_inicio_vigencia) 
	from	preco_amb x 
	where	x.dt_inicio_vigencia = a.dt_inicio_vigencia);
exception 
	when others then 
	begin 
	vl_custo_operacional_w	:= 0;
	qt_filme_w			:= 0;
	end;
end;
 
if (ie_campo_p = 'O') then 
	qt_retorno_w	:= vl_custo_operacional_w;
elsif (ie_campo_p = 'F') then 
	qt_retorno_w	:= qt_filme_w;
end if;
 
return qt_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_preco_amb ( nr_sequencia_p bigint, ie_campo_p text) FROM PUBLIC;
