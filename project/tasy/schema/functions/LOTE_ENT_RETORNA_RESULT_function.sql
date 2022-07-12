-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lote_ent_retorna_result (nr_seq_ficha_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_seq_prescr_w		bigint;
nr_prescricao_w		bigint;
ie_tipo_valor_w		varchar(10);
nr_atendimento_w	bigint;


BEGIN

select 	max(nr_prescricao)
into STRICT	nr_prescricao_w
from	lote_ent_sec_ficha
where	nr_sequencia = nr_seq_ficha_p;

/*select	max(a.nr_atendimento)
into	nr_atendimento_w
from	atendimento_paciente a
where	a.nr_seq_ficha_lote_ant = nr_seq_ficha_p;

select	max(a.nr_prescricao)
into	nr_prescricao_w
from	prescr_medica a
where	a.nr_atendimento = nr_atendimento_w;*/
select	max(a.nr_sequencia)
into STRICT	nr_seq_prescr_w
from	prescr_procedimento a,
		lote_ent_sec_ficha b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_w
and		a.nr_seq_exame = nr_seq_exame_p;

if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') and (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') then

	SELECT	max(SUBSTR(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(converter_numero_string(c.qt_resultado),TO_CHAR(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,100)),
			max(d.IE_FORMATO_RESULTADO)
	into STRICT	ds_retorno_w,
			ie_tipo_valor_w
	FROM	exame_laboratorio d,
			exame_lab_result_item c,
			exame_lab_resultado b
	WHERE	b.nr_seq_resultado	= c.nr_seq_resultado
	AND d.nr_seq_exame = c.nr_seq_exame
                AND c.nr_seq_exame    = nr_seq_exame_p
	AND b.nr_prescricao   = nr_prescricao_w
	AND c.nr_seq_prescr  = nr_seq_prescr_w;

end if;

if (ie_tipo_valor_w in ('DV','CV','P','V','VP') and obter_se_somente_numero(ds_retorno_w) = 'S') then
	ds_retorno_w := to_char( ''||ds_retorno_w||'','fm9,990.00');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lote_ent_retorna_result (nr_seq_ficha_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;
