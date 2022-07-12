-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_compartilhamento_risco_pck.verificar_se_benef_repassado (nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_referencia_p pls_lote_compart_risco.dt_referencia%type) RETURNS varchar AS $body$
DECLARE


qt_repasse_benef_w		bigint;


BEGIN

select  count(1)
into STRICT	qt_repasse_benef_w
from    pls_segurado_repasse
where   nr_seq_segurado = nr_seq_segurado_p
and     (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and     dt_referencia_p between dt_repasse and fim_dia(coalesce(dt_fim_repasse, dt_referencia_p))
and (coalesce(ie_tipo_compartilhamento::text, '') = '' or ie_tipo_compartilhamento = 1);

if (qt_repasse_benef_w > 0) then
	return 'S';
else
	return 'N';
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_compartilhamento_risco_pck.verificar_se_benef_repassado (nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_referencia_p pls_lote_compart_risco.dt_referencia%type) FROM PUBLIC;
