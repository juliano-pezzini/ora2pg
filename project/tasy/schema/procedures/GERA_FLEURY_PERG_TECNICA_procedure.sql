-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_fleury_perg_tecnica ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, id_roteiro_p text, id_pergunta_p text, ds_pergunta_p text, id_resultado_p text, ds_resultado_p text, nm_usuario_p text ) AS $body$
DECLARE



qt_perg_prescr_w	bigint;
nr_seq_perg_resp_w	bigint;
nr_seq_perg_tec_w	bigint;


BEGIN


select	count(*)
into STRICT	qt_perg_prescr_w
from	fleury_prescr_perg_tec
where	nr_prescricao 	= nr_prescricao_p
and	nr_seq_prescr	= nr_seq_prescr_p
and	id_pergunta	= id_pergunta_p;

 if	not(qt_perg_prescr_w > 0) then

	select	nextval('fleury_prescr_perg_tec_seq')
	into STRICT	nr_seq_perg_tec_w
	;

	insert into fleury_prescr_perg_tec(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_prescricao,
		nr_seq_prescr,
		ds_pergunta,
		--ds_resultado,
		--id_resultado,
		id_roteiro,
		id_pergunta
		)
	values (
		nr_seq_perg_tec_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_prescricao_p,
		nr_seq_prescr_p,
		ds_pergunta_p,
		--ds_resultado_p,
		--id_resultado_p,
		id_roteiro_p,
		id_pergunta_p
		);


	insert	into fleury_prescr_perg_resp(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_perg_tec,
		id_resposta,
		ds_resposta
		)
	values (
		nextval('fleury_prescr_perg_resp_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_perg_tec_w,
		id_resultado_p,
		ds_resultado_p
		);

else

	select	max(nr_sequencia)
	into STRICT	nr_seq_perg_tec_w
	from	fleury_prescr_perg_tec
	where	nr_prescricao 	= nr_prescricao_p
	and	nr_seq_prescr	= nr_seq_prescr_p
	and	id_pergunta	= id_pergunta_p;


	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_perg_resp_w
	from	fleury_prescr_perg_resp
	where	nr_seq_perg_tec = nr_seq_perg_tec_w;


	if (nr_seq_perg_resp_w > 0) then

		update	fleury_prescr_perg_resp
		set	id_resposta = id_resultado_p,
			ds_resposta = ds_resultado_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_seq_perg_resp_w;

	else

		insert	into fleury_prescr_perg_resp(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_perg_tec,
			id_resposta,
			ds_resposta
			)
		values (
			nextval('fleury_prescr_perg_resp_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_perg_tec_w,
			id_resultado_p,
			ds_resultado_p
			);

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_fleury_perg_tecnica ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, id_roteiro_p text, id_pergunta_p text, ds_pergunta_p text, id_resultado_p text, ds_resultado_p text, nm_usuario_p text ) FROM PUBLIC;
