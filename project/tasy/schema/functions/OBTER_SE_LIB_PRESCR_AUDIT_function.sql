-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_lib_prescr_audit ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

									 
ie_retorno_w	varchar(1);


BEGIN 
 
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then 
	 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_retorno_w 
	from	auditoria_conta_paciente_v 
	where	nr_interno_conta = nr_interno_conta_p 
	and	obter_se_prescricao_liberada(nr_prescricao, 'E') = 'S' 
	and	nr_prescricao = nr_prescricao_p 
	and	nr_seq_auditoria <> nr_sequencia_p;
	 
end if;
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_lib_prescr_audit ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_interno_conta_p bigint) FROM PUBLIC;
