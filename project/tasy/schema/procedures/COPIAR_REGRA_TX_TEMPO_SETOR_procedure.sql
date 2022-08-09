-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_regra_tx_tempo_setor ( cd_convenio_orig_p bigint, cd_convenio_dest_p text, ie_tipo_valor_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_convenio_w	integer;

C01 CURSOR FOR
	SELECT	coalesce(cd_convenio,0)
	from	convenio
	where	(((ie_tipo_valor_p = '1') and (obter_se_contido(cd_convenio, substr(elimina_aspas(cd_convenio_dest_p),1,200)) = 'S')) or
		((ie_tipo_valor_p = '2') and (not obter_se_contido(cd_convenio, substr(elimina_aspas(cd_convenio_dest_p),1,200)) = 'S')))
	order by cd_convenio;


BEGIN

open C01;
loop
fetch C01 into
	cd_convenio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (cd_convenio_w > 0) and
		((ie_tipo_valor_p = '1') or (ie_tipo_valor_p = '2' AND cd_convenio_w <> cd_convenio_orig_p)) then

		insert into conv_regra_tx_tempo_setor(
			nr_sequencia,
			cd_convenio,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_proc_interno,
			cd_setor_atendimento,
			cd_procedimento,
			ie_origem_proced,
			qt_tolerancia,
			ie_situacao,
			qt_min_cobranca,
			dt_inicio_vigencia,
			dt_final_vigencia,
			cd_estabelecimento,
			ie_limite,
			cd_unidade_basica,--askono
			cd_unidade_compl)
		SELECT	nextval('conv_regra_tx_tempo_setor_seq'),
			cd_convenio_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_proc_interno,
			cd_setor_atendimento,
			cd_procedimento,
			ie_origem_proced,
			qt_tolerancia,
			ie_situacao,
			qt_min_cobranca,
			dt_inicio_vigencia,
			dt_final_vigencia,
			cd_estabelecimento,
			ie_limite,
			cd_unidade_basica, --askono
			cd_unidade_compl
		from	conv_regra_tx_tempo_setor
		where	nr_sequencia = nr_sequencia_p;

	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_regra_tx_tempo_setor ( cd_convenio_orig_p bigint, cd_convenio_dest_p text, ie_tipo_valor_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
