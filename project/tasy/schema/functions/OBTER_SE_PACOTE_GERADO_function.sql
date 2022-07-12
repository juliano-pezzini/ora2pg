-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pacote_gerado ( nr_atendimento_p bigint, nr_interno_conta_p bigint ) RETURNS varchar AS $body$
DECLARE


					retorno_w		varchar(2);
nr_interno_conta_ret_w	double precision;
ds_pacote_w		varchar(10);
resultado_w		bigint;


BEGIN

SELECT * FROM obter_atendimento_pacote(	nr_atendimento_p, nr_interno_conta_p, null, ds_pacote_w, nr_interno_conta_ret_w, null, null) INTO STRICT ds_pacote_w, nr_interno_conta_ret_w;

retorno_w	:= 'NP';

select	count(*)
into STRICT	resultado_w
from	atendimento_pacote a
where	1 = 1
and	a.nr_seq_proc_origem in (	SELECT	nr_sequencia
					from	procedimento_paciente
					where	nr_interno_conta = nr_interno_conta_p)
order 	by 1;

if (ds_pacote_w	= 'S') and (resultado_w = 0) then
	retorno_w	:= 'N';
elsif (resultado_w	> 0) then
	retorno_w	:= 'S';
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pacote_gerado ( nr_atendimento_p bigint, nr_interno_conta_p bigint ) FROM PUBLIC;
