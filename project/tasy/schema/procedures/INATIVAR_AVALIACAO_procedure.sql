-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_avaliacao ( nr_seq_avaliacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

cd_evolucao_w bigint;
ie_gerar_evol_med_aval_w varchar(1) := 'N';

BEGIN
if (nr_seq_avaliacao_p IS NOT NULL AND nr_seq_avaliacao_p::text <> '')then
	begin
	update 	med_avaliacao_paciente
	set 	dt_inativacao = clock_timestamp(),
		ie_situacao = 'I',
		nm_usuario_inativacao = nm_usuario_p
	where 	nr_sequencia = nr_seq_avaliacao_p;
	ie_gerar_evol_med_aval_w := obter_param_usuario(281, 1667, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_evol_med_aval_w);
	if (ie_gerar_evol_med_aval_w='S')then
	select cd_evolucao
	into STRICT cd_evolucao_w
	from med_avaliacao_paciente
	where nr_sequencia = nr_seq_avaliacao_p;
	if (coalesce(cd_evolucao_w ,0) > 0) then
	delete from clinical_note_soap_data where cd_evolucao = cd_evolucao_w  and ie_med_rec_type = 'REHAB' and ie_stage = 1 and ie_cpoe_item_type = 3 and ie_soap_type = 'P' and nr_seq_med_item=nr_seq_avaliacao_p;
	CALL clinical_notes_pck.soap_data_after_delete(cd_evolucao_w);
	end if;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_avaliacao ( nr_seq_avaliacao_p bigint, nm_usuario_p text) FROM PUBLIC;

