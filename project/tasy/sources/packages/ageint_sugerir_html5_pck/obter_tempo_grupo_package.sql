-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ageint_sugerir_html5_pck.obter_tempo_grupo (nr_seq_grupo_pri_pp bigint, nr_seq_grupo_seg_pp bigint) RETURNS bigint AS $body$
DECLARE

	qt_retorno_w	bigint;
	
BEGIN
	select	coalesce(max(qt_tempo),0)
	into STRICT	qt_retorno_w
	from	ageint_tempo_entre_grupos
	where	ie_situacao	= 'A'
	and	((cd_grupo_pri	= nr_seq_grupo_pri_pp and cd_grupo_seg	= nr_seq_grupo_seg_pp)
	or (cd_grupo_pri	= nr_seq_grupo_seg_pp and cd_grupo_seg	= nr_seq_grupo_pri_pp))
	and	coalesce(ie_agend_distinto,'N') = 'S';
	
	return qt_retorno_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ageint_sugerir_html5_pck.obter_tempo_grupo (nr_seq_grupo_pri_pp bigint, nr_seq_grupo_seg_pp bigint) FROM PUBLIC;