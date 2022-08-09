-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_gerar_protocolo ( cd_protocolo_p bigint, nr_seq_medicacao_p bigint, nr_atendimento_p bigint, ie_prescricao_p text, ie_evolucao_p text, ie_receita_p text, ie_diagnostico_p text, ie_orientacao_alta_p text, ie_orientacao_geral_p text, ie_atestado_p text, ie_justificativa_p text, nm_usuario_p text, ie_atualizar_data_p text, ie_anamnese_p text ) AS $body$
DECLARE


nr_prescricao_w	bigint;
ie_item_inconsistente_w varchar(1);

BEGIN

SELECT * FROM Gerar_Protocolo_PA(cd_protocolo_p, nr_seq_medicacao_p, nr_atendimento_p, ie_prescricao_p, ie_evolucao_p, ie_receita_p, ie_diagnostico_p, ie_orientacao_alta_p, ie_orientacao_geral_p, ie_atestado_p, ie_justificativa_p, ie_anamnese_p, nm_usuario_p, nr_prescricao_w, ie_item_inconsistente_w) INTO STRICT nr_prescricao_w, ie_item_inconsistente_w;

if (coalesce(ie_atualizar_data_p,'N') = 'S') then
	begin
	CALL Atualizar_data_atend_medico(nr_atendimento_p);
	end;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_gerar_protocolo ( cd_protocolo_p bigint, nr_seq_medicacao_p bigint, nr_atendimento_p bigint, ie_prescricao_p text, ie_evolucao_p text, ie_receita_p text, ie_diagnostico_p text, ie_orientacao_alta_p text, ie_orientacao_geral_p text, ie_atestado_p text, ie_justificativa_p text, nm_usuario_p text, ie_atualizar_data_p text, ie_anamnese_p text ) FROM PUBLIC;
