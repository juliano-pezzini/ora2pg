-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mi_cron_migr_dic_obj ( nr_seq_cronograma_p bigint, nr_seq_etapa_p bigint, nr_seq_obj_mi_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_apresent_w	bigint;
nr_seq_atividade_ww	bigint;
nm_objeto_w		varchar(255);


BEGIN
if (nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') and (nr_seq_etapa_p IS NOT NULL AND nr_seq_etapa_p::text <> '') and (nr_seq_obj_mi_p IS NOT NULL AND nr_seq_obj_mi_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	max(a.nm_objeto)
	into STRICT	nm_objeto_w
	from	dic_objeto a
	where	a.nr_sequencia = nr_seq_obj_mi_p
	and	a.ie_tipo_objeto = 'MI';

	if (nm_objeto_w IS NOT NULL AND nm_objeto_w::text <> '') then
		begin
		select	coalesce(max(a.nr_seq_apres),0) + 10
		into STRICT	nr_seq_apresent_w
		from	proj_cron_etapa a
		where	a.nr_seq_cronograma = nr_seq_cronograma_p
		and	a.nr_seq_superior = nr_seq_etapa_p;

		select	nextval('proj_cron_etapa_seq')
		into STRICT	nr_seq_atividade_ww
		;

		insert into proj_cron_etapa(
			nr_seq_cronograma,
			nr_sequencia,
			ds_atividade,
			ie_fase,
			qt_hora_prev,
			pr_etapa,
			nr_seq_apres,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_modulo,
			ie_tipo_obj_proj_migr,
			nr_seq_superior,
			ie_atividade_adicional)
		values (
			nr_seq_cronograma_p,
			nr_seq_atividade_ww,
			nm_objeto_w,
			'N',
			1,
			0,
			nr_seq_apresent_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			'N',
			'TMenuItem',
			nr_seq_etapa_p,
			'S');

		CALL atualizar_horas_etapa_cron(nr_seq_atividade_ww);
		CALL atualizar_horas_etapa_cron(nr_seq_etapa_p);
		CALL atualizar_total_horas_cron(nr_seq_cronograma_p);
		CALL gerar_classif_etapa_proj(nr_seq_cronograma_p, nm_usuario_p);
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_mi_cron_migr_dic_obj ( nr_seq_cronograma_p bigint, nr_seq_etapa_p bigint, nr_seq_obj_mi_p bigint, nm_usuario_p text) FROM PUBLIC;

