-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_atrib_estrut_proc ( nr_sequencia_p bigint, ie_proc_mat_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

if (ie_proc_mat_p = 'P') then

	select 	max(nr_sequencia) + 1
	into STRICT	nr_sequencia_w
	from 	conta_estrut_proc;

	insert into conta_estrut_proc(NR_SEQUENCIA,
			CD_ESTRUTURA,
			DT_ATUALIZACAO,
			NM_USUARIO,
			CD_AREA_PROCED,
			CD_ESPECIAL_PROCED,
			CD_GRUPO_PROCED,
			CD_PROCEDIMENTO,
			IE_ORIGEM_PROCED,
			CD_CONVENIO,
			IE_CREDENCIADO,
			IE_HONORARIO,
			CD_SETOR_ATENDIMENTO,
			IE_TIPO_ATENDIMENTO,
			CD_ESPECIALIDADE,
			CD_MEDICO,
			CD_EDICAO_AMB,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			IE_RESPONSAVEL_CREDITO,
			IE_TIPO_CONVENIO,
			NR_SEQ_GRUPO,
			NR_SEQ_SUBGRUPO,
			NR_SEQ_FORMA_ORG,
			NR_SEQ_CATEGORIA,
			cd_estabelecimento,
			nr_seq_grupo_lab,
			cd_tipo_procedimento)
		SELECT 	nr_sequencia_w,
			CD_ESTRUTURA,
			clock_timestamp(),
			NM_USUARIO_p,
			CD_AREA_PROCED,
			CD_ESPECIAL_PROCED,
			CD_GRUPO_PROCED,
			CD_PROCEDIMENTO,
			IE_ORIGEM_PROCED,
			CD_CONVENIO,
			IE_CREDENCIADO,
			IE_HONORARIO,
			CD_SETOR_ATENDIMENTO,
			IE_TIPO_ATENDIMENTO,
			CD_ESPECIALIDADE,
			CD_MEDICO,
			CD_EDICAO_AMB,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			IE_RESPONSAVEL_CREDITO,
			IE_TIPO_CONVENIO,
			NR_SEQ_GRUPO,
			NR_SEQ_SUBGRUPO,
			NR_SEQ_FORMA_ORG,
			NR_SEQ_CATEGORIA,
			cd_estabelecimento,
			nr_seq_grupo_lab,
			cd_tipo_procedimento
		from 	conta_estrut_proc
		where	nr_sequencia = nr_sequencia_p;

else

	select 	max(nr_sequencia) + 1
	into STRICT	nr_sequencia_w
	from 	conta_estrut_mat;

	insert into  conta_estrut_mat(NR_SEQUENCIA,
			CD_ESTRUTURA,
			DT_ATUALIZACAO,
			NM_USUARIO,
			CD_GRUPO_MATERIAL,
			CD_SUBGRUPO_MATERIAL,
			CD_CLASSE_MATERIAL,
			CD_MATERIAL,
			CD_CONVENIO,
			CD_SETOR_ATENDIMENTO,
			IE_TIPO_ATENDIMENTO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			IE_TIPO_CONVENIO,
			IE_RESPONSAVEL_CREDITO,
			cd_estabelecimento,
			ie_tipo_material)
		SELECT 	nr_sequencia_w,
			CD_ESTRUTURA,
			DT_ATUALIZACAO,
			NM_USUARIO,
			CD_GRUPO_MATERIAL,
			CD_SUBGRUPO_MATERIAL,
			CD_CLASSE_MATERIAL,
			CD_MATERIAL,
			CD_CONVENIO,
			CD_SETOR_ATENDIMENTO,
			IE_TIPO_ATENDIMENTO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			IE_TIPO_CONVENIO,
			IE_RESPONSAVEL_CREDITO,
			cd_estabelecimento,
			ie_tipo_material
		from 	conta_estrut_mat
		where 	nr_sequencia = nr_sequencia_p;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_atrib_estrut_proc ( nr_sequencia_p bigint, ie_proc_mat_p text, nm_usuario_p text) FROM PUBLIC;

