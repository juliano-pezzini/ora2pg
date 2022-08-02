-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recep_excluir_atendimento ( nr_atendimento_p bigint, ie_consiste_p text, nm_usuario_p text, ds_justificativa_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w					varchar(255);
dt_alta_w					timestamp;
cd_estabelecimento_w				smallint;
qt_proc_w					integer;
qt_Material_w					integer;
nr_prontuario_w				bigint;
nm_paciente_w					varchar(100);
qt_existe_w					bigint;
nr_seq_same_w					bigint;
nr_atend_origem_w				bigint;
ds_justificativa_w			varchar(100);
ie_consiste_mat_exc_w			varchar(1);
dt_entrada_w					timestamp;
qt_itens_prescr_w		bigint;
ie_verifica_prescr_w		varchar(1);
ds_mascara_w			varchar(100);


BEGIN

ds_erro_w			:= '';
ds_justificativa_w  := substr(ds_justificativa_p,1,100);

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;


/*Obter_Param_Usuario(916,406,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w,ie_consiste_mat_exc_w);
Obter_Param_Usuario(916, 545, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_verifica_prescr_w );



if	(ie_consiste_mat_exc_w = 'S') then

	select	nvl(count(*),0)
	into	qt_proc_w
	from	procedimento_paciente
	where	nr_atendimento = nr_atendimento_p;

	select	nvl(count(*),0)
	into	qt_material_w
	from	Material_Atend_Paciente
	where	nr_atendimento = nr_atendimento_p;

	if	(qt_proc_w > 0) then
		ds_erro_w	:= ds_erro_w || ' Existem ' || qt_proc_w || 
				' Procedimentos na conta!!!';
	end if;	

	if	(qt_Material_w > 0) then
		ds_erro_w	:= ds_erro_w || ' Existem ' || qt_material_w || 
				' Materiais na conta !!!';
	end if;	

end if;

*/
if (ie_consiste_p = 'S') then
	begin
	select	max(dt_alta),
			max(cd_estabelecimento)
	into STRICT	dt_alta_w, 
			cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;

	select	coalesce(count(*),0)
	into STRICT	qt_proc_w
	from	procedimento_paciente
	where	nr_atendimento = nr_atendimento_p
	  and	coalesce(cd_motivo_exc_conta::text, '') = '';

	select	coalesce(count(*),0)
	into STRICT	qt_material_w
	from	Material_Atend_Paciente
	where	nr_atendimento = nr_atendimento_p
	  and	coalesce(cd_motivo_exc_conta::text, '') = '';

	if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then
		ds_erro_w		:= WHEB_MENSAGEM_PCK.get_texto(278820,null);
	end if;		

	if (qt_proc_w > 0) then
		ds_erro_w	:= ds_erro_w || ' ' ||WHEB_MENSAGEM_PCK.get_texto(278823,'QT_PROC='||qt_proc_w);
	end if;		

	if (qt_Material_w > 0) then
		ds_erro_w	:= ds_erro_w || ' ' ||WHEB_MENSAGEM_PCK.get_texto(278826,'QT_MATERIAL='||qt_material_w);
	end if;	

	select	coalesce(max(nr_atendimento),0)
	into STRICT	nr_atend_origem_w
	from	atendimento_paciente
	where	nr_atend_original = nr_atendimento_p;
	
	if (nr_atend_origem_w > 0) then
		ds_erro_w	:= ds_erro_w || ' ' ||WHEB_MENSAGEM_PCK.get_texto(278827,'NR_ATEND_ORIGEM='||nr_atend_origem_w);
	end if;
	
	end;
end if;

/* Este tratamento realizado diretamente dentro do codigo, atendimentoPacienteWDBPBeforeDelete, sem o parametro
if	( ie_verifica_prescr_w = 'N') then

	select 	count(*)			
	into	qt_itens_prescr_w
	from	prescr_procedimento a,
		prescr_medica b
	where	a.nr_prescricao = b.nr_prescricao
	and	ie_suspenso <> 'S'
	and	b.nr_atendimento = nr_atendimento_p;

	if	(qt_itens_prescr_w = 0) then

		select 	count(*)			
		into	qt_itens_prescr_w
		from	prescr_material a,
			prescr_medica b
		where	a.nr_prescricao = b.nr_prescricao
		and	ie_suspenso <> 'S'
		and	b.nr_atendimento = nr_atendimento_p;

	end if;
	
	if	(qt_itens_prescr_w > 0) then	
		ds_erro_w	:= ds_erro_w || ' Atendimento possui prescricoes. Parametro[545]';
	end if;		
end if;
*/
if (ds_erro_w = '') or (coalesce(ds_erro_w::text, '') = '') then
	begin
	select  max(Obter_Prontuario_Paciente(cd_pessoa_fisica)) nr_prontuario,
			max(substr(obter_nome_pf(cd_pessoa_fisica),1,100)) nm_paciente,
			max(dt_entrada)
	into STRICT	nr_prontuario_w,
			nm_paciente_w,
			dt_entrada_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;

	update	agenda_paciente
	set 	nr_atendimento	 = NULL,
		ie_status_agenda	= 'N' /* Rafael em 09/09/06 OS39723 */
	where 	nr_atendimento	= nr_atendimento_p;
	update agenda_consulta
	set 	nr_atendimento	 = NULL,
		ie_status_agenda 	= 'N' /* Rafael em 09/09/06 OS39723 */
	where 	nr_atendimento	= nr_atendimento_p;

	update	movimento_estoque
	set	nr_atendimento	 = NULL
	where	nr_atendimento	= nr_atendimento_p; /*Edilson em 09/01/2007 OS 47576 Falei com Fabio*/
	update	movimento_estoque a
	set	a.nr_prescricao	 = NULL
	where	exists (	SELECT	1
				from	prescr_medica b
				where	a.nr_prescricao	= b.nr_prescricao
				and	b.nr_atendimento	= nr_atendimento_p); /*Edilson em 05/05/2007 OS 49847 Falei com Fabio*/
	delete from cirurgia_tempo a
	 	where a.nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
				 	where  b.nr_atendimento = nr_atendimento_p);
	delete from cirurgia_participante a
	 	where a.nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
				 	where  b.nr_atendimento = nr_atendimento_p);
					
	update	agenda_paciente /*Felipe Martini em 24/03/2010 OS204689*/
	set 	nr_atendimento	 = NULL,
		nr_cirurgia	 = NULL,
		ie_status_agenda	= 'N'
	where 	nr_cirurgia	in (SELECT b.nr_cirurgia from cirurgia b 
				 	where  b.nr_atendimento = nr_atendimento_p);
							
	delete from cirurgia_descricao a
	 	where a.nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
				 	where  b.nr_atendimento = nr_atendimento_p);
	
	delete from parecer_medico_req where nr_atendimento = nr_atendimento_p;
	delete from diagnostico_medico where nr_atendimento = nr_atendimento_p;
	delete from nascimento where nr_atendimento = nr_atendimento_p;
	delete 	from	evolucao_paciente e
		where	e.nr_atendimento = nr_atendimento_p
		and	((coalesce(e.nr_cirurgia::text, '') = '') or (e.nr_cirurgia not in (SELECT c.nr_cirurgia from cirurgia c where c.nr_atendimento = nr_atendimento_p)));
	delete from evolucao_paciente where nr_atend_alta = nr_atendimento_p;
	delete from devolucao_material_pac where nr_atendimento = nr_atendimento_p;
	delete from procedimento_paciente where nr_atendimento = nr_atendimento_p;
	delete from material_atend_paciente where nr_atendimento = nr_atendimento_p;
	
	delete from material_atend_paciente where nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
				 	where  b.nr_atendimento = nr_atendimento_p);
					
	delete from procedimento_paciente where nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
	where  b.nr_atendimento = nr_atendimento_p);
	delete from cih_cirurgia where nr_seq_cirurgia_pac in (SELECT b.nr_cirurgia from cirurgia b
				 	where  b.nr_atendimento = nr_atendimento_p);
	delete from anestesia_descricao  where nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
	where  b.nr_atendimento = nr_atendimento_p);
	delete from aval_pre_anestesica  where nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
	where  b.nr_atendimento = nr_atendimento_p);
	delete from cirurgia_tec_anestesica  where nr_cirurgia in (SELECT b.nr_cirurgia from cirurgia b
	where  b.nr_atendimento = nr_atendimento_p);
	delete from aval_pre_anestesica  where nr_atendimento	= nr_atendimento_p;
	delete from evolucao_paciente where nr_atendimento = nr_atendimento_p;
	delete from evolucao_paciente where nr_cirurgia in (SELECT nr_cirurgia from cirurgia where nr_atendimento = nr_atendimento_p);
	delete from cirurgia where nr_atendimento = nr_atendimento_p;
	delete from atendimento_sinal_vital where nr_atendimento = nr_atendimento_p;
	delete from pep_pac_ci where nr_atendimento = nr_atendimento_p;
	delete from med_avaliacao_paciente where nr_atendimento = nr_atendimento_p;
	delete from atend_paciente_auxiliar where nr_atendimento = nr_atendimento_p;
	
	update	movimento_estoque
	set	nr_atendimento	 = NULL
	where	nr_atendimento	= nr_atendimento_p; /*Edilson em 09/01/2007 OS 47576 Falei com Fabio*/
	update	movimento_estoque a
	set	a.nr_prescricao	 = NULL
	where	exists (	SELECT	1
				from	prescr_medica b
				where	a.nr_prescricao	= b.nr_prescricao
				and	b.nr_atendimento	= nr_atendimento_p); /*Anderson 24/07/2007 OS63585 Atualizar os movimentos de estorno*/


	/* Rafael em 26/10/2007 OS72514 */

	delete	from prescr_mat_alteracao
	where	nr_prescricao in (	SELECT	nr_prescricao
					from	prescr_medica
					where	nr_atendimento = nr_atendimento_p);
	delete	from prescr_dieta_hor
	where	nr_prescricao in (	SELECT	nr_prescricao
					from	prescr_medica
					where	nr_atendimento = nr_atendimento_p);									
	/* Fim Rafael em 26/10/2007 OS72514 */

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_same_w
	from	same_prontuario
	where	nr_atendimento = nr_atendimento_p;
	
	if (nr_seq_same_w > 0) then
	
		delete from same_prontuario_hist where nr_seq_same = nr_seq_same_w;		
		delete from same_prontuario where nr_atendimento = nr_atendimento_p;
	
	end if;
	
	delete from processo_atendimento where nr_atendimento = nr_atendimento_p;
	delete from orcamento_paciente where nr_atendimento = nr_atendimento_p;
	delete from adiantamento where nr_atendimento = nr_atendimento_p;
	delete from prescr_medica where nr_atendimento = nr_atendimento_p;
	delete from atend_categoria_convenio where nr_atendimento = nr_atendimento_p;
	delete from atend_caucao where nr_atendimento = nr_atendimento_p;
	delete from procedimento_autorizado where nr_atendimento = nr_atendimento_p;
	delete from material_autorizado where nr_atendimento = nr_atendimento_p;
	delete from autorizacao_convenio where nr_atendimento = nr_atendimento_p;
	delete from conta_paciente where nr_atendimento = nr_atendimento_p;			
	delete from sus_laudo_paciente where nr_atendimento = nr_atendimento_p;
	delete from sus_aih where nr_atendimento = nr_atendimento_p;
	delete from titulo_receber where nr_atendimento = nr_atendimento_p;
	delete from atend_paciente_unidade where nr_atendimento = nr_atendimento_p;
	delete from ehr_registro where nr_atendimento = nr_atendimento_p;
	delete from triagem_pronto_atend where nr_atendimento = nr_atendimento_p;
	delete from	atendimento_indicacao where nr_atendimento = nr_atendimento_p;
	delete from obs_alta_hist where nr_atendimento = nr_atendimento_p;
	delete from w_pep_regra_informacao where nr_atendimento = nr_atendimento_p; -- Richart
	
	update	gestao_vaga			/*Anderson/Dalcastagne 24/07/2007 - OS63585*/
	set	nr_atendimento  = NULL
	where	nr_atendimento = nr_atendimento_p;
	
	update	pre_venda_item
	set	nr_atendimento  = NULL,
		nr_prescricao  = NULL,
		nr_seq_interno  = NULL
	where	nr_atendimento = nr_atendimento_p;

	delete	from atendimento_paciente_inf
	where	nr_atendimento	= nr_atendimento_p;

	delete from atendimento_paciente where nr_atendimento = nr_atendimento_p;
	
	update recep_ficha_pre
	set nr_atendimento  = NULL
	where nr_atendimento = nr_atendimento_p;

	commit;

	select	count(*)
	into STRICT	qt_existe_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;
	
	if (qt_existe_w = 0) then

		ds_mascara_w := pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario));
	
		if (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') then
			CALL gravar_log_exclusao('ATENDIMENTO_PACIENTE', nm_usuario_p,
					wheb_mensagem_pck.get_texto(307420) || ': ' || nr_atendimento_p || ' ' || wheb_mensagem_pck.get_texto(802978) || ': ' || to_char(dt_entrada_w, ds_mascara_w) ||
					' ' || wheb_mensagem_pck.get_texto(802979) || ': ' || nr_prontuario_w || ' ' || wheb_mensagem_pck.get_texto(791350) || ': ' || nm_paciente_w  || ' ' || wheb_mensagem_pck.get_texto(802980) || ': ' || ds_justificativa_w,'N');
		else
			CALL gravar_log_exclusao('ATENDIMENTO_PACIENTE', nm_usuario_p,
					wheb_mensagem_pck.get_texto(307420) || ': ' || nr_atendimento_p || ' ' || wheb_mensagem_pck.get_texto(802978) || ': ' || to_char(dt_entrada_w, ds_mascara_w) ||
					' ' || wheb_mensagem_pck.get_texto(802979) || ': ' || nr_prontuario_w || ' ' || wheb_mensagem_pck.get_texto(791350) || ': ' || nm_paciente_w ,'N');
		end if;
		commit;
	end if;

	end;
end if;
ds_erro_p			:= ds_erro_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recep_excluir_atendimento ( nr_atendimento_p bigint, ie_consiste_p text, nm_usuario_p text, ds_justificativa_p text, ds_erro_p INOUT text) FROM PUBLIC;

