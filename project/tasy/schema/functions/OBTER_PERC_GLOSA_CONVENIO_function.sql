-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_perc_glosa_convenio ( cd_convenio_p bigint, ie_tipo_atendimento_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


pr_glosa_w			double precision;
cd_estabelecimento_w		smallint;

C01 CURSOR FOR
	SELECT pr_real_glosa
	from	convenio_regra_glosa
	where	coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days')		> clock_timestamp()
	and	coalesce(cd_convenio,cd_convenio_p) 			= cd_convenio_p
	  and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_p) = ie_tipo_atendimento_p
	  and	dt_inicio_vigencia					<= dt_referencia_p
	  and ((coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)) or (coalesce(cd_estabelecimento_w,0) = 0))
	order by
		dt_inicio_vigencia,
		coalesce(cd_convenio,0),
		coalesce(ie_tipo_atendimento,0);


BEGIN

select	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estabelecimento_w
;

OPEN C01;
LOOP
FETCH C01 into	pr_glosa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	pr_glosa_w	:= pr_glosa_w;
END LOOP;
CLOSE C01;

RETURN coalesce(pr_glosa_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_perc_glosa_convenio ( cd_convenio_p bigint, ie_tipo_atendimento_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
