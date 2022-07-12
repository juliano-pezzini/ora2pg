-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_colet_prescr_sup ( nr_seq_proc_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_retorno_w		integer;
ds_retorno_w		varchar(100);
nr_seq_proc_princ_w	bigint;
nr_prescricao_w			bigint;
nr_sequencia_prescricao_w	integer;



BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')then

	select	max(cd_setor_coleta)
	into STRICT	cd_retorno_w
	from	prescr_procedimento
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia	= nr_sequencia_p;

else
	select	nr_seq_proc_princ
	into STRICT	nr_seq_proc_princ_w
	from	procedimento_paciente
	where	nr_sequencia = nr_seq_proc_p;

	if (nr_seq_proc_princ_w IS NOT NULL AND nr_seq_proc_princ_w::text <> '') then

		select	nr_prescricao,
			nr_sequencia_prescricao
		into STRICT	nr_prescricao_w,
			nr_sequencia_prescricao_w
		from	procedimento_paciente
		where	nr_sequencia = nr_seq_proc_princ_w;

		select	max(cd_setor_coleta)
		into STRICT	cd_retorno_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescricao_w
		and	nr_sequencia	= nr_sequencia_prescricao_w;

	end if;

end if;

return	cd_retorno_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_colet_prescr_sup ( nr_seq_proc_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

