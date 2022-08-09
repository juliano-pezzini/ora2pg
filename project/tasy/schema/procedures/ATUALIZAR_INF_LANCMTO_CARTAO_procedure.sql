-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_inf_lancmto_cartao ( nr_sequencia_p bigint, cd_pessoa_resp_alt_p bigint, nr_seq_cartao_p bigint, nm_paciente_alt_p text, cd_setor_alt_p bigint, cd_unidade_alt_p bigint, ds_obs_alteracao_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and ( nr_sequencia_p > 0 )then

	if (cd_pessoa_resp_alt_p IS NOT NULL AND cd_pessoa_resp_alt_p::text <> '') and ( cd_pessoa_resp_alt_p > 0 ) then
		update	sup_lanc_cartao
		set 	cd_pessoa_resp = cd_pessoa_resp_alt_p
		where	nr_sequencia = nr_sequencia_p;

	end if;

	if (nm_paciente_alt_p IS NOT NULL AND nm_paciente_alt_p::text <> '') then
		update	sup_lanc_cartao
		set 	ds_nome_paciente = nm_paciente_alt_p
		where	nr_sequencia = nr_sequencia_p;
	end if;

	if (cd_setor_alt_p IS NOT NULL AND cd_setor_alt_p::text <> '') and ( cd_setor_alt_p > 0 ) then
		update	sup_lanc_cartao
		set 	cd_setor_atendimento = cd_setor_alt_p
		where	nr_sequencia = nr_sequencia_p;
	end if;

	if (cd_unidade_alt_p IS NOT NULL AND cd_unidade_alt_p::text <> '') and ( cd_unidade_alt_p > 0 ) then
		update	sup_lanc_cartao
		set 	cd_unidade_basica = cd_unidade_alt_p
		where	nr_sequencia = nr_sequencia_p;
	end if;

	if (ds_obs_alteracao_p IS NOT NULL AND ds_obs_alteracao_p::text <> '') then
		update	sup_lanc_cartao
		set 	ds_observacao = ds_obs_alteracao_p
		where	nr_sequencia = nr_sequencia_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_inf_lancmto_cartao ( nr_sequencia_p bigint, cd_pessoa_resp_alt_p bigint, nr_seq_cartao_p bigint, nm_paciente_alt_p text, cd_setor_alt_p bigint, cd_unidade_alt_p bigint, ds_obs_alteracao_p text) FROM PUBLIC;
