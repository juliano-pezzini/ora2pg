-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION html_obter_datas_laudo_date (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_seq_laudo_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

dt_w		timestamp;

BEGIN

if (ie_opcao_p = 'DT_ENTREGOU') then

	select	max(dt_entrega)
	into STRICT	dt_w
	from	envelope_laudo a
	where	a.nr_sequencia	= Gel_obter_envelope_exame(nr_seq_prescricao_p,nr_prescricao_p,null,'E');

elsif (ie_opcao_p = 'DT_ENVELOPOU') then

	select	max(dt_atualizacao_nrec)
	into STRICT	dt_w
	from	envelope_laudo_item a
	where	a.nr_prescricao	= nr_prescricao_p
	and	a.nr_seq_prescr	= nr_seq_prescricao_p;

elsif (ie_opcao_p = 'DT_INICIO_DIGITACAO') then

	select	max(dt_inicio_digitacao)
	into STRICT	dt_w
	from	laudo_paciente
	where	nr_sequencia	= nr_seq_laudo_p;

elsif (ie_opcao_p = 'DT_SEG_APROVACAO') then

	select	max(dt_seg_aprovacao)
	into STRICT	dt_w
	from	laudo_paciente
	where	nr_sequencia	= nr_seq_laudo_p;
	
elsif (ie_opcao_p = 'DT_APROVACAO') then

	select	max(DT_APROVACAO)
	into STRICT	dt_w
	from	laudo_paciente
	where	nr_sequencia	= nr_seq_laudo_p;

end if;

return dt_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION html_obter_datas_laudo_date (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_seq_laudo_p bigint, ie_opcao_p text) FROM PUBLIC;

