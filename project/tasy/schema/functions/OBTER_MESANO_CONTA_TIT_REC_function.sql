-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mesano_conta_tit_rec ( nr_titulo_p bigint) RETURNS timestamp AS $body$
DECLARE

 
dt_mesano_conta_w		timestamp;
dt_emissao_w			timestamp;
nr_interno_conta_w		bigint;
nr_seq_protocolo_w		bigint;


BEGIN 
 
select		nr_seq_protocolo, 
		nr_interno_conta, 
		dt_emissao 
into STRICT		nr_seq_protocolo_w, 
		nr_interno_conta_w, 
		dt_emissao_w 
from		Titulo_receber 
where		nr_titulo		= nr_titulo_p;
 
dt_mesano_Conta_w		:= trunc(dt_emissao_w,'month');
if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then 
	select 	trunc(dt_mesano_referencia,'month') 
	into STRICT	dt_mesano_conta_w 
	from	conta_paciente 
	where nr_interno_conta	= nr_interno_conta_w;
elsif (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then 
	select 	trunc(dt_mesano_referencia,'month') 
	into STRICT	dt_mesano_conta_w 
	from	Protocolo_convenio 
	where nr_seq_protocolo	= nr_seq_protocolo_w;
end if;
 
RETURN dt_mesano_Conta_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mesano_conta_tit_rec ( nr_titulo_p bigint) FROM PUBLIC;

