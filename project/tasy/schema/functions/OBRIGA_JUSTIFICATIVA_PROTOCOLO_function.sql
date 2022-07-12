-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obriga_justificativa_protocolo ( nr_prescricao_p bigint, cd_protocolo_p bigint, nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';
nr_prescricao_anterior_w	bigint;


BEGIN

select 	max(nr_prescricao_anterior)
into STRICT	nr_prescricao_anterior_w
from	prescr_medica
where 	nr_prescricao = nr_prescricao_p;

if (coalesce(nr_prescricao_p,0) > 0) and (coalesce(nr_prescricao_anterior_w::text, '') = '') and (cd_protocolo_p IS NOT NULL AND cd_protocolo_p::text <> '') and (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then

		select  coalesce(max(ie_obriga_justificativa), 'N')
		into STRICT	ds_retorno_w
		from    protocolo_medicacao
		where   cd_protocolo = cd_protocolo_p
		and     nr_sequencia = nr_seq_protocolo_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obriga_justificativa_protocolo ( nr_prescricao_p bigint, cd_protocolo_p bigint, nr_seq_protocolo_p bigint) FROM PUBLIC;

