-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_conta_apres ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE

			 
dt_mesano_referencia_w	timestamp;
ds_retorno_w		varchar(1);


BEGIN 
select	max(dt_mesano_referencia) 
into STRICT	dt_mesano_referencia_w 
from	protocolo_convenio 
where	nr_seq_protocolo	= nr_seq_protocolo_p;
 
select	coalesce(max('N'),'S') 
into STRICT	ds_retorno_w 
 
where	exists (	SELECT	1 
			from	procedimento_paciente a 
			where	a.nr_interno_conta	= nr_interno_conta_p 
			and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
			and	trunc(dt_procedimento,'Month') < add_months(trunc(dt_mesano_referencia_w,'Month'),-3));
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_conta_apres ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint) FROM PUBLIC;

