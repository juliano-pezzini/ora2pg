-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_valor_rateio_medico ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE



vl_retorno_w		double precision;
cd_procedimento_w	bigint;
vl_medico_sus_w		double precision;
vl_materiais_w		double precision;
vl_medico_w		double precision;
vl_sadt_w		double precision;



BEGIN

/*sum(decode(b.cd_procedimento,95005013,c.vl_medico,99800179,b.vl_materiais,b.vl_medico)) vl_ato,*/

select	a.cd_procedimento,
	b.vl_medico,
	a.vl_materiais,
	a.vl_medico,
	b.vl_ato_sadt
into STRICT	cd_procedimento_w,
	vl_medico_sus_w,
	vl_materiais_w,
	vl_medico_w,
	vl_sadt_w
from	sus_valor_proc_paciente	b,
	procedimento_paciente	a
where	a.nr_sequencia 		= b.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

if (cd_procedimento_w	in (95005013,95006010)) then
	vl_retorno_w		:= vl_medico_sus_w;
/* Felipe Martini OS72633
elsif	(cd_procedimento_w	= 99800179) then
	vl_retorno_w		:= vl_materiais_w;
*/
elsif (cd_procedimento_w	< 23999999) then
	vl_retorno_w		:= vl_sadt_w;
else
	vl_retorno_w		:= vl_medico_w;
end if;

return	vl_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_valor_rateio_medico ( nr_sequencia_p bigint) FROM PUBLIC;

