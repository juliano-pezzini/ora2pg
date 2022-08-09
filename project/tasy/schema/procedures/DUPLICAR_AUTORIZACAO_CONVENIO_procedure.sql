-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_autorizacao_convenio (nr_seq_autor_origem_p bigint, nm_usuario_p text, nr_seq_autor_gerada_p INOUT bigint, ie_duplicar_item_p text, ie_commit_p text) AS $body$
DECLARE


nr_seq_autor_gerada_w		bigint;
nr_seq_autorizacao_w		bigint;
nr_seq_estagio_autor_w		bigint;
nr_atendimento_w		bigint;
cd_estabelecimento_w		bigint;
nr_seq_proc_autor_novo_w	bigint;
nr_seq_proc_autor_ant_w		bigint;
nr_seq_mat_autor_novo_w		bigint;
nr_seq_mat_autor_ant_w		bigint;
ie_copia_guia_w			varchar(5);
ie_copia_senha_w		varchar(5);

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	procedimento_autorizado a
where	nr_sequencia_autor		= nr_seq_autor_origem_p
and	not exists (	SELECT	1
			from	tiss_retorno_autorizacao x
			where	x.nr_seq_proc_autor	= a.nr_sequencia
			and	(x.nr_seq_motivo_glosa IS NOT NULL AND x.nr_seq_motivo_glosa::text <> ''));

c02 CURSOR FOR
SELECT	a.nr_sequencia
from	material_autorizado a
where	nr_sequencia_autor		= nr_seq_autor_origem_p;


BEGIN

