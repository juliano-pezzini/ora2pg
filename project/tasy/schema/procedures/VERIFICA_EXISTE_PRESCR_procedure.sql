-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_existe_prescr ( nr_atendimento_p bigint, dt_inicio_prescr_p timestamp, ds_retorno_p INOUT text) AS $body$
DECLARE

 
nr_prescricao_w			prescr_medica.nr_prescricao%type;
nm_medico_w				varchar(60);
dt_inicio_prescr_w		varchar(40);
dt_validade_prescr_w	varchar(40);
ds_complemento_w		varchar(255);
dt_liberacao_w			timestamp;


BEGIN 
ds_retorno_p	:= '';
 
select	coalesce(max(nr_prescricao),0) 
into STRICT	nr_prescricao_w 
from	prescr_medica 
where	nr_atendimento	= nr_atendimento_p 
and	dt_inicio_prescr_p >= dt_inicio_prescr 
and	dt_inicio_prescr_p < dt_validade_prescr 
and	ie_origem_inf	= '1';
 
if (nr_prescricao_w > 0) then 
	select	substr(obter_nome_pf(max(cd_medico)),1,60), 
			to_char(max(dt_inicio_prescr),'dd/mm/yyyy hh24:mi'), 
			to_char(max(dt_validade_prescr),'dd/mm/yyyy hh24:mi'), 
			coalesce(max(dt_liberacao), max(dt_liberacao_medico)) 
	into STRICT	nm_medico_w, 
			dt_inicio_prescr_w, 
			dt_validade_prescr_w, 
			dt_liberacao_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_w;
	 
	ds_complemento_w	:= '';
	 
	if (coalesce(dt_liberacao_w::text, '') = '') then 
		ds_complemento_w	:= ' '||upper(Wheb_mensagem_pck.get_texto(305963))||' '; -- Não liberada 
	end if;
	 
	ds_retorno_p	:= Wheb_mensagem_pck.get_texto(305942, 'NR_PRESCRICAO='||nr_prescricao_w||';NM_MEDICO='|| 
			   				    nm_medico_w||';DS_COMPLEMENTO='||ds_complemento_w||';DT_INICIO_PRESCR='|| 
							    dt_inicio_prescr_w||';DT_VALIDADE_PRESCR='||dt_validade_prescr_w);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_existe_prescr ( nr_atendimento_p bigint, dt_inicio_prescr_p timestamp, ds_retorno_p INOUT text) FROM PUBLIC;
