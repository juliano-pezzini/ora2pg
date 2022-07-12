-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_motivo_isol_cih (nr_atendimento_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_motivo_w				bigint;
ds_motivo_w					varchar(100);
nr_seq_motivo_atend_w		bigint;
nr_seq_motivo_isol_w		bigint;
dt_inicio_isolamento_w		timestamp;


BEGIN
select	coalesce(max(a.nr_Sequencia),0)
into STRICT	nr_seq_motivo_atend_w
from	motivo_isolamento_atend a,
		MOTIVO_ISOLAMENTO b
where	a.nr_atendimento = nr_atendimento_p
and		a.NR_SEQ_MOTIVO_ISOL = b.nr_sequencia
and		b.IE_GERAR_ALERTA = 'S';

if (nr_seq_motivo_atend_w > 0) then
	select  max(nr_seq_motivo_isol),
			max(dt_inicio_isolamento)
	into STRICT	nr_seq_motivo_isol_w,
		dt_inicio_isolamento_w
	from	motivo_isolamento_atend
	where	nr_sequencia = nr_seq_motivo_atend_w;

	select  max(ds_motivo)
	into STRICT	ds_motivo_w
	from	motivo_isolamento
	where	nr_sequencia = nr_seq_motivo_isol_w;
else
	select	max(b.ds_motivo)
	into STRICT	ds_motivo_w
	from	atendimento_precaucao a,
			motivo_isolamento b
	where	a.NR_SEQ_MOTIVO_ISOL = b.nr_sequencia
	and		a.nr_atendimento = nr_atendimento_p
	and		b.IE_GERAR_ALERTA = 'S'
	and		exists (SELECT	1
					from	cih_precaucao c
					where	a.nr_seq_precaucao = c.nr_sequencia
					and		c.ie_isolamento = 'S');
end if;

return	ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_motivo_isol_cih (nr_atendimento_p text) FROM PUBLIC;
