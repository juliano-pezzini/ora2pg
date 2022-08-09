-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_atualiza_pac_trat_cronico (nr_seq_tratamento_p bigint, ie_paciente_agudo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_motivo_fim_cronico_w	bigint;
nr_seq_motivo_fim_agudo_w	bigint;


BEGIN

select 	max(nr_seq_motivo_fim_cronico),
	max(nr_seq_motivo_fim_agudo)
into STRICT	nr_seq_motivo_fim_cronico_w,
	nr_seq_motivo_fim_agudo_w
from 	hd_parametro
where	cd_estabelecimento = cd_estabelecimento_p;

if (coalesce(nr_seq_motivo_fim_cronico_w::text, '') = '' and ie_paciente_agudo_p = 'S') or (coalesce(nr_seq_motivo_fim_agudo_w::text, '') = '' and ie_paciente_agudo_p = 'N') then

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264188);

end if;

if (ie_paciente_agudo_p = 'S') then


	insert into paciente_tratamento(nr_sequencia,
					cd_pessoa_fisica,
					ie_tratamento,
					dt_inicio_tratamento,
					dt_final_tratamento,
					ds_motivo_fim,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_observacao,
					nr_seq_motivo_fim,
					ie_paciente_agudo)
	SELECT				nextval('paciente_tratamento_seq'),
					cd_pessoa_fisica,
					ie_tratamento,
					dt_inicio_tratamento,
					clock_timestamp(),
					ds_motivo_fim,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_observacao,
					NR_SEQ_MOTIVO_FIM_CRONICO_w,
					'N'
	from	paciente_tratamento
	where	nr_sequencia = nr_seq_tratamento_p
	and	coalesce(dt_final_tratamento::text, '') = '';

end if;

if (ie_paciente_agudo_p = 'N') then


	insert into paciente_tratamento(nr_sequencia,
					cd_pessoa_fisica,
					ie_tratamento,
					dt_inicio_tratamento,
					dt_final_tratamento,
					ds_motivo_fim,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_observacao,
					nr_seq_motivo_fim,
					ie_paciente_agudo)
	SELECT				nextval('paciente_tratamento_seq'),
					cd_pessoa_fisica,
					ie_tratamento,
					dt_inicio_tratamento,
					clock_timestamp(),
					ds_motivo_fim,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_observacao,
					NR_SEQ_MOTIVO_FIM_AGUDO_w,
					'S'
	from	paciente_tratamento
	where	nr_sequencia = nr_seq_tratamento_p
	and	coalesce(dt_final_tratamento::text, '') = '';

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_atualiza_pac_trat_cronico (nr_seq_tratamento_p bigint, ie_paciente_agudo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
