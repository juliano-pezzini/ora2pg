-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_hist_alteracao_conv ( nm_usuario_p text, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_convenio_p text, ds_just_alteracao_p text, dt_inicio_vigencia_p timestamp, nr_seq_interno_p bigint) AS $body$
DECLARE


nr_sequencia_w  	bigint;


BEGIN


if (coalesce(nr_atendimento_p,0) > 0) and (coalesce(cd_convenio_p,0) > 0) and (cd_categoria_p IS NOT NULL AND cd_categoria_p::text <> '') and (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') then

	select	nextval('atend_categ_conv_hist_seq')
	into STRICT	nr_sequencia_w
	;

	insert	into atend_categ_conv_hist(  	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_atendimento,
						cd_convenio,
						cd_categoria,
						cd_plano_convenio,
						ds_just_alteracao,
						dt_inicio_vigencia,
						nr_seq_atecaco)

				values (	nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_atendimento_p,
						cd_convenio_p,
						substr(cd_categoria_p,1,10),
						substr(cd_plano_convenio_p,1,10),
						substr(ds_just_alteracao_p,1,255),
						dt_inicio_vigencia_p,
						nr_seq_interno_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_hist_alteracao_conv ( nm_usuario_p text, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_convenio_p text, ds_just_alteracao_p text, dt_inicio_vigencia_p timestamp, nr_seq_interno_p bigint) FROM PUBLIC;
