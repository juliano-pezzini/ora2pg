-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_prescr_hm (nr_prescricao_p bigint, nr_seq_procedimento_p bigint, cd_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_bolsa_bipada_w	bigint;
qt_bolsas_w		bigint;
ds_retorno_w		varchar(80);
qt_procedimento_w	bigint;
cd_intervalo_w		varchar(7);
ie_lado_w		varchar(15);
qt_eventos_bolsa_w bigint;
ie_usa_pda_w    varchar(1);
ie_usa_adep_w   varchar(1);
			

BEGIN

select	coalesce(qt_vol_hemocomp,0),
	cd_intervalo,
	CASE WHEN ie_lado='E' THEN 'Esq' WHEN ie_lado='D' THEN 'Dir' WHEN ie_lado='A' THEN obter_desc_expressao(308326)/*'Ambos'*/  ELSE null END
into STRICT	qt_procedimento_w,
	cd_intervalo_w,
	ie_lado_w
from	prescr_procedimento
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia	= nr_seq_procedimento_p;

select	count(1)
into STRICT	qt_bolsa_bipada_w
from	prescr_procedimento a,
		prescr_proc_bolsa b,
		prescr_proc_hor c
where	a.nr_prescricao       = b.nr_prescricao
and		b.nr_seq_procedimento = a.nr_sequencia
and 	b.nr_seq_horario 	  = c.nr_sequencia
and		a.nr_prescricao       = c.nr_prescricao
and		a.nr_sequencia        = c.nr_seq_procedimento
and		coalesce(a.nr_seq_proc_interno,0) = coalesce(c.nr_seq_proc_interno,0)
and		coalesce(b.ie_bipado,'N')  = 'S'
and		coalesce(b.dt_cancelamento::text, '') = ''
and		a.nr_prescricao	      = nr_prescricao_p
and		a.cd_procedimento     = cd_procedimento_p;

select	count(1)
into STRICT	qt_bolsas_w
from	prescr_procedimento a,
		prescr_proc_bolsa b,
		prescr_proc_hor c
where	a.nr_prescricao       = b.nr_prescricao
and		b.nr_seq_procedimento = a.nr_sequencia
and 	b.nr_seq_horario 	  = c.nr_sequencia
and		a.nr_prescricao       = c.nr_prescricao
and		a.nr_sequencia        = c.nr_seq_procedimento
and		coalesce(a.nr_seq_proc_interno,0) = coalesce(c.nr_seq_proc_interno,0)
and		coalesce(b.dt_cancelamento::text, '') = ''
and		a.nr_prescricao	      = nr_prescricao_p
and		a.cd_procedimento     = cd_procedimento_p;

select  coalesce(max('S'), 'N')
into STRICT    ie_usa_pda_w
from    prescr_solucao_evento a
where   a.nr_prescricao = nr_prescricao_p
and     a.nr_seq_procedimento = nr_seq_procedimento_p
and     a.cd_funcao = 88;

select  coalesce(max('S'), 'N')
into STRICT    ie_usa_adep_w
from    prescr_solucao_evento a
where   a.nr_prescricao = nr_prescricao_p
and     a.nr_seq_procedimento = nr_seq_procedimento_p
and     a.ie_alteracao in (1, 2, 3, 4, 35)
and     a.cd_funcao = 1113;

if (ie_usa_pda_w = 'S' and ie_usa_adep_w = 'S') then
    select  count(1)
    into STRICT    qt_eventos_bolsa_w
    from    prescr_solucao_evento a
    where   a.nr_prescricao = nr_prescricao_p
    and     a.nr_seq_procedimento = nr_seq_procedimento_p
    and     a.ie_tipo_solucao = 3
    and     ((a.cd_funcao = 1113 and
                ((a.ie_alteracao = 2 and
                    coalesce(obter_se_motivo_troca_frasco(nr_seq_motivo),'N') = 'S') or (a.ie_alteracao = 4))) or (a.cd_funcao = 88 and
                a.ie_alteracao = 4))
    and     coalesce(a.ie_evento_valido,'S') = 'S';

    qt_bolsa_bipada_w := qt_eventos_bolsa_w;
end if;

ds_retorno_w := wheb_mensagem_pck.get_texto(92693) || ': ' || qt_bolsa_bipada_w || '/' || qt_bolsas_w;

if (qt_procedimento_w IS NOT NULL AND qt_procedimento_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || '  ' || obter_desc_expressao(302287)|| ': ' || qt_procedimento_w || ' ' || wheb_mensagem_pck.get_texto(750517);
end if;
if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || '  ' || substr(obter_desc_intervalo_prescr(cd_intervalo_w),1,40);
end if;
if (ie_lado_w IS NOT NULL AND ie_lado_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || '  ' || ie_lado_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_prescr_hm (nr_prescricao_p bigint, nr_seq_procedimento_p bigint, cd_procedimento_p bigint) FROM PUBLIC;

