-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_qt_mat_entregue (nr_seq_entrega_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_ignorar_datas_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	bigint;



BEGIN

SELECT	coalesce(SUM(c.qt_material),0) qt_medic
INTO STRICT	qt_retorno_w
FROM	hd_entrega_medic b,
		hd_lote_paciente c
WHERE	b.nr_sequencia = nr_seq_entrega_p
AND		c.nr_seq_entrega = b.nr_sequencia
AND		c.cd_pessoa_fisica = cd_pessoa_fisica_p
AND		((ie_ignorar_datas_p = 'S')
		OR ((b.dt_entrega BETWEEN dt_inicial_p AND fim_dia(dt_final_p))
		AND (ie_ignorar_datas_p = 'N')))
AND		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
AND 	((b.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0))
and coalesce(ie_controlado_hosp, 'S') = 'S'
ORDER BY 1;

RETURN	qt_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_qt_mat_entregue (nr_seq_entrega_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_ignorar_datas_p text, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

