-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_executor_proc_laudo (nr_laudo_p bigint, cd_medico_executor_p text, ie_tipo_alteracao_p text, nm_usuario_p text) AS $body$
DECLARE



nr_seq_procedimento_w		bigint;
nr_interno_conta_w			bigint;
ie_status_acerto_w			varchar(03);

cd_medico_executor_w		varchar(10);
cd_estabelecimento_w		bigint;
cd_perfil_comunic_w		bigint;
nr_seq_proc_repasse_w		bigint;
nr_repasse_terceiro_w		bigint;
nm_terceiro_w			varchar(254);
ds_procedimento_w			varchar(254);
nm_paciente_w			varchar(254);
nr_atendimento_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
dt_procedimento_w			timestamp;
cd_cbo_w			varchar(6)	:= '';

cd_medico_atual_w		varchar(254);

c01 CURSOR FOR
	SELECT	a.nr_interno_conta,
		a.nr_sequencia,
		b.ie_status_acerto,
		a.cd_medico_executor,
		b.cd_estabelecimento
	from	conta_paciente b,
		procedimento_paciente a
	where	a.nr_interno_conta	= b.nr_interno_conta
	and	a.nr_laudo		= nr_laudo_p;


BEGIN

open	c01;
loop
fetch	c01 into
	nr_interno_conta_w,
	nr_seq_procedimento_w,
	ie_status_acerto_w,
	cd_medico_executor_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ie_tipo_alteracao_p = 'S') or (ie_status_acerto_w = '1') then

		select	cd_procedimento,
			ie_origem_proced,
			dt_procedimento
		into STRICT	cd_procedimento_w,
			ie_origem_proced_w,
			dt_procedimento_w
		from	procedimento_paciente
		where	nr_sequencia = nr_seq_procedimento_w;

		if (ie_origem_proced_w = 7) then
			begin
			select	max(a.cd_cbo)
			into STRICT		cd_cbo_w
			from    	sus_cbo                 b,
						sus_cbo_pessoa_fisica   a
			where   sus_obter_secbo_compativel(cd_medico_executor_p, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, a.cd_cbo, 0) = 'S'
			and     cd_pessoa_fisica        = cd_medico_executor_p
			and     a.cd_cbo        	= b.cd_cbo;
			end;
		end if;

		update	procedimento_paciente
		set	cd_medico_executor	= cd_medico_executor_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			cd_cbo			= cd_cbo_w
		where	nr_sequencia		= nr_seq_procedimento_w;

		update	procedimento_paciente
		set	cd_medico_executor	= cd_medico_executor_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_seq_proc_princ	= nr_seq_procedimento_w;

		select	coalesce(max(cd_perfil_comunic),0)
		into STRICT	cd_perfil_comunic_w
		from	parametro_repasse
		where	cd_estabelecimento	= cd_estabelecimento_w;

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_proc_repasse_w
		from	procedimento_repasse
		where	nr_seq_procedimento	= nr_seq_procedimento_w;

		/* Edgar 24/08/2006 OS 30694, criei rotina para gerar comunicação interna */

		if (coalesce(cd_medico_executor_w,'X') <> coalesce(cd_medico_executor_p, 'X')) and (cd_perfil_comunic_w > 0) and (nr_seq_proc_repasse_w > 0) then

			select	nr_repasse_terceiro,
				nm_pessoa,
				substr(obter_descricao_procedimento(c.cd_procedimento, c.ie_origem_proced),1,254),
				substr(obter_pessoa_atendimento(c.nr_atendimento, 'N'),1,254),
				c.nr_atendimento,
				c.nr_interno_conta,
				c.cd_medico_executor
			into STRICT	nr_repasse_terceiro_w,
				nm_terceiro_w,
				ds_procedimento_w,
				nm_paciente_w,
				nr_atendimento_w,
				nr_interno_conta_w,
				cd_medico_atual_w
			from	procedimento_paciente c,
				terceiro_v b,
				procedimento_repasse a
			where	a.nr_sequencia		= nr_seq_proc_repasse_w
			and	a.nr_seq_terceiro	= b.nr_sequencia
			and	a.nr_seq_procedimento	= c.nr_sequencia;

			insert	into comunic_interna(DT_COMUNICADO,
					DS_TITULO,
					DS_COMUNICADO,
					NM_USUARIO,
					DT_ATUALIZACAO,
					IE_GERAL,
					NM_USUARIO_DESTINO,
					CD_PERFIL,
					NR_SEQUENCIA,
					IE_GERENCIAL,
					NR_SEQ_CLASSIF,
					DS_PERFIL_ADICIONAL,
					CD_SETOR_DESTINO,
					CD_ESTAB_DESTINO,
					DS_SETOR_ADICIONAL,
					DT_LIBERACAO,
					DS_GRUPO,
					NM_USUARIO_OCULTO)
			SELECT		clock_timestamp(),
					WHEB_MENSAGEM_PCK.get_texto(301252), --Alteração médico executor com repasse
					WHEB_MENSAGEM_PCK.get_texto(301253,'NM_TERCEIRO_W=' || nm_terceiro_w ||
									   ';NR_REPASSE_TERCEIRO_W=' || nr_repasse_terceiro_w ||
									   ';NM_PACIENTE_W=' || nm_paciente_w ||
									   ';NR_ATENDIMENTO_W=' || nr_atendimento_w ||
									   ';NR_INTERNO_CONTA_W=' || nr_interno_conta_w ||
									   ';DS_PROCEDIMENTO_W=' || ds_procedimento_w ||
									   ';CD_MEDICO_EXECUTOR_W=' || obter_nome_pf(cd_medico_executor_w) ||
									   ';CD_MEDICO_EXECUTOR_WW=' || obter_nome_pf(cd_medico_executor_p)),
					nm_usuario_p,
					clock_timestamp(),
					'N',
					null,
					null,
					nextval('comunic_interna_seq'),
					'N',
					null,
					cd_perfil_comunic_w || ',',
					null,
					null,
					null,
					clock_timestamp(),
					null,
					null
			;

		end if;

	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_executor_proc_laudo (nr_laudo_p bigint, cd_medico_executor_p text, ie_tipo_alteracao_p text, nm_usuario_p text) FROM PUBLIC;
