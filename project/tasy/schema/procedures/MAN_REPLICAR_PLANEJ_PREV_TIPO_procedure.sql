-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_replicar_planej_prev_tipo ( nr_seq_planej_prev_p bigint, ds_valores_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
ds_lista_valores_w		varchar(4000);
ie_pos_virgula_w		smallint	:= 0;
tam_lista_w		bigint;
nr_seq_tipo_equip_w	bigint;


BEGIN
ds_lista_valores_w	:= substr(ds_valores_p,1,4000);

if (ds_valores_p IS NOT NULL AND ds_valores_p::text <> '') then
	begin
	WHILE(ds_lista_valores_w IS NOT NULL AND ds_lista_valores_w::text <> '') LOOP
		begin
		tam_lista_w	:= length(ds_lista_valores_w);
		ie_pos_virgula_w	:= position(',' in ds_lista_valores_w);

		if (ie_pos_virgula_w <> 0) then
			nr_seq_tipo_equip_w	:= substr(ds_lista_valores_w,1,(ie_pos_virgula_w - 1));
			ds_lista_valores_w		:= substr(ds_lista_valores_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;

		select	nextval('man_planej_prev_seq')
		into STRICT	nr_sequencia_w
		;

		insert into man_planej_prev(
				nr_sequencia,
				ds_planejamento,
				dt_atualizacao,
				nm_usuario,
				nr_seq_tipo_equip,
				nr_seq_tipo_contador,
				nr_seq_frequencia,
				qt_dia_previsto,
				qt_dia_gerar_ordem,
				ie_prioridade,
				cd_pessoa_solicitante,
				ds_dano,
				ie_situacao,
				cd_setor_atendimento,
				dt_inicial,
				ie_impacto,
				ie_contador,
				nr_seq_equip,
				nm_usuario_exec,
				ie_solicitante,
				ie_comunicacao,
				qt_dia_sobreposicao,
				nr_seq_superior,
				cd_estabelecimento,
				cd_perfil,
				ie_data_inicio_geracao,
				ie_dia_ultima_verif,
				ie_grau_satisfacao,
				nr_seq_estagio,
				ie_dia_nao_util,
				ie_dia_util,
				nr_seq_origem_dano,
				nr_seq_causa_dano,
				nr_seq_tipo_solucao,
				nr_seq_complex,
				nr_seq_cs,
				nr_seq_marca,
				nr_seq_modelo)
			SELECT	nr_sequencia_w,
				ds_planejamento,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_tipo_equip_w,
				nr_seq_tipo_contador,
				nr_seq_frequencia,
				qt_dia_previsto,
				qt_dia_gerar_ordem,
				ie_prioridade,
				cd_pessoa_solicitante,
				ds_dano,
				ie_situacao,
				cd_setor_atendimento,
				dt_inicial,
				ie_impacto,
				ie_contador,
				null,
				nm_usuario_exec,
				ie_solicitante,
				ie_comunicacao,
				qt_dia_sobreposicao,
				nr_seq_superior,
				cd_estabelecimento,
				cd_perfil,
				ie_data_inicio_geracao,
				ie_dia_ultima_verif,
				ie_grau_satisfacao,
				nr_seq_estagio,
				ie_dia_nao_util,
				ie_dia_util,
				nr_seq_origem_dano,
				nr_seq_causa_dano,
				nr_seq_tipo_solucao,
				nr_seq_complex,
				nr_seq_cs,
				nr_seq_marca,
				nr_seq_modelo
			from	man_planej_prev
			where	nr_sequencia = nr_seq_planej_prev_p;


		insert into man_planej_atividade(
				nr_sequencia,
				nr_seq_planej_prev,
				dt_atualizacao,
				nm_usuario,
				ds_atividade,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				qt_min_prev)
			SELECT	nextval('man_planej_atividade_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				ds_atividade,
				clock_timestamp(),
				nm_usuario_p,
				qt_min_prev
			from	man_planej_atividade
			where	nr_seq_planej_prev = nr_seq_planej_prev_p;


		insert into man_planej_prev_arq(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_planej_prev,
				ds_arquivo,
				ie_anexar_email)
			SELECT	nextval('man_planej_prev_arq_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_sequencia_w,
				ds_arquivo,
				ie_anexar_email
			from	man_planej_prev_arq
			where	nr_seq_planej_prev = nr_seq_planej_prev_p;


		insert into man_planej_prev_regra(
				nr_sequencia,
				nr_seq_planej_prev,
				dt_atualizacao,
				nm_usuario,
				ds_regra,
				qt_contador,
				nr_seq_planej_contador,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
			SELECT	nextval('man_planej_prev_regra_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				ds_regra,
				qt_contador,
				nr_seq_planej_contador,
				clock_timestamp(),
				nm_usuario_p
			from	man_planej_prev_regra
			where	nr_seq_planej_prev = nr_seq_planej_prev_p;


		insert into man_regra_data_frequencia(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_planej_prev,
				dt_geracao,
				ie_data_hora,
				hr_geracao,
				dt_dia_semana)
			SELECT	nextval('man_regra_data_frequencia_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_sequencia_w,
				dt_geracao,
				ie_data_hora,
				hr_geracao,
				dt_dia_semana
			from	man_regra_data_frequencia
			where	nr_seq_planej_prev = nr_seq_planej_prev_p;
		end;
	END loop;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_replicar_planej_prev_tipo ( nr_seq_planej_prev_p bigint, ds_valores_p text, nm_usuario_p text) FROM PUBLIC;

