-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tx_mortalidade_setor (DT_MES_REFERENCIA_p timestamp, CD_SETOR_ATENDIMENTO_p bigint) RETURNS bigint AS $body$
DECLARE

 
tx_mortalidade_w		bigint;		
qt_paciente_w			bigint;		
qt_obito_w			bigint;
dt_inicial_w			timestamp;
dt_final_w			timestamp;		
		 

BEGIN 
 
dt_inicial_w			:= trunc(DT_MES_REFERENCIA_p, 'dd');
dt_final_w			:= fim_dia(fim_mes(trunc(DT_MES_REFERENCIA_p, 'dd')));
 
 
select	sum(CASE WHEN b.ie_obito='S' THEN  1  ELSE 0 END ) qt_obito 
into STRICT	qt_obito_w 
from	motivo_alta b, atendimento_paciente a 
where	a.dt_alta between dt_inicial_w and dt_final_w 
and	a.cd_motivo_alta	= b.cd_motivo_alta 
and	Obter_Unidade_Atendimento(a.nr_atendimento, 'A', 'CS') = CD_SETOR_ATENDIMENTO_p;
 
 
select	sum(1) qt_paciente 
into STRICT	qt_paciente_w 
from	motivo_alta b, atendimento_paciente a, atend_paciente_unidade c 
where	(a.dt_alta IS NOT NULL AND a.dt_alta::text <> '') 
and	a.cd_motivo_alta	= b.cd_motivo_alta 
and	c.dt_entrada_unidade between dt_inicial_w and dt_final_w 
and	a.nr_atendimento	= c.nr_atendimento 
 
and 	c.cd_setor_atendimento	= CD_SETOR_ATENDIMENTO_p;
 
 
tx_mortalidade_w	:= dividir((qt_obito_w * 100), qt_paciente_w);
 
 
return	tx_mortalidade_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tx_mortalidade_setor (DT_MES_REFERENCIA_p timestamp, CD_SETOR_ATENDIMENTO_p bigint) FROM PUBLIC;
