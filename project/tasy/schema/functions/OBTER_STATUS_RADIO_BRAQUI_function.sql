-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_radio_braqui (nr_seq_aplic_trat_p rxt_braq_campo_aplic_trat.nr_seq_aplic_trat%type) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w rxt_tumor.nr_sequencia%type;
ds_retorno_w    varchar(20);


BEGIN

if (nr_seq_aplic_trat_p IS NOT NULL AND nr_seq_aplic_trat_p::text <> '') then
	select	max(d.nr_sequencia)
	into STRICT    nr_sequencia_w
	from    RXT_BRAQ_APLIC_TRAT b,
            RXT_TRATAMENTO c,
            rxt_tumor d
	where	nr_seq_aplic_trat_p = b.nr_sequencia
	and     b.nr_seq_tratamento = c.nr_sequencia
	and     c.nr_seq_tumor      = d.nr_sequencia;

ds_retorno_w := get_treatment_status(nr_sequencia_w);

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_radio_braqui (nr_seq_aplic_trat_p rxt_braq_campo_aplic_trat.nr_seq_aplic_trat%type) FROM PUBLIC;

