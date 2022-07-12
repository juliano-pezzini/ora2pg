-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_regra_ger_atend ( nr_seq_mprev_atendimento_p mprev_atendimento.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


nr_seq_regra_w				bigint;			
ie_individual_coletivo_w	mprev_atendimento.ie_individual_coletivo%type;
ie_forma_atendimento_w		mprev_atendimento.ie_forma_atendimento%type;
ie_tipo_segurado_w			pls_segurado.ie_tipo_segurado%type;
			
C01 CURSOR FOR
	SELECT	nr_sequencia
	from	mprev_regra_ger_atend
	where (ie_tipo_atendimento_mprev = ie_individual_coletivo_w or coalesce(ie_tipo_atendimento_mprev::text, '') = '')
	and (ie_forma_atendimento_mprev = ie_forma_atendimento_w or coalesce(ie_forma_atendimento_mprev::text, '') = '')
	and (ie_tipo_segurado = ie_tipo_segurado_w or coalesce(ie_tipo_segurado::text, '') = '')
	and (coalesce(dt_inicio_vigencia::text, '') = '' or dt_inicio_vigencia <= clock_timestamp())
	and (coalesce(dt_fim_vigencia::text, '') = '' or dt_fim_vigencia >= clock_timestamp())
	and (coalesce(cd_setor_regra::text, '') = '' or
	          cd_setor_regra = wheb_usuario_pck.get_cd_setor_atendimento())
	and 	coalesce(cd_estabelecimento,wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento		
	order by ie_tipo_atendimento_mprev desc, ie_forma_atendimento_mprev desc;
			

BEGIN

select	ie_individual_coletivo,
		ie_forma_atendimento
into STRICT	ie_individual_coletivo_w,
		ie_forma_atendimento_w
from	mprev_atendimento
where	nr_sequencia = nr_seq_mprev_atendimento_p;

ie_tipo_segurado_w := pls_obter_tipo_segurado(nr_seq_segurado_p);

open C01;
loop
fetch C01 into	
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	null;
	end;
end loop;
close C01;

return	nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_regra_ger_atend ( nr_seq_mprev_atendimento_p mprev_atendimento.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type) FROM PUBLIC;

