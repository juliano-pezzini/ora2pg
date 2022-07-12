-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION oft_obter_status_pronto_atend (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


								
dt_inicio_atendimento_w		timestamp;
dt_fim_triagem_w			timestamp;
dt_atend_medico_w  		timestamp;
dt_fim_consulta_w      	    	timestamp;
ds_valor_dominio_w		varchar(255);
dt_alta_w				timestamp;
ie_evasao_w				varchar(1);								
								
/*	ie_opcao_p		Descrição 
	C			Código	
	D			Descrição
*/
								

BEGIN


Select   max(dt_inicio_atendimento),
         max(dt_fim_triagem),
         max(dt_atend_medico),
         max(dt_fim_consulta),
         max(dt_alta),
         max(obter_se_motivo_alta_evasao(cd_motivo_alta))
into STRICT	   dt_inicio_atendimento_w,
         dt_fim_triagem_w,
         dt_atend_medico_w,
         dt_fim_consulta_w,
         dt_alta_w,
         ie_evasao_w
from	   atendimento_paciente
where 	nr_atendimento = nr_atendimento_p;

If (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') and (ie_evasao_w = 'S')  then
	if (ie_opcao_p = 'C')then
		return 'EV'; --Evadido
	elsif (ie_opcao_p = 'D') then
		Select	substr(obter_valor_dominio(9444, 'EV'), 1, 254)
		into STRICT	   ds_valor_dominio_w
		;
		return 	ds_valor_dominio_w;
	end if;
elsif (dt_fim_consulta_w IS NOT NULL AND dt_fim_consulta_w::text <> '') then
   if (ie_opcao_p = 'C')then
      return 'CF'; --Consulta finalizada
   elsif (ie_opcao_p = 'D') then
      Select	substr(obter_valor_dominio(9444, 'CF'), 1, 254)
      into STRICT	   ds_valor_dominio_w
;
      return 	ds_valor_dominio_w;
   end if;
elsif (dt_atend_medico_w IS NOT NULL AND dt_atend_medico_w::text <> '') then
   if (ie_opcao_p = 'C')   then
      return 'EC'; --Em consulta
   elsif (ie_opcao_p = 'D') then
      Select	substr(obter_valor_dominio(9444, 'EC'), 1, 254)
      into STRICT	   ds_valor_dominio_w
;
      return 	ds_valor_dominio_w;
   end if;
elsif (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') then
   if (ie_opcao_p = 'C') then
      Return 'AC'; --Aguardando consulta
   elsif (ie_opcao_p = 'D') then
      Select	substr(obter_valor_dominio(9444, 'AC'), 1, 254)
      into STRICT	   ds_valor_dominio_w
;
      return 	ds_valor_dominio_w;
   end if;
elsif (dt_inicio_atendimento_w IS NOT NULL AND dt_inicio_atendimento_w::text <> '') then
   if (ie_opcao_p = 'C')then
      return 'ET'; --Em triagem
   elsif (ie_opcao_p = 'D') then			
      Select	substr(obter_valor_dominio(9444, 'ET'), 1, 254)
      into STRICT	ds_valor_dominio_w
;	
      return 	ds_valor_dominio_w;			
   end if;
else
   if (ie_opcao_p = 'C')   then
      return 'AT'; --Aguardando Triagem
   elsif (ie_opcao_p = 'D') then
      Select	substr(obter_valor_dominio(9444, 'AT'), 1, 254)
      into STRICT	   ds_valor_dominio_w
;
      return 	ds_valor_dominio_w;	
   end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION oft_obter_status_pronto_atend (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

