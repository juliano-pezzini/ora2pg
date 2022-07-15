-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_diagnostico_procedimento (nr_atendimento_p bigint, cd_procedimento_p bigint, cd_medico_p bigint, dt_procedimento_p timestamp, nm_usuario_p text) AS $body$
DECLARE


cd_cid_principal_w 	varchar(25);
cd_cid_secundario_w	varchar(27);


BEGIN
	SELECT 	MAX(cd_doenca_cid),
		MAX(cd_cid_secundario)
	into STRICT	cd_cid_principal_w,
		cd_cid_secundario_w
	FROM 	procedimento
	WHERE 	cd_procedimento = cd_procedimento_p;

	if	((cd_cid_principal_w IS NOT NULL AND cd_cid_principal_w::text <> '') or (cd_cid_secundario_w IS NOT NULL AND cd_cid_secundario_w::text <> '')) then
	begin
		insert into diagnostico_medico(
		nr_atendimento,
		dt_diagnostico,
		ie_tipo_diagnostico,
		cd_medico,
		dt_atualizacao,
		nm_usuario,
		ds_diagnostico)
	Values (
		nr_atendimento_p,
		dt_procedimento_p,
		1,
		cd_medico_p,
		clock_timestamp(),
		nm_usuario_p,
		null);
	end;
	end if;

	if (cd_cid_principal_w IS NOT NULL AND cd_cid_principal_w::text <> '') then
	begin
	Insert into diagnostico_doenca(
		NR_ATENDIMENTO,
		DT_DIAGNOSTICO,
		CD_DOENCA,
		DT_ATUALIZACAO,
		NM_USUARIO,
		DS_DIAGNOSTICO,
		IE_CLASSIFICACAO_DOENCA,
		ie_tipo_diagnostico)
	Values (nr_atendimento_p,
		dt_procedimento_p,
		cd_cid_principal_w,
		clock_timestamp(),
		nm_usuario_p,
		'',
		1,
		1);
	end;
	end if;

	if (cd_cid_secundario_w IS NOT NULL AND cd_cid_secundario_w::text <> '') then
	begin
	Insert into diagnostico_doenca(
		NR_ATENDIMENTO,
		DT_DIAGNOSTICO,
		CD_DOENCA,
		DT_ATUALIZACAO,
		NM_USUARIO,
		DS_DIAGNOSTICO,
		IE_CLASSIFICACAO_DOENCA,
		ie_tipo_diagnostico)
	Values (nr_atendimento_p,
		dt_procedimento_p,
		cd_cid_secundario_w,
		clock_timestamp(),
		nm_usuario_p,
		'',
		1,
		1);
	end;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_diagnostico_procedimento (nr_atendimento_p bigint, cd_procedimento_p bigint, cd_medico_p bigint, dt_procedimento_p timestamp, nm_usuario_p text) FROM PUBLIC;

