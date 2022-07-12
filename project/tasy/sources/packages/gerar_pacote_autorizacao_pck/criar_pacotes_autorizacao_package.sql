-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--###################################################################
CREATE OR REPLACE PROCEDURE gerar_pacote_autorizacao_pck.criar_pacotes_autorizacao () AS $body$
DECLARE


nr_seq_pacote_autor_w	bigint;
qt_proc_ja_em_pacote_w	bigint;
i			integer;
j			integer;


BEGIN

RAISE NOTICE '______________________';
RAISE NOTICE 'criar_pacotes_autorizacao';

i	:= 0;
for i in 0..lista_pacotes_w.count - 1 loop

	select	nextval('autor_conv_pacote_seq')
	into STRICT	nr_seq_pacote_autor_w
	;

	insert into AUTOR_CONV_PACOTE(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_sequencia_autor,
		nr_seq_pacote,
		ie_gerado)
	values (nr_seq_pacote_autor_w,
		clock_timestamp(),
		current_setting('gerar_pacote_autorizacao_pck.nm_usuario_w')::varchar(15),
		clock_timestamp(),
		current_setting('gerar_pacote_autorizacao_pck.nm_usuario_w')::varchar(15),
		current_setting('gerar_pacote_autorizacao_pck.nr_sequencia_autor_w')::bigint,
		current_setting('gerar_pacote_autorizacao_pck.lista_pacotes_w')::lista_pacotes_vt[i].nr_seq_pacote,
		'N');

	j := 0;
	if (current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt.count > 0) then
		for j in 0..proc_pacote_w.count -1 loop

			select	count(*)
			into STRICT	qt_proc_ja_em_pacote_w
			from	proc_autor_pacote
			where	nr_seq_pacote_autor	= current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt[j].nr_sequencia;

			if (current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt[j](.nr_seq_pacote IS NOT NULL AND .nr_seq_pacote::text <> '')) and (current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt[j].nr_seq_pacote = current_setting('gerar_pacote_autorizacao_pck.lista_pacotes_w')::lista_pacotes_vt[i].nr_seq_pacote) and (qt_proc_ja_em_pacote_w = 0)then

				insert 	into proc_autor_pacote(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_proc_autor,
					nr_seq_pacote_autor,
					qt_solicitada_pct,
					qt_solicitada_ant)
				values (nextval('proc_autor_pacote_seq'),
					clock_timestamp(),
					current_setting('gerar_pacote_autorizacao_pck.nm_usuario_w')::varchar(15),
					current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt[j].nr_sequencia,
					nr_seq_pacote_autor_w,
					current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt[j].qt_proc_pacote,
					current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt[j].qt_solicitada);
			end if;

		end loop;
	end if;

	RAISE NOTICE ' Pacote: %', current_setting('gerar_pacote_autorizacao_pck.lista_pacotes_w')::lista_pacotes_vt[i].nr_seq_pacote;
	j := 0;
	if (current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt.count > 0) then
		for j in 0..mat_pacote_w.count -1 loop

			RAISE NOTICE ' pacote vet mat: %', current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt[j].nr_seq_pacote;
			RAISE NOTICE ' seq material: %', current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt[j].nr_sequencia;
			if (current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt[j](.nr_seq_pacote IS NOT NULL AND .nr_seq_pacote::text <> '')) and (current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt[j].nr_seq_pacote = current_setting('gerar_pacote_autorizacao_pck.lista_pacotes_w')::lista_pacotes_vt[i].nr_seq_pacote) then

				insert into material_autor_pacote(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_mat_autor,
					nr_seq_pacote_autor,
					qt_solicitada_pct,
					qt_solicitada_ant)
				values (nextval('material_autor_pacote_seq'),
					clock_timestamp(),
					current_setting('gerar_pacote_autorizacao_pck.nm_usuario_w')::varchar(15),
					current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt[j].nr_sequencia,
					nr_seq_pacote_autor_w,
					current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt[j].qt_mat_pacote,
					current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt[j].qt_solicitada);
			end if;
		end loop;
	end if;

end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pacote_autorizacao_pck.criar_pacotes_autorizacao () FROM PUBLIC;
