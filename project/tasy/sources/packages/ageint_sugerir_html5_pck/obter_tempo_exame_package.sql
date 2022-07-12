-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ageint_sugerir_html5_pck.obter_tempo_exame (nr_seq_proc_pri_pp bigint, nr_seq_proc_seg_pp bigint, cd_estab_pri_pp bigint, cd_estab_seg_pp bigint, hr_agenda_seg_pp timestamp, dt_referencia_p timestamp, cd_estab_pri_p bigint) RETURNS bigint AS $body$
DECLARE

	qt_retorno_w	bigint;
	
	
BEGIN
	if hr_agenda_seg_pp >= dt_referencia_p then	
		select	coalesce(max(qt_tempo),0)
		into STRICT	qt_retorno_w
		from	ageint_tempo_entre_exames
		where	ie_situacao	= 'A'
		and	((coalesce(cd_estabelecimento::text, '') = '')
		or (cd_estabelecimento = cd_estab_pri_pp
		and	cd_estab_pri_p = cd_estab_seg_pp))
		and	coalesce(ie_agend_distinto,'N') = 'S'
		and	((cd_exame_pri	= nr_seq_proc_pri_pp and cd_exame_seg	= nr_seq_proc_seg_pp)
		or (coalesce(IE_REGRA_EXCLUSIVA, 'N') = 'N' and cd_exame_pri	= nr_seq_proc_seg_pp and cd_exame_seg	= nr_seq_proc_pri_pp));
	else
		select	coalesce(max(qt_tempo),0)
		into STRICT	qt_retorno_w
		from	ageint_tempo_entre_exames
		where	ie_situacao	= 'A'
		and	((coalesce(cd_estabelecimento::text, '') = '')
		or (cd_estabelecimento = cd_estab_pri_pp
		and	cd_estab_pri_p = cd_estab_seg_pp))
		and	coalesce(ie_agend_distinto,'N') = 'S'
		and	((cd_exame_pri	= nr_seq_proc_seg_pp and cd_exame_seg	= nr_seq_proc_pri_pp)
		or (coalesce(IE_REGRA_EXCLUSIVA, 'N') = 'N' and cd_exame_pri	= nr_seq_proc_pri_pp and cd_exame_seg	= nr_seq_proc_seg_pp));
	end if;
	
	return qt_retorno_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ageint_sugerir_html5_pck.obter_tempo_exame (nr_seq_proc_pri_pp bigint, nr_seq_proc_seg_pp bigint, cd_estab_pri_pp bigint, cd_estab_seg_pp bigint, hr_agenda_seg_pp timestamp, dt_referencia_p timestamp, cd_estab_pri_p bigint) FROM PUBLIC;
