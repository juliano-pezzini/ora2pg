-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sequencia_servico ( ie_tipo_presc_p bigint, dt_servico_p timestamp, cd_setor_atend_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select 	coalesce(max(a.nr_sequencia),0)
into STRICT	nr_sequencia_w
from	nut_servico a
where	not exists (	SELECT	1
					from	regra_geracao_serv_setor b
					where	b.nr_seq_servico = a.nr_sequencia
					and		coalesce(b.ie_gera_servico,'N') = 'N'
					and		b.cd_setor_atendimento = cd_setor_atend_p )
and		a.ie_tipo_prescricao_servico = ie_tipo_presc_p
and		coalesce(a.ie_situacao,'A') = 'A';

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sequencia_servico ( ie_tipo_presc_p bigint, dt_servico_p timestamp, cd_setor_atend_p bigint) FROM PUBLIC;
