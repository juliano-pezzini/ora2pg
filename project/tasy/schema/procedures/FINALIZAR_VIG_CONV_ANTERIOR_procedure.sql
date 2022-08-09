-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finalizar_vig_conv_anterior ( nr_atendimento_p bigint, dt_inicio_vigencia_p timestamp, nr_seq_interno_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_vig_atual_w		bigint;


BEGIN

if (coalesce(nr_atendimento_p,0) > 0) and (coalesce(nr_seq_interno_p,0) > 0) then

	select	count(*)
	into STRICT	qt_vig_atual_w
	from	atend_categoria_convenio
	where	nr_atendimento = nr_atendimento_p
	and	nr_seq_interno <> nr_seq_interno_p
	and	coalesce(dt_final_vigencia::text, '') = '';

	if (coalesce(qt_vig_atual_w,0) > 0) then

		update	atend_categoria_convenio
		set	dt_final_vigencia = coalesce(dt_inicio_vigencia_p,clock_timestamp()) - 1/84600,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_atendimento = nr_atendimento_p
		and	nr_seq_interno <> nr_seq_interno_p
		and	coalesce(dt_final_vigencia::text, '') = '';

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finalizar_vig_conv_anterior ( nr_atendimento_p bigint, dt_inicio_vigencia_p timestamp, nr_seq_interno_p bigint, nm_usuario_p text) FROM PUBLIC;
