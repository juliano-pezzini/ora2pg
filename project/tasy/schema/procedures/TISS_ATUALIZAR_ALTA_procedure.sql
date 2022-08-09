-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_atualizar_alta (nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_motivo_alta_p bigint, dt_alta_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_saida_consulta_w	bigint	:= null;
nr_seq_saida_int_w		bigint	:= null;
nr_seq_saida_spsadt_w	bigint	:= null;
nr_interno_conta_w		bigint	:= null;
cd_convenio_w		integer;
cd_estabelecimento_w	smallint;
ie_tipo_atend_w		smallint;
dt_inicio_vigencia_w	timestamp;
ie_atualizar_alta_w		varchar(5);
ie_versao_tiss_w		varchar(255);
nr_seq_saida_int_parc_w		bigint;
nr_seq_saida_consulta_parc_w	bigint;
nr_seq_saida_spsadt_parc_w		bigint;
dt_mesano_referencia_w		timestamp;
c01 CURSOR FOR
SELECT	nr_seq_saida_consulta,
	nr_seq_saida_int,
	nr_seq_saida_spsadt,
	dt_inicio_vigencia
from	tiss_motivo_alta
where	cd_motivo_alta					= cd_motivo_alta_p
and	coalesce(dt_inicio_vigencia, to_date('01/01/1900','dd/mm/yyyy'))	<= dt_alta_p
and	coalesce(ie_tipo_atendimento, ie_tipo_atend_w)		= ie_tipo_atend_w
and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))		= coalesce(cd_convenio_w,0)
and 	coalesce(ie_versao_tiss_w::text, '') = ''

union

SELECT	nr_seq_saida_consulta,
	CASE WHEN coalesce(tiss_obter_versao_tipo_saida(nr_seq_saida_int), 'X')='X' THEN  (null)::numeric   ELSE nr_seq_saida_int END  nr_seq_saida_int,
	nr_seq_saida_spsadt,
	dt_inicio_vigencia
from	tiss_motivo_alta
where	cd_motivo_alta					= cd_motivo_alta_p
and	coalesce(dt_inicio_vigencia, to_date('01/01/1900','dd/mm/yyyy'))	<= dt_alta_p
and	coalesce(ie_tipo_atendimento, ie_tipo_atend_w)		= ie_tipo_atend_w
and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))		= coalesce(cd_convenio_w,0)
and	(ie_versao_tiss_w IS NOT NULL AND ie_versao_tiss_w::text <> '')
and	((ie_versao_tiss_w = tiss_obter_versao_tipo_saida(nr_seq_saida_int)) or (coalesce(nr_seq_saida_int::text, '') = ''))
order by	dt_inicio_vigencia;

c02 CURSOR FOR
SELECT	cd_convenio_parametro,
	cd_estabelecimento,
	obter_tipo_atendimento(nr_atendimento),
	nr_interno_conta,
	dt_mesano_referencia
from	conta_paciente
where	nr_interno_conta		= nr_interno_conta_p

union

SELECT	cd_convenio_parametro,
	cd_estabelecimento,
	obter_tipo_atendimento(nr_atendimento),
	nr_interno_conta,
	dt_mesano_referencia
from	conta_paciente
where	nr_atendimento		= nr_atendimento_p
and	coalesce(nr_interno_conta_p::text, '') = '';


BEGIN

open c02;
loop
fetch c02 into
	cd_convenio_w,
	cd_estabelecimento_w,
	ie_tipo_atend_w,
	nr_interno_conta_w,
	dt_mesano_referencia_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	select	max(ie_atualizar_alta),
		max(nr_seq_saida_int),
		max(nr_seq_saida_spsadt),
		max(nr_seq_saida_consulta)
	into STRICT	ie_atualizar_alta_w,
		nr_seq_saida_int_parc_w,
		nr_seq_saida_spsadt_parc_w,
		nr_seq_saida_consulta_parc_w
	from	tiss_parametros_convenio
	where	cd_convenio		= cd_convenio_w
	and	cd_estabelecimento		= cd_estabelecimento_w;
	
	ie_versao_tiss_w := coalesce(tiss_obter_versao(cd_convenio_w, cd_estabelecimento_w,dt_mesano_referencia_w),0);
	
	open c01;
	loop
	fetch c01 into
		nr_seq_saida_consulta_w,
		nr_seq_saida_int_w,
		nr_seq_saida_spsadt_w,
		dt_inicio_vigencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
	
	if (ie_atualizar_alta_w	= 'N') then
		update	conta_paciente
		set	nr_seq_saida_consulta	= coalesce(nr_seq_saida_consulta, nr_seq_saida_consulta_w),
			nr_seq_saida_int		= coalesce(nr_seq_saida_int, nr_seq_saida_int_w),	
			nr_seq_saida_spsadt	= coalesce(nr_seq_saida_spsadt, nr_seq_saida_spsadt_w)
		where	nr_interno_conta		= nr_interno_conta_w;
	else
		update	conta_paciente
		set	nr_seq_saida_consulta	= CASE WHEN ie_tipo_fatur_tiss='P' THEN  coalesce(nr_seq_saida_consulta_w, nr_seq_saida_consulta)  ELSE coalesce(nr_seq_saida_consulta_w, nr_seq_saida_consulta) END ,
			nr_seq_saida_int		= CASE WHEN ie_tipo_fatur_tiss='P' THEN  coalesce(nr_seq_saida_int_parc_w, nr_seq_saida_int)  ELSE coalesce(nr_seq_saida_int_w, nr_seq_saida_int) END ,						
			nr_seq_saida_spsadt	= CASE WHEN ie_tipo_fatur_tiss='P' THEN  coalesce(nr_seq_saida_spsadt_parc_w, nr_seq_saida_spsadt)  ELSE coalesce(nr_seq_saida_spsadt_w, nr_seq_saida_spsadt) END
		where	nr_interno_conta		= nr_interno_conta_w;
	end if;

end loop;
close c02;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_atualizar_alta (nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_motivo_alta_p bigint, dt_alta_p timestamp, nm_usuario_p text) FROM PUBLIC;
