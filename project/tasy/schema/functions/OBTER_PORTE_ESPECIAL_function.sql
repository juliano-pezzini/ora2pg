-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_porte_especial ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, dt_procedimento_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w	bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	tipo_taxa_cirurgica a,
		tipo_taxa_proced b
	where	a.nr_sequencia		= b.nr_seq_tipo_taxa
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.cd_convenio		= cd_convenio_p
	and	b.cd_procedimento	= cd_procedimento_p
	and	b.ie_origem_proced	= ie_origem_proced_p
	and	((coalesce(a.cd_setor_atendimento::text, '') = '') or (coalesce(cd_setor_atendimento_p::text, '') = '') or (a.cd_setor_atendimento = cd_setor_atendimento_p))
	and	((coalesce(b.cd_setor_atendimento::text, '') = '') or (coalesce(cd_setor_atendimento_p::text, '') = '') or (b.cd_setor_atendimento = cd_setor_atendimento_p))
	and	a.dt_vigencia		<= dt_procedimento_p
	and	a.ie_situacao		= 'A'
	order by coalesce(b.cd_setor_atendimento,0), 
		a.dt_vigencia,
		 qt_porte;


BEGIN


OPEN C01;
LOOP
FETCH C01 into nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	nr_sequencia_w	:= nr_sequencia_w;
END LOOP;
CLOSE C01;

return	nr_sequencia_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_porte_especial ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, dt_procedimento_p timestamp) FROM PUBLIC;

