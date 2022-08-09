-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conta_etapa_completo ( nr_interno_conta_p bigint, nm_usuario_p text, nr_seq_etapa_p bigint, nr_motivo_devol_p bigint, dt_etapa_p timestamp, cd_pessoa_fisica_p text, cd_pessoa_exec_p text, cd_setor_atendimento_p bigint, ds_observacao_p text, dt_fim_etapa_p timestamp, ie_etapa_critica_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_motivo_devol_w	bigint;
cd_pessoa_fisica_w	varchar(10);
cd_pessoa_exec_w	varchar(10);
cd_setor_atendimento_w	conta_paciente_etapa.cd_setor_atendimento%type;
dt_fim_etapa_w		timestamp;


BEGIN

select	nextval('conta_paciente_etapa_seq')
into STRICT	nr_sequencia_w
;

nr_motivo_devol_w := nr_motivo_devol_p;
if (nr_motivo_devol_w = 0) then
	nr_motivo_devol_w := null;
end if;

cd_setor_atendimento_w := cd_setor_atendimento_p;
if (cd_setor_atendimento_w = 0) then
	cd_setor_atendimento_w := null;
end if;

dt_fim_etapa_w := dt_fim_etapa_p;
if (dt_fim_etapa_w = to_date('31/12/1899 00:00:00', 'dd/mm/yyyy hh24:mi:ss')) then
	dt_fim_etapa_w := null;
end if;

cd_pessoa_fisica_w := cd_pessoa_fisica_p;
if (cd_pessoa_fisica_w = '') or (coalesce(cd_pessoa_fisica_w::text, '') = '') then
	select 	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from 	usuario
	where 	nm_usuario = nm_usuario_p;
end if;

cd_pessoa_exec_w := cd_pessoa_exec_p;
if (cd_pessoa_exec_w = '') then
	cd_pessoa_exec_w := null;
end if;

insert into conta_paciente_etapa(
			nr_sequencia,
			nr_interno_conta,
			dt_atualizacao,
			nm_usuario,
			dt_etapa,
			nr_seq_etapa,
			cd_setor_atendimento,
			cd_pessoa_fisica,
			nr_seq_motivo_dev,
			ds_observacao,
			nr_lote_barras,
			cd_pessoa_exec,
			dt_fim_etapa,
			ie_etapa_critica)
		values (nr_sequencia_w,
			nr_interno_conta_p,
			clock_timestamp(),
			nm_usuario_p,
			dt_etapa_p,
			nr_seq_etapa_p,
			cd_setor_atendimento_w,
			cd_pessoa_fisica_w,
			nr_motivo_devol_w,
			substr(ds_observacao_p,1,2000),
			null,
			cd_pessoa_exec_w,
			dt_fim_etapa_w,
			ie_etapa_critica_p);

CALL atualiza_final_etapa_conta(nr_sequencia_w, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conta_etapa_completo ( nr_interno_conta_p bigint, nm_usuario_p text, nr_seq_etapa_p bigint, nr_motivo_devol_p bigint, dt_etapa_p timestamp, cd_pessoa_fisica_p text, cd_pessoa_exec_p text, cd_setor_atendimento_p bigint, ds_observacao_p text, dt_fim_etapa_p timestamp, ie_etapa_critica_p text) FROM PUBLIC;
