-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS result_laboratorio_insert ON result_laboratorio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_result_laboratorio_insert() RETURNS trigger AS $BODY$
DECLARE

ie_conta_lab_ext_w		varchar(1);
ie_laudo_texto_w		varchar(1);
ie_status_baixa_w		smallint;
cd_estabelecimento_w		integer;
nr_seq_exame_w			bigint;
ie_atual_status_integracao_w	varchar(1);
ie_atual_status_exec_laudo_w	varchar(1);
ie_existe_w			varchar(1);
cd_material_exame_w		material_exame_lab.cd_material_exame%type;
qt_exame_w 			bigint;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
ds_codigo_prof_w		pessoa_fisica.ds_codigo_prof%type;
cd_medico_resp_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_medico_exec_w		prescr_procedimento.cd_medico_exec%type;
cd_medico_w				prescr_medica.cd_medico%type;
ie_atualiza_data_coleta_w	lab_parametro.ie_atualiza_data_coleta%type;

c01 CURSOR FOR
	SELECT	a.nr_seq_evento
	from	regra_envio_sms a
	where	a.ie_evento_disp = 'APRPRPI'
	and	coalesce(a.ie_situacao,'A') = 'A';
	
c01_w	c01%rowtype;
	
BEGIN

if (NEW.nr_seq_resultado is not null) then

	NEW.IE_COBRANCA := 'N';
else
	if (NEW.NR_PRESCRICAO is null) then
		--'O campo prescricao deve ser informado !

		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(1061479);
	end if;

	if (NEW.NR_SEQ_PRESCRICAO is null) then
		--'O campo sequencia deve ser informado !

		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(1061480);
	end if;

	if (NEW.IE_COBRANCA is null) then
		--'The billing field must be filled in !

		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(1061482);
	end if;

end if;

NEW.ie_status_conversao := 0;

if coalesce(NEW.nr_sequencia, 0) <= 0 then
	select nextval('result_laboratorio_seq')
	into STRICT NEW.nr_sequencia
	;
end if;

NEW.dt_atualizacao	:= LOCALTIMESTAMP;
if (NEW.nm_usuario is null) then
	NEW.nm_usuario	:= wheb_mensagem_pck.get_texto(309720); -- Laboratory
end if;

select	coalesce(max(nr_seq_exame),null),
	coalesce(max(cd_procedimento),NEW.cd_procedimento),
	coalesce(max(ie_origem_proced),NEW.ie_origem_proced),
	MAX(cd_medico_exec)
into STRICT	nr_seq_exame_w,
	NEW.cd_procedimento,
	NEW.ie_origem_proced,
	cd_medico_exec_w
from	prescr_procedimento
where 	nr_prescricao	= NEW.nr_prescricao
  and	nr_sequencia	= NEW.nr_seq_prescricao;

select	coalesce(max(ie_conta_lab_ext),'N'),
	coalesce(max(ie_laudo_texto),'N'),
	coalesce(max(ie_status_baixa_integ),max(ie_status_baixa),99),
	coalesce(max(c.cd_estabelecimento),1),
	coalesce(max(ie_atual_status_integracao),'N'),
	coalesce(max(ie_atualiza_status_exec_laudo),'N'),
	MAX(a.cd_medico),
	MAX(coalesce(c.ie_atualiza_data_coleta,'N'))
into STRICT	ie_conta_lab_ext_w,
	ie_laudo_texto_w,
	ie_status_baixa_w,
	cd_estabelecimento_w,
	ie_atual_status_integracao_w,
	ie_atual_status_exec_laudo_w,
	cd_medico_w,
	ie_atualiza_data_coleta_w
from 	Lab_parametro c,
	Atendimento_paciente b,
	prescr_medica a
where	a.nr_prescricao		= NEW.nr_prescricao
  and a.nr_atendimento		= b.nr_atendimento
  and	b.cd_estabelecimento	= c.cd_estabelecimento;

if (NEW.IE_COBRANCA = 'S') and
	((ie_conta_lab_ext_w = 'R') or (ie_conta_lab_ext_w = 'E' and lab_obter_regra_fatur(cd_estabelecimento_w, nr_seq_exame_w) = 'R')) then
	CALL Gerar_Proc_Pac_Prescricao(NEW.nr_prescricao, NEW.nr_seq_prescricao, 0, 0, NEW.nm_usuario, null, null,null);
end if;


