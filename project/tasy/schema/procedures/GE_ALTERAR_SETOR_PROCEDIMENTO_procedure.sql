-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ge_alterar_setor_procedimento ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_setor_atendimento_p bigint) AS $body$
DECLARE


ie_gerado_conta_w	varchar(1);
ie_atualiza_prescr_medica_w	varchar(10);

cd_setor_entrega_w	bigint;
cd_setor_atendimento_w	bigint;
cd_setor_atend_proced_w	bigint;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	select	coalesce(max(obter_valor_param_usuario(942, 352, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, 0)), 'S')
	into STRICT	ie_atualiza_prescr_medica_w
	;

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_gerado_conta_w
	from	procedimento_paciente a
	where	a.nr_prescricao = nr_prescricao_p
	and	a.nr_sequencia_prescricao = nr_seq_prescr_p;

	if (ie_gerado_conta_w = 'N') then

		select	max(a.cd_setor_entrega),
			max(a.cd_setor_atendimento),
			max(b.cd_setor_atendimento)
		into STRICT	cd_setor_entrega_w,
			cd_setor_atendimento_w,
			cd_setor_atend_proced_w
		from	prescr_medica a,
			prescr_procedimento b
		where	a.nr_prescricao = b.nr_prescricao
		and	b.nr_prescricao = nr_prescricao_p
		and	b.nr_sequencia = nr_seq_prescr_p;


		if ( coalesce(ie_atualiza_prescr_medica_w,'S') = 'N') then

			update	prescr_procedimento
			set	cd_setor_atendimento = cd_setor_atendimento_p
			where	nr_prescricao = nr_prescricao_p
			and	nr_sequencia = nr_seq_prescr_p;

			CALL gravar_log_cdi(125, substr(WHEB_MENSAGEM_PCK.get_texto(305568,'NR_PRESCRICAO_P='|| NR_PRESCRICAO_P ||';NR_SEQ_PRESCR_P='|| NR_SEQ_PRESCR_P ||';CD_SETOR_ATENDIMENTO_P='|| CD_SETOR_ATENDIMENTO_P ||';CD_SETOR_ATEND_PROCED_W='|| CD_SETOR_ATEND_PROCED_W),1,2000), wheb_usuario_pck.get_nm_usuario);
						/*Alterado setor atendimento da prescr_procedimento - Prescr: #@NR_PRESCRICAO_P#@ - Seq: #@NR_SEQ_PRESCR_P#@ - Setor anterior: #@CD_SETOR_ATEND_PROCED_W#@ - Novo setor: #@CD_SETOR_ATENDIMENTO_P#@*/

		elsif (cd_setor_atend_proced_w IS NOT NULL AND cd_setor_atend_proced_w::text <> '') then

			update	prescr_procedimento
			set	cd_setor_atendimento = cd_setor_atendimento_p
			where	nr_prescricao = nr_prescricao_p
			and	nr_sequencia = nr_seq_prescr_p;

			CALL gravar_log_cdi(125, substr(WHEB_MENSAGEM_PCK.get_texto(305568,'NR_PRESCRICAO_P='|| NR_PRESCRICAO_P ||';NR_SEQ_PRESCR_P='|| NR_SEQ_PRESCR_P ||';CD_SETOR_ATENDIMENTO_P='|| CD_SETOR_ATENDIMENTO_P ||';CD_SETOR_ATEND_PROCED_W='|| CD_SETOR_ATEND_PROCED_W),1,2000), wheb_usuario_pck.get_nm_usuario);
						/*Alterado setor atendimento da prescr_procedimento - Prescr: #@NR_PRESCRICAO_P#@ - Seq: #@NR_SEQ_PRESCR_P#@ - Setor anterior: #@CD_SETOR_ATEND_PROCED_W#@ - Novo setor: #@CD_SETOR_ATENDIMENTO_P#@*/

		elsif (cd_setor_entrega_w IS NOT NULL AND cd_setor_entrega_w::text <> '') then

			update	prescr_medica
			set	cd_setor_entrega = cd_setor_atendimento_p
			where	nr_prescricao = nr_prescricao_p;

			CALL gravar_log_cdi(125, substr(WHEB_MENSAGEM_PCK.get_texto(305570,'NR_PRESCRICAO_P='|| NR_PRESCRICAO_P ||';CD_SETOR_ENTREGA_W='|| CD_SETOR_ENTREGA_W ||';CD_SETOR_ATENDIMENTO_P='|| CD_SETOR_ATENDIMENTO_P),1,2000),  wheb_usuario_pck.get_nm_usuario);
						/*Alterado setor entrega da prescr_medica - Prescr: #@NR_PRESCRICAO_P#@ - Setor anterior: #@CD_SETOR_ENTREGA_W#@ - Novo setor: #@CD_SETOR_ATENDIMENTO_P#@*/

		else

			update	prescr_medica
			set	cd_setor_atendimento = cd_setor_atendimento_p
			where	nr_prescricao = nr_prescricao_p;

			CALL gravar_log_cdi(125, substr(WHEB_MENSAGEM_PCK.get_texto(305573,'NR_PRESCRICAO_P='|| NR_PRESCRICAO_P ||';CD_SETOR_ATENDIMENTO_W='|| CD_SETOR_ATENDIMENTO_W ||';CD_SETOR_ATENDIMENTO_P='|| CD_SETOR_ATENDIMENTO_P),1,2000),  wheb_usuario_pck.get_nm_usuario);
						/*Alterado setor atendimento da prescr_medica - Prescr: #@NR_PRESCRICAO_P#@ - Setor anterior: #@CD_SETOR_ATENDIMENTO_W#@ - Novo setor: #@CD_SETOR_ATENDIMENTO_P#@*/

		end if;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ge_alterar_setor_procedimento ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;
