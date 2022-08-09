-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_ata (nr_seq_ata_p bigint, ie_proj_ata_participante_p text, ie_proj_ata_pauta_p text, ie_proj_ata_conteudo_p text, ie_proj_ata_pendencia_p text, nm_usuario_p text) AS $body$
DECLARE




nr_sequencia_w		bigint;
nr_seq_ata_dest_w	bigint;

/*
proj_ata
proj_ata_participante
proj_ata_pauta
proj_ata_conteudo
proj_ata_pendencia
*/
BEGIN

select	nextval('proj_ata_seq')
into STRICT	nr_seq_ata_dest_w
;

insert into proj_ata(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_cliente,
			dt_ata,
			dt_liberacao,
			cd_estabelecimento,
			cd_consultor,
			ds_ata,
			dt_recebimento,
			nr_seq_projeto,
			nr_seq_proj_gpi,
			ie_tipo_ata,
			nr_seq_canal)
		SELECT	nr_seq_ata_dest_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_cliente,
			dt_ata,
			null,
			cd_estabelecimento,
			cd_consultor,
			ds_ata,
			null,
			nr_seq_projeto,
			nr_seq_proj_gpi,
			ie_tipo_ata,
			nr_seq_canal
		from	proj_ata
		where	nr_sequencia = nr_seq_ata_p;

commit;

if (ie_proj_ata_participante_p = 'S') then

	insert into proj_ata_participante(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_ata,
					ie_faltou,
					nm_pessoa_participante,
					ds_setor,
					cd_pessoa_participante,
					cd_setor_atendimento,
					ds_email)
				SELECT nextval('proj_ata_participante_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_ata_dest_w,
					ie_faltou,
					nm_pessoa_participante,
					ds_setor,
					cd_pessoa_participante,
					cd_setor_atendimento,
					ds_email
				from	proj_ata_participante
				where	nr_seq_ata = nr_seq_ata_p;
	end if;

if (ie_proj_ata_pauta_p = 'S') then

	insert into proj_ata_pauta(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_ata,
				ds_pauta)
			SELECT	nextval('proj_ata_pauta_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_ata_dest_w,
				ds_pauta
			from	proj_ata_pauta
			where	nr_seq_ata = nr_seq_ata_p;
end if;

if (ie_proj_ata_conteudo_p = 'S') then

	insert into proj_ata_conteudo(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_ata,
			ds_conteudo,
			ds_titulo,
			nr_seq_apresentacao)
		SELECT	nextval('proj_ata_conteudo_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_ata_dest_w,
			ds_conteudo,
			ds_titulo,
			nr_seq_apresentacao
		from	proj_ata_conteudo
		where	nr_seq_ata = nr_seq_ata_p;

end if;

if (ie_proj_ata_pendencia_p = 'S') then

	insert into proj_ata_pendencia(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_ata,
				ds_pendencia,
				dt_prev_solucao,
				nm_pessoa_resp,
				ie_relat_desempenho,
				nr_seq_classif,
				dt_conclusao_real,
				ds_observacao,
				nr_seq_etapa,
				ie_status)
			SELECT	nextval('proj_ata_pendencia_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_ata_dest_w,
				ds_pendencia,
				dt_prev_solucao,
				nm_pessoa_resp,
				ie_relat_desempenho,
				nr_seq_classif,
				dt_conclusao_real,
				ds_observacao,
				nr_seq_etapa,
				ie_status
			from	proj_ata_pendencia
			where	nr_seq_ata = nr_seq_ata_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_ata (nr_seq_ata_p bigint, ie_proj_ata_participante_p text, ie_proj_ata_pauta_p text, ie_proj_ata_conteudo_p text, ie_proj_ata_pendencia_p text, nm_usuario_p text) FROM PUBLIC;