if (coalesce(NEW.ie_final,'S') = 'S') then

	update prescr_procedimento
	set	cd_motivo_baixa		= 1,
			dt_baixa 		= LOCALTIMESTAMP,
		ie_status_atend		= 40,
		ie_status_execucao	= CASE WHEN ie_atual_status_exec_laudo_w='S' THEN '40'  ELSE ie_status_execucao END ,
		nm_usuario		= NEW.nm_usuario,
		dt_atualizacao		= LOCALTIMESTAMP,
		dt_coleta		= CASE WHEN ie_atualiza_data_coleta_w='S' THEN  coalesce(NEW.dt_coleta, dt_coleta)  ELSE dt_coleta END
	where nr_prescricao		= NEW.nr_prescricao
	  and nr_sequencia		= NEW.nr_seq_prescricao
	  and cd_motivo_baixa	= 0
	  and ie_status_atend	= CASE WHEN ie_status_baixa_w=99 THEN ie_status_atend  ELSE ie_status_baixa_w END;
	
	if (coalesce(ie_atual_status_integracao_w,'N') = 'S') then
		update prescr_procedimento
		set	ie_status_atend	= 40,
			ie_status_execucao	= CASE WHEN ie_atual_status_exec_laudo_w='S' THEN '40'  ELSE ie_status_execucao END ,
			nm_usuario		= NEW.nm_usuario			
		where nr_prescricao		= NEW.nr_prescricao
		  and nr_sequencia		= NEW.nr_seq_prescricao
		  and ie_status_atend	= CASE WHEN ie_status_baixa_w=99 THEN ie_status_atend  ELSE ie_status_baixa_w END 
		  and dt_integracao is not null;
	end if;
	if (NEW.nr_prescricao is not null) then
		open C01;
		loop
		fetch C01 into	
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			BEGIN
			
			select	count(*)
			into STRICT	qt_exame_w
			from	prescr_procedimento a,
					prescr_medica b
			where	a.ie_status_atend >= 35
			and	a.nr_prescricao = b.nr_prescricao
			and	b.nr_prescricao = NEW.nr_prescricao
			and	a.nr_sequencia 	<> NEW.nr_seq_prescricao;
			
			if (qt_exame_w = 0) then
				
				cd_medico_resp_w := coalesce(cd_medico_exec_w,cd_medico_w);
				
				if (NEW.nm_usuario is not null) then
					select	coalesce(max(cd_pessoa_fisica),null)
					into STRICT	cd_pessoa_fisica_w
					from	usuario
					where	upper(nm_usuario) = upper(NEW.nm_usuario);
					
					if (cd_pessoa_fisica_w is not null) then
						select 	coalesce(max(substr(obter_crm_medico(cd_pessoa_fisica),1, 255)),'')
						into STRICT	ds_codigo_prof_w
						from 	medico
						where 	cd_pessoa_fisica = cd_pessoa_fisica_w;
						
						select 	coalesce(max(ds_codigo_prof), ds_codigo_prof_w)
						into STRICT	ds_codigo_prof_w
						from 	pessoa_fisica
						where 	cd_pessoa_fisica = cd_pessoa_fisica_w
						and (length(ds_codigo_prof_w) = 0 or ds_codigo_prof_w is null);
						
						if (ds_codigo_prof_w is not null) then
							cd_medico_resp_w := cd_pessoa_fisica_w;
						end if;
					end if;
				end if;
				CALL gerar_evento_aprov_res_atend(c01_w.nr_seq_evento,NEW.nm_usuario, NEW.nr_prescricao, NEW.nr_seq_prescricao, nr_seq_exame_w, 'S', LOCALTIMESTAMP, cd_medico_resp_w);		
			end if;	
			
			end;
		end loop;
		close C01;
	end if;
	if (ie_atualiza_data_coleta_w = 'S') and (NEW.dt_coleta is not null ) then
		
		update  prescr_procedimento
		set		dt_coleta = NEW.dt_coleta,
				nm_usuario = NEW.nm_usuario,
				dt_atualizacao = LOCALTIMESTAMP
		where   nr_prescricao  = NEW.nr_prescricao
		and		nr_sequencia   = NEW.nr_seq_prescricao;
	
	end if;
	
elsif (coalesce(NEW.ie_final,'S') = 'N') then

	update 	prescr_procedimento
	set	ie_status_atend		= 30		
	where	nr_prescricao		= NEW.nr_prescricao
	and 	nr_sequencia		= NEW.nr_seq_prescricao;
	
end if;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_existe_w
from	prescr_procedimento a
where	nr_prescricao		= NEW.nr_prescricao
and 	nr_sequencia		= NEW.nr_seq_prescricao
and	coalesce(ie_result_lab_gerado,'N') = 'N';

if (ie_existe_w = 'S') then

	/*if	(wheb_usuario_pck.is_evento_ativo(221) = 'S') then	
	
		select	max(b.cd_material_exame)
		into	cd_material_exame_w
		from	prescr_medica a,
			prescr_procedimento b
		where	a.nr_prescricao = b.nr_prescricao 
		and	b.nr_prescricao = :new.nr_prescricao
		and 	b.nr_sequencia	= :new.nr_seq_prescricao;
		
		select	decode(count(*),0,'N','S')
		into	ie_existe_w
		from	lab_tasylab_cli_prescr a
		where	a.nr_prescricao = :new.nr_prescricao;
		
		if	(ie_existe_w = 'S') then		
			integrar_tasylab(	:new.nr_prescricao,
						:new.nr_seq_prescricao,
						221,
						cd_material_exame_w,
						null,
						wheb_usuario_pck.get_cd_funcao,
						obter_perfil_ativo,
						wheb_usuario_pck.get_nm_usuario,
						wheb_usuario_pck.get_cd_estabelecimento,
						null,
						null,
						'N'); --Evitar commit na trigger.
		end if;
	end if;*/


	update 	prescr_procedimento
	set	ie_result_lab_gerado = 'S'
	where	nr_prescricao		= NEW.nr_prescricao
	and 	nr_sequencia		= NEW.nr_seq_prescricao
	and	coalesce(ie_result_lab_gerado,'N') = 'N';
end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_result_laboratorio_insert() FROM PUBLIC;

CREATE TRIGGER result_laboratorio_insert
	BEFORE INSERT ON result_laboratorio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_result_laboratorio_insert();

