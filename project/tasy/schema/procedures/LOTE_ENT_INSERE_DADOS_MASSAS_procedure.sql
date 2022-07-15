-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_insere_dados_massas ( nr_seq_exame_p bigint, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, nr_seq_patologia_p bigint, ds_mensagem_patol_p text, ds_frase_patol_p text, ds_patologia_p text, ds_acao_criterio_p text, ds_mensagem_criterio_p text, nr_sequencia_p bigint, qt_minima_patol_p bigint, qt_maxima_patol_p bigint, ds_obs_ref_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_patol_w			bigint;
ds_observacao_lote_w	varchar(4000);
ds_obs_patol_lab_w		varchar(4000);
qt_registro_w			bigint;
nr_seq_massas_w			bigint;


BEGIN

select	max(a.nr_sequencia)
into STRICT	nr_seq_patol_w
from	lab_patologia a,
		lab_patologia_exame b
where	a.nr_sequencia = b.nr_seq_patologia
and		a.nr_sequencia = nr_seq_patologia_p
and		b.nr_seq_exame = nr_seq_exame_p;

select 	lote_ent_frase_patol_exame(nr_seq_patol_w)
into STRICT	ds_observacao_lote_w
;

select	ds_obs_lote_ent
into STRICT	ds_obs_patol_lab_w
from	exame_lab_result_item
where	nr_seq_resultado = nr_seq_resultado_p
and		nr_seq_exame = nr_seq_exame_p
and		nr_seq_prescr = nr_seq_prescr_p;

if (ds_obs_patol_lab_w IS NOT NULL AND ds_obs_patol_lab_w::text <> '') then
	ds_observacao_lote_w := ds_obs_patol_lab_w ||' '||ds_observacao_lote_w;
end if;

/*update	exame_lab_result_item
set		nr_seq_lote_patol = nr_seq_patol_w,
		ds_obs_lote_ent = ds_observacao_lote_w
where	nr_seq_resultado = nr_seq_resultado_p
and		nr_seq_exame = nr_seq_exame_p
and		nr_seq_prescr = nr_seq_prescr_p;*/
select 	count(*)
into STRICT	qt_registro_w
from	exame_lab_result_item_mas
where	nr_seq_prescr = nr_seq_prescr_p
and		nr_seq_resultado = nr_seq_resultado_p
and		nr_seq_result_item = nr_sequencia_p
and		nr_seq_lab_patol = nr_seq_patologia_p;

if (nr_seq_resultado_p IS NOT NULL AND nr_seq_resultado_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	if (coalesce(qt_registro_w,0) = 0) then

		select	nextval('exame_lab_result_item_mas_seq')
		into STRICT	nr_seq_massas_w
		;

		insert into exame_lab_result_item_mas(
			DS_ACAO_CRITERIO,
			DS_FRASE_PATOL,
			DS_MENSAGEM_CRITERIO,
			DS_MENSAGEM_PATOL,
			DS_PATOLOGIA,
			DT_ATUALIZACAO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO,
			NM_USUARIO_NREC,
			NR_SEQ_PRESCR,
			NR_SEQ_RESULTADO,
			NR_SEQ_RESULT_ITEM,
			NR_SEQUENCIA,
			nr_seq_lab_patol,
			qt_minima,
			qt_maxima,
			DS_OBSERVACAO_REF
		) values (
			ds_acao_criterio_p,
			ds_frase_patol_p,
			ds_mensagem_criterio_p,
			ds_mensagem_patol_p,
			ds_patologia_p,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_prescr_p,
			nr_seq_resultado_p,
			nr_sequencia_p,
			nr_seq_massas_w,
			nr_seq_patologia_p,
			qt_minima_patol_p,
			qt_maxima_patol_p,
			ds_obs_ref_p
		);

	end if;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_insere_dados_massas ( nr_seq_exame_p bigint, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, nr_seq_patologia_p bigint, ds_mensagem_patol_p text, ds_frase_patol_p text, ds_patologia_p text, ds_acao_criterio_p text, ds_mensagem_criterio_p text, nr_sequencia_p bigint, qt_minima_patol_p bigint, qt_maxima_patol_p bigint, ds_obs_ref_p text, nm_usuario_p text) FROM PUBLIC;

