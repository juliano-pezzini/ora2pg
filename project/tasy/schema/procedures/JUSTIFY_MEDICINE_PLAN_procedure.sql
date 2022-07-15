-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE justify_medicine_plan ( nr_seq_plan_p text, ds_lista_sequences_p text, ds_texto_p text, ie_acao_p text, nm_usuario_p text) AS $body$
BEGIN
if (ds_lista_sequences_p IS NOT NULL AND ds_lista_sequences_p::text <> '' AND ds_texto_p IS NOT NULL AND ds_texto_p::text <> '') then
	if (	ie_acao_p = 'U') then
		update	plano_versao_medic
		set	ds_justificativa = ds_texto_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_seq_versao = nr_seq_plan_p
		and	obter_se_contido_char(nr_sequencia, ds_lista_sequences_p ) = 'S'
		and	get_if_patient_allergic(CD_PESSOA_FISICA, CD_MATERIAL, 'A') = 'S';
	elsif (	ie_acao_p = 'A') then
		update	KV_RECEITA_FARMACIA_ITEM
		set	ds_inconsistencia = ds_texto_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_seq_receita = nr_seq_plan_p	
		and	obter_se_contido_char(nr_sequencia, ds_lista_sequences_p ) = 'S'
		and	get_if_patient_allergic((SELECT a.cd_pessoa_fisica from KV_RECEITA_FARMACIA a where a.nr_sequencia = NR_SEQ_RECEITA), CD_MATERIAL, 'A') = 'S';
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE justify_medicine_plan ( nr_seq_plan_p text, ds_lista_sequences_p text, ds_texto_p text, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

