-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adic_sub_fase_cron_proj_migr ( nr_seq_cronograma_p bigint, nr_seq_fase_p bigint, ie_atividade_p text, nm_atividade_p text, nm_usuario_p text) AS $body$
DECLARE



ie_existe_fase_w	varchar(1);
nr_seq_atividade_w	bigint;
nr_seq_apresent_w	bigint;


BEGIN
if (nr_seq_cronograma_p IS NOT NULL AND nr_seq_cronograma_p::text <> '') and (nr_seq_fase_p IS NOT NULL AND nr_seq_fase_p::text <> '') and (ie_atividade_p IS NOT NULL AND ie_atividade_p::text <> '') and (nm_atividade_p IS NOT NULL AND nm_atividade_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_existe_fase_w
	from	proj_cron_etapa
	where	nr_seq_cronograma = nr_seq_cronograma_p
	and	nr_sequencia = nr_seq_fase_p;

	if (ie_existe_fase_w = 'S') then
		begin
		select	coalesce(max(nr_seq_apres),0) + 10
		into STRICT	nr_seq_apresent_w
		from	proj_cron_etapa
		where	nr_seq_cronograma = nr_seq_cronograma_p
		and	nr_seq_superior = nr_seq_fase_p;

		select	nextval('proj_cron_etapa_seq')
		into STRICT	nr_seq_atividade_w
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
			nr_seq_atividade_w,
			nm_atividade_p,
			'S',
			0,
			0,
			nr_seq_apresent_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			'N',
			ie_atividade_p,
			nr_seq_fase_p,
			'S');

		CALL atualizar_horas_etapa_cron(nr_seq_atividade_w);
		CALL atualizar_horas_etapa_cron(nr_seq_fase_p);
		CALL atualizar_total_horas_cron(nr_seq_cronograma_p);
		CALL gerar_classif_etapa_proj(nr_seq_cronograma_p, nm_usuario_p);
		end;
	else
		begin
		CALL wheb_mensagem_pck.exibir_mensagem_abort(281860);
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
-- REVOKE ALL ON PROCEDURE adic_sub_fase_cron_proj_migr ( nr_seq_cronograma_p bigint, nr_seq_fase_p bigint, ie_atividade_p text, nm_atividade_p text, nm_usuario_p text) FROM PUBLIC;
