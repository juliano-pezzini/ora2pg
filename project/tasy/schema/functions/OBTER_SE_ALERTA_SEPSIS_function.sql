-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_alerta_sepsis ( nr_atendimento_p text) RETURNS varchar AS $body$
DECLARE


retorno_w				varchar(1) := '';
ds_mensagem_w			varchar(255) := '';
ie_acao_w				varchar(15)  := '';
ie_gravidade_w			varchar(15)  := '';
nr_seq_escala_w			bigint;	
ds_deflagradores_w		varchar(4000) := '';
nr_seq_sinal_vital_w 	bigint;
ie_fim_vida_w        	varchar(1);
ie_doencas_atipica_w 	varchar(1);
ds_mensagem_cliente_w 	varchar(255) := '';
ie_somente_alerta_w		varchar(1);
									

BEGIN

if (coalesce(nr_atendimento_p,0) > 0) then	

	SELECT * FROM Obter_se_alerta_mentor(nr_atendimento_p, ds_mensagem_w, ie_acao_w, ie_gravidade_w, nr_seq_escala_w, nr_seq_sinal_vital_w, ds_deflagradores_w, ie_fim_vida_w, ie_doencas_atipica_w, ds_mensagem_cliente_w, ie_somente_alerta_w) INTO STRICT ds_mensagem_w, ie_acao_w, ie_gravidade_w, nr_seq_escala_w, nr_seq_sinal_vital_w, ds_deflagradores_w, ie_fim_vida_w, ie_doencas_atipica_w, ds_mensagem_cliente_w, ie_somente_alerta_w;	
	
	if (ie_acao_w IS NOT NULL AND ie_acao_w::text <> '') then
	
		retorno_w := 'S';
	else
	
		retorno_w := 'N';
	
	end if;
	
end if;

return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_alerta_sepsis ( nr_atendimento_p text) FROM PUBLIC;

