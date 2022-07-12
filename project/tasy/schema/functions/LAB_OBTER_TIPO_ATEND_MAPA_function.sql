-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_tipo_atend_mapa (cd_mapa_p bigint) RETURNS bigint AS $body$
DECLARE

 
					 
ie_tipo_atendimento_w 	smallint;
nr_prescricao_w		bigint;
nr_atendimento_w	bigint;


BEGIN 
-- FUNCTION CRIADA PARA A OBTENÇÃO DO TIPO DE ATENDIMENTO DE UM MAPA DE EXAMES -- 
 
select 	max(nr_prescricao) 
into STRICT	nr_prescricao_w 
from	lab_impressao_mapa 
where	cd_mapa = cd_mapa_p;
 
select 	max(ie_tipo_atendimento) 
into STRICT	ie_tipo_atendimento_w 
from 	prescr_medica a, 
	atendimento_paciente b 
where	a.nr_atendimento = b.nr_atendimento 
and	a.nr_prescricao = nr_prescricao_w;
 
return	ie_tipo_atendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_tipo_atend_mapa (cd_mapa_p bigint) FROM PUBLIC;
