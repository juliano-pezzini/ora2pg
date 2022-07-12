-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_preco_sem_glosa (nr_sequencia_p bigint, ie_opcao_p text, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


vl_material_w		double precision 	:= 0;
dt_ult_vigencia_w	timestamp;
cd_tab_preco_mat_w	bigint;
ie_origem_preco_w	varchar(05);
vl_retorno_w		double precision;


BEGIN

if (ie_opcao_p = 'M') then
	select	sum(vl_material)
	into STRICT	vl_retorno_w
	from (SELECT	vl_material
		from	material_atend_paciente
		where	nr_sequencia = nr_sequencia_p
		and	nr_atendimento = nr_atendimento_p
		
union all

		SELECT 	vl_material
		from 	material_atend_paciente
		where 	nr_seq_mat_glosa = nr_sequencia_p
		and 	cd_situacao_glosa = 0
		and 	ie_glosado = 'S'
		and	coalesce(cd_motivo_exc_conta::text, '') = ''
		and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
		and	nr_atendimento = nr_atendimento_p  LIMIT 1) alias4;
end if;


if (ie_opcao_p = 'P') then
	select	sum(vl_procedimento)
	into STRICT	vl_retorno_w
	from (SELECT	vl_procedimento
		from	procedimento_paciente
		where	nr_sequencia = nr_sequencia_p
		and 	cd_situacao_glosa > 0
		and	nr_atendimento = nr_atendimento_p
		
union all

		SELECT 	vl_procedimento
		from 	procedimento_paciente
		where 	nr_seq_proc_princ = nr_sequencia_p
		and 	coalesce(cd_motivo_exc_conta::text, '') = ''
		and 	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
		and 	cd_situacao_glosa = 0
		and	nr_atendimento = nr_atendimento_p  LIMIT 1) alias4;
end if;

Return vl_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_preco_sem_glosa (nr_sequencia_p bigint, ie_opcao_p text, nr_atendimento_p bigint) FROM PUBLIC;