if (nr_seq_autor_origem_p IS NOT NULL AND nr_seq_autor_origem_p::text <> '') then

	select	nextval('autorizacao_convenio_seq')
	into STRICT	nr_seq_autor_gerada_w
	;

	select	nr_atendimento,
		cd_estabelecimento
	into STRICT	nr_atendimento_w,
		cd_estabelecimento_w
	from	autorizacao_convenio
	where	nr_sequencia	= nr_seq_autor_origem_p;

	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

		select	coalesce(max(nr_seq_autorizacao),0) + 1
		into STRICT	nr_seq_autorizacao_w
		from	autorizacao_convenio
		where	nr_atendimento	= (SELECT	nr_atendimento
					   from		autorizacao_convenio
					   where	nr_sequencia	= nr_seq_autor_origem_p);
	end if;	

	select	max(nr_seq_estagio_autor)
	into STRICT	nr_seq_estagio_autor_w
	from	parametro_faturamento
	where	cd_estabelecimento	= cd_estabelecimento_w;

	ie_copia_guia_w := Obter_Param_Usuario(3004, 59, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_copia_guia_w);
	ie_copia_senha_w := Obter_Param_Usuario(3004, 221, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_copia_senha_w);

	insert into autorizacao_convenio(nr_sequencia,
		nr_atendimento,
		nr_seq_autorizacao,
		cd_convenio,
		cd_autorizacao,
		dt_autorizacao,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		nm_responsavel,
		ds_observacao,
		cd_senha,
		cd_procedimento_principal,
		ie_origem_proced,
		dt_pedido_medico,
		cd_medico_solicitante,
		ie_tipo_guia,
		qt_dia_autorizado,
		nr_prescricao,
		nr_seq_estagio,
		ie_tipo_autorizacao,
		ie_tipo_dia,
		cd_tipo_acomodacao,
		ds_indicacao,
		nr_seq_agenda,
		nm_usuario,
		dt_atualizacao,
		nr_seq_gestao,
		dt_envio,
		dt_entrada_prevista,
		nr_seq_paciente_setor,
		nr_ciclo,
		ds_dia_ciclo,
		cd_pessoa_fisica,
		cd_estabelecimento,
		nr_seq_agenda_consulta,
		dt_agenda,
		dt_agenda_cons,
		dt_agenda_integ,
		nr_seq_age_integ,
		cd_setor_origem,
		nr_Seq_paciente,
		nr_seq_classif,
		ie_carater_int_tiss,
		ie_tiss_tipo_anexo_autor,
		cd_setor_resp,
		cd_empresa_pac,
		nr_seq_agenda_proc,	
		qt_dia_solicitado,
		nr_seq_proc_interno, 
		cd_procedimento_convenio, 
		ie_resp_autor, 
		qt_dias_prazo, 
		cd_senha_provisoria, 
		dt_referencia, 
		nr_seq_auditoria, 
		nm_usuario_resp, 
		nr_seq_rxt_tratamento, 
		ie_tipo_internacao_tiss, 
		ie_previsao_uso_quimio, 
		ie_previsao_uso_opme, 
		ie_regime_internacao, 
		ie_tiss_tipo_acidente, 
		cd_autorizacao_prest,
    		dt_atualizacao_nrec,
    		nm_usuario_nrec,
		ie_tiss_tipo_etapa_autor) 
	SELECT	nr_seq_autor_gerada_w,
		nr_atendimento,
		nr_seq_autorizacao_w,
		cd_convenio,
		CASE WHEN ie_copia_guia_w='S' THEN cd_autorizacao WHEN ie_copia_guia_w='N' THEN null END ,
		clock_timestamp(),
		dt_inicio_vigencia,
		dt_fim_vigencia,
		nm_responsavel,
		ds_observacao,
		CASE WHEN ie_copia_senha_w='S' THEN cd_senha  ELSE null END ,
		cd_procedimento_principal,
		ie_origem_proced,
		dt_pedido_medico,
		cd_medico_solicitante,
		ie_tipo_guia,
		qt_dia_autorizado,
		nr_prescricao,
		coalesce(nr_seq_estagio_autor_w, nr_seq_estagio),
		ie_tipo_autorizacao,
		ie_tipo_dia,
		cd_tipo_acomodacao,
		ds_indicacao,
		nr_seq_agenda,
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_gestao,
		dt_envio,
		dt_entrada_prevista,
		nr_seq_paciente_setor,
		nr_ciclo,
		ds_dia_ciclo,
		cd_pessoa_fisica,
		cd_estabelecimento,
		nr_seq_agenda_consulta,
		dt_agenda,
		dt_agenda_cons,
		dt_agenda_integ,
		nr_seq_age_integ,
		cd_setor_origem,
		nr_Seq_paciente,
		nr_seq_classif,
		ie_carater_int_tiss,
		ie_tiss_tipo_anexo_autor,
		cd_setor_resp,
		cd_empresa_pac,
		nr_seq_agenda_proc,
		qt_dia_solicitado,
		nr_seq_proc_interno,
		cd_procedimento_convenio,
		ie_resp_autor,
		qt_dias_prazo,
		cd_senha_provisoria,
		dt_referencia,
		nr_seq_auditoria,
		nm_usuario_resp,
		nr_seq_rxt_tratamento,
		ie_tipo_internacao_tiss,
		ie_previsao_uso_quimio,
		ie_previsao_uso_opme,
		ie_regime_internacao,
		ie_tiss_tipo_acidente,
		cd_autorizacao_prest,
    		clock_timestamp(),
    		nm_usuario_p,
		ie_tiss_tipo_etapa_autor
	from	autorizacao_convenio a
	where	nr_sequencia	= nr_seq_autor_origem_p;

	nr_seq_autor_gerada_p	:= nr_seq_autor_gerada_w;

	if (coalesce(ie_duplicar_item_p, 'N') = 'S') then

		open c01;
		loop
		fetch c01 into
			nr_seq_proc_autor_ant_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

			select	nextval('procedimento_autorizado_seq')
			into STRICT	nr_seq_proc_autor_novo_w
			;

			insert into procedimento_autorizado(nr_atendimento,
				nr_seq_autorizacao,
				cd_procedimento,
				ie_origem_proced,
				qt_autorizada,
				dt_atualizacao,
				nm_usuario,
				ds_observacao,
				vl_autorizado,
				nr_prescricao,
				nr_seq_prescricao,
				nm_usuario_aprov,
				dt_aprovacao,
				qt_solicitada,
				nr_sequencia_autor,
				nr_sequencia,
				nr_seq_proc_interno,
				cd_procedimento_convenio,
				nr_seq_agenda,
				cd_procedimento_tuss,
				nr_seq_agenda_proc,
				nr_seq_agenda_consulta,
				nr_seq_exame,
				nr_seq_ageint_exame_lab,						
				ie_lado)
			SELECT	nr_atendimento,
				nr_seq_autorizacao_w,
				cd_procedimento,
				ie_origem_proced,
				qt_autorizada,
				clock_timestamp(),
				nm_usuario_p,
				ds_observacao,
				vl_autorizado,
				nr_prescricao,
				nr_seq_prescricao,
				nm_usuario_aprov,
				dt_aprovacao,
				qt_solicitada,
				nr_seq_autor_gerada_w,
				nr_seq_proc_autor_novo_w,
				nr_seq_proc_interno,
				cd_procedimento_convenio,
				nr_seq_agenda,
				cd_procedimento_tuss, 
				nr_seq_agenda_proc, 
				nr_seq_agenda_consulta, 
				nr_seq_exame, 
				nr_seq_ageint_exame_lab, 
				ie_lado 
			from	procedimento_autorizado a
			where	nr_sequencia	= nr_seq_proc_autor_ant_w;

	
			update	procedimento_paciente
			set	nr_seq_proc_autor	= nr_seq_proc_autor_novo_w
			where	nr_seq_proc_autor	= nr_seq_proc_autor_ant_w;
		end loop;
		close c01;

		open c02;
		loop
		fetch c02 into
			nr_seq_mat_autor_ant_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			select	nextval('material_autorizado_seq')
			into STRICT	nr_seq_mat_autor_novo_w
			;

			insert into material_autorizado(nr_atendimento,
				nr_seq_autorizacao,
				cd_material,
				qt_autorizada,
				dt_atualizacao,
				nm_usuario,
				ds_observacao,
				nm_usuario_aprov,
				dt_aprovacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				qt_solicitada,
				nr_sequencia_autor,
				nr_sequencia,
				nr_prescricao,
				nr_seq_prescricao,
				cd_material_convenio,
				cd_cgc_fabricante,
				vl_unitario,
				ds_mat_convenio,
				nr_seq_fabricante,
				ie_valor_conta,
				pr_adicional, 
				nr_seq_marca, 
				nr_orcamento, 
				nr_seq_opme, 
				ie_origem_preco, 
				ie_via_aplicacao, 
				nr_seq_regra_quimio,
				ie_enviar) 
			SELECT	nr_atendimento,
				nr_seq_autorizacao_w,
				cd_material,
				qt_autorizada,
				clock_timestamp(),
				nm_usuario_p,
				ds_observacao,
				nm_usuario_aprov,
				dt_aprovacao,
				clock_timestamp(),
				nm_usuario_p,
				qt_solicitada,
				nr_seq_autor_gerada_w,
				nr_seq_mat_autor_novo_w,
				nr_prescricao,
				nr_seq_prescricao,
				cd_material_convenio,
				cd_cgc_fabricante,
				vl_unitario,
				ds_mat_convenio,
				nr_seq_fabricante,
				ie_valor_conta,
				pr_adicional,
				nr_seq_marca,
				nr_orcamento,
				nr_seq_opme,				
				ie_origem_preco,
				ie_via_aplicacao,
				nr_seq_regra_quimio,
				ie_enviar				
			from	material_autorizado
			where	nr_sequencia	= nr_seq_mat_autor_ant_w;

			update	material_atend_paciente
			set	nr_seq_mat_autor	= nr_seq_mat_autor_novo_w
			where	nr_seq_mat_autor	= nr_seq_mat_autor_ant_w;

		end loop;
		close c02;

	end if;
end if;

if (ie_commit_p = 'S') then
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_autorizacao_convenio (nr_seq_autor_origem_p bigint, nm_usuario_p text, nr_seq_autor_gerada_p INOUT bigint, ie_duplicar_item_p text, ie_commit_p text) FROM PUBLIC;
