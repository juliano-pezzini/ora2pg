-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE confirmar_diagnostico ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_doenca_p text, cd_medico_p text, nm_usuario_p text, ie_tipo_diagnostico_p bigint, ie_classificacao_doenca_p text) AS $body$
BEGIN
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
	begin 
         if ((cd_doenca_p IS NOT NULL AND cd_doenca_p::text <> '') or cd_doenca_p != '') then 
	  CALL gerar_diagnostico_atend(nr_atendimento_p,cd_doenca_p,cd_medico_p,nm_usuario_p,ie_tipo_diagnostico_p,ie_classificacao_doenca_p);
         end if;
	 CALL atualizar_data_geracao(nr_sequencia_p,nm_usuario_p);
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE confirmar_diagnostico ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_doenca_p text, cd_medico_p text, nm_usuario_p text, ie_tipo_diagnostico_p bigint, ie_classificacao_doenca_p text) FROM PUBLIC;

