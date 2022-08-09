-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lab_log_interf_imp ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, ds_resultado_p text, ds_mensagem_p text, ie_formato_p text, nm_usuario_p text, ie_erro_p text) AS $body$
DECLARE


cd_estabelecimento_w	smallint;
ie_gera_log_interf_w	varchar(1);


BEGIN

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select	coalesce(max(ie_gera_log_interf),'S')
into STRICT	ie_gera_log_interf_w
from	lab_parametro
where	cd_estabelecimento = cd_estabelecimento_w;

if (ie_gera_log_interf_w = 'S') then

	insert into lab_log_interf_imp(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_prescricao,
			nr_seq_prescr,
			nr_seq_exame,
			nr_seq_material,
			ds_resultado,
			ds_mensagem,
			ie_formato_resultado,
			ie_erro)
	values (
			nextval('lab_log_interf_imp_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_prescricao_p,
			nr_seq_prescr_p,
			nr_seq_exame_p,
			nr_seq_material_p,
			ds_resultado_p,
			ds_mensagem_p,
			ie_formato_p,
			ie_erro_p);

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lab_log_interf_imp ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, ds_resultado_p text, ds_mensagem_p text, ie_formato_p text, nm_usuario_p text, ie_erro_p text) FROM PUBLIC;
