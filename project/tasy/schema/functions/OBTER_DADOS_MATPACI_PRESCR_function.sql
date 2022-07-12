-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_matpaci_prescr (nr_prescricao_p bigint, nr_seq_material_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


dt_atendimento_w		timestamp;
nm_usuario_w			varchar(255);


BEGIN

select	max(dt_atendimento),
	max(nm_usuario)
into STRICT	dt_atendimento_w,
	nm_usuario_w
from	material_atend_paciente
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia_prescricao	= nr_seq_material_p;

if (ie_opcao_p	= 'A') then
	return	to_char(dt_atendimento_w,'dd/mm/yyyy hh24:mi:ss');
else
	return	nm_usuario_w;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_matpaci_prescr (nr_prescricao_p bigint, nr_seq_material_p text, ie_opcao_p text) FROM PUBLIC;
