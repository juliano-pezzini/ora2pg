-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_evento_troca_frasco ( nr_seq_evento_p bigint, nr_prescricao_p bigint default null, nr_seq_procedimento_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_troca_frasco_w	varchar(1) := 'N';


BEGIN

if (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') then

	select	obter_se_motivo_troca_frasco(nr_seq_motivo)
	into STRICT	ie_troca_frasco_w
	from	prescr_solucao_evento
	where	nr_sequencia = nr_seq_evento_p;

elsif (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') then

	select	obter_se_motivo_troca_frasco(nr_seq_motivo)
	into STRICT	ie_troca_frasco_w
	from	prescr_solucao_evento
	where	nr_sequencia = ( SELECT max( nr_sequencia )
							 from	prescr_solucao_evento
							 where	nr_prescricao 			= nr_prescricao_p
							 and	nr_seq_procedimento 	= nr_seq_procedimento_p );

end if;

return ie_troca_frasco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_evento_troca_frasco ( nr_seq_evento_p bigint, nr_prescricao_p bigint default null, nr_seq_procedimento_p bigint default null) FROM PUBLIC;
