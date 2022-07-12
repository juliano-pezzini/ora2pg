-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_filme_amb (cd_edicao_amb_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp) RETURNS bigint AS $body$
DECLARE

 
qt_filme_w			double precision;


BEGIN 
 
begin 
select	max(qt_filme) 
into STRICT	qt_filme_w 
from	preco_amb 
where	cd_edicao_amb 		= cd_edicao_amb_p 
and	cd_procedimento 	= cd_procedimento_p 
and	ie_origem_proced 	= ie_origem_proced_p 
and	dt_inicio_vigencia 	= 
	(SELECT	max(x.dt_inicio_vigencia) 
	from	preco_amb x 
	where	coalesce(x.dt_inicio_vigencia, dt_procedimento_p) <= dt_procedimento_p 
	and	cd_edicao_amb 	   = cd_edicao_amb_p 
	and	cd_procedimento   = cd_procedimento_p 
	and	ie_origem_proced  = ie_origem_proced_p);
exception 
	when others then 
	begin 
	qt_filme_w		:= 0;
	end;
end;
 
return qt_filme_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_filme_amb (cd_edicao_amb_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_procedimento_p timestamp) FROM PUBLIC;
