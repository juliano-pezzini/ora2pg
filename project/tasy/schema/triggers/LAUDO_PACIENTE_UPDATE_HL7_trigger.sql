-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS laudo_paciente_update_hl7 ON laudo_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_laudo_paciente_update_hl7() RETURNS trigger AS $BODY$
declare
ds_sep_bv_w		varchar(100);
ds_param_integ_hl7_w	varchar(4000);
cd_pessoa_fisica_w	varchar(60);
nr_seq_interno_w	bigint;
nr_seq_prescricao_w	bigint;
cd_estabelecimento_w	bigint;
ie_forma_aprovar_w	varchar(10);
ie_permite_proc_isite_w varchar(2);
ie_permite_proc_pacs   	varchar(2);
nr_seq_proc_interno_w	bigint;
ie_status_result_w	varchar(2) := 'F';
nr_prescricao_w		bigint;
ie_envia_vinculados_w	varchar(1) := 'N';



C01 CURSOR FOR  -- OS 669701 / tratar o envio do laudo para os procedimentos vinculados
SELECT A.NR_PRESCRICAO, A.NR_SEQUENCIA_PRESCRICAO
  FROM PROCEDIMENTO_PACIENTE A
 WHERE A.NR_LAUDO = NEW.nr_sequencia
   AND A.NR_SEQUENCIA <>
       (SELECT MAX(B.NR_SEQUENCIA)
          FROM PROCEDIMENTO_PACIENTE B
         WHERE A.NR_PRESCRICAO = B.NR_PRESCRICAO
           AND A.NR_SEQUENCIA_PRESCRICAO = B.NR_SEQUENCIA_PRESCRICAO)
 ORDER BY A.NR_SEQUENCIA;


BEGIN

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento = NEW.nr_atendimento;

ie_forma_aprovar_w := coalesce(Obter_Valor_Param_Usuario(28, 47, Obter_Perfil_Ativo, NEW.nm_usuario, cd_estabelecimento_w),'N');

if	((ie_forma_aprovar_w = 'A') and (OLD.dt_aprovacao is null) and (NEW.dt_aprovacao is not null)) or
	((ie_forma_aprovar_w = 'L') and (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null)) or
	((ie_forma_aprovar_w = 'S') and ((OLD.dt_seg_aprovacao is null AND NEW.dt_seg_aprovacao is not null) or
											((OLD.dt_aprovacao is null) and (NEW.dt_aprovacao is not null) and (NEW.dt_seg_aprovacao is null)))) then
	
	if (ie_forma_aprovar_w = 'S')  and ((OLD.dt_aprovacao is null) and (NEW.dt_aprovacao is not null) and (NEW.dt_seg_aprovacao is null)) then
		if (NEW.nr_seq_superior is null) then	
			ie_status_result_w := 'P';
		else
			ie_status_result_w := 'C';
		end if;
	end if;
	
	
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	prescr_medica
	where	nr_prescricao 	= NEW.nr_prescricao;
	
	select	max(obter_atepacu_paciente( NEW.nr_atendimento ,'A'))
	into STRICT	nr_seq_interno_w
	;
	
	select	max(nr_sequencia_prescricao)
	into STRICT	nr_seq_prescricao_w
	from	procedimento_paciente
	where	nr_sequencia	= NEW.nr_seq_proc;
	
	select	max(x.nr_seq_proc_interno)
	into STRICT	nr_seq_proc_interno_w
	from 	prescr_procedimento x
	where	x.nr_prescricao = NEW.nr_prescricao
	and	x.nr_sequencia 	= nr_seq_prescricao_w;
	
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_permite_proc_pacs	
	from	proc_interno_integracao a	
	where	a.nr_seq_proc_interno = nr_seq_proc_interno_w
	and	coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
	and	a.nr_seq_sistema_integ in (11,66);
	
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_permite_proc_isite_w
	from	regra_proc_interno_integra
	where	nr_seq_proc_interno	= nr_seq_proc_interno_w
	and	ie_tipo_integracao	= 2
	and	cd_integracao 		is not null;
	
	if	((ie_permite_proc_pacs = 'S') or (ie_permite_proc_isite_w = 'S' AND ie_status_result_w = 'F')) then
		
		ds_sep_bv_w := obter_separador_bv;
		
		ie_envia_vinculados_w	:=	'S';
		
		ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || cd_pessoa_fisica_w  || ds_sep_bv_w ||
					'nr_atendimento='   || NEW.nr_atendimento || ds_sep_bv_w ||
					'nr_seq_interno='   || nr_seq_interno_w    || ds_sep_bv_w ||
					'nr_prescricao='    || NEW.nr_prescricao  || ds_sep_bv_w ||
					'nr_seq_prescr='    || nr_seq_prescricao_w || ds_sep_bv_w || 	
					'nr_seq_laudo='     || NEW.nr_sequencia   || ds_sep_bv_w ||
					'ie_status_result=' || ie_status_result_w  || ds_sep_bv_w;
					
			
		CALL gravar_agend_integracao(24, ds_param_integ_hl7_w);	
		
	end if;	
	
	if (ie_envia_vinculados_w = 'S') then
		BEGIN
		open C01;
		loop
		fetch C01 into	
			nr_prescricao_w,
			nr_seq_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			BEGIN
			
			select	max(x.nr_seq_proc_interno)
			into STRICT	nr_seq_proc_interno_w
			from 	prescr_procedimento x
			where	x.nr_prescricao = nr_prescricao_w
			and	x.nr_sequencia 	= nr_seq_prescricao_w;		
			
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_permite_proc_pacs	
			from	proc_interno_integracao a	
			where	a.nr_seq_proc_interno = nr_seq_proc_interno_w
			and	coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
			and	a.nr_seq_sistema_integ in (11,66);
			
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_permite_proc_isite_w
			from	regra_proc_interno_integra
			where	nr_seq_proc_interno	= nr_seq_proc_interno_w
			and	ie_tipo_integracao	= 2
			and	cd_integracao 		is not null;
			
			if	((ie_permite_proc_pacs = 'S') or (ie_permite_proc_isite_w = 'S') and (NEW.dt_liberacao is not null)) then
				
				ds_sep_bv_w := obter_separador_bv;
				
								
				ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || cd_pessoa_fisica_w  || ds_sep_bv_w ||
							'nr_atendimento='   || NEW.nr_atendimento || ds_sep_bv_w ||
							'nr_seq_interno='   || nr_seq_interno_w    || ds_sep_bv_w ||
							'nr_prescricao='    || nr_prescricao_w     || ds_sep_bv_w ||
							'nr_seq_prescr='    || nr_seq_prescricao_w || ds_sep_bv_w || 	
							'nr_seq_laudo='     || NEW.nr_sequencia   || ds_sep_bv_w ||
							'ie_status_result=' || ie_status_result_w  || ds_sep_bv_w;
							
					
				CALL gravar_agend_integracao(24, ds_param_integ_hl7_w);	
				
			end if;			
			
			
			end;
		end loop;
		close C01;	
		end;
	end if;				
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_laudo_paciente_update_hl7() FROM PUBLIC;

CREATE TRIGGER laudo_paciente_update_hl7
	AFTER UPDATE ON laudo_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_laudo_paciente_update_hl7();
