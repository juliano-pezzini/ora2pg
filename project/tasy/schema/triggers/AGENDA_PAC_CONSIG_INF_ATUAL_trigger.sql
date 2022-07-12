-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_pac_consig_inf_atual ON agenda_pac_consig_inf CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_pac_consig_inf_atual() RETURNS trigger AS $BODY$
declare
ds_alteracao_w		varchar(4000);
ds_inclusao_w		varchar(255);
cme_preparado_w		varchar(255);
nr_seq_agenda_w		agenda_pac_consignado.nr_seq_agenda%type;
solicitacao_medica_w	varchar(255);

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
select max(nr_seq_agenda),
	max(ds_material)
into STRICT   nr_seq_agenda_w,
	solicitacao_medica_w
from   agenda_pac_consignado
where  nr_sequencia = NEW.nr_seq_age_consig;


if (TG_OP = 'UPDATE') then
	if	 coalesce(OLD.DS_OBSERVACAO,'XPTO') <> coalesce(NEW.DS_OBSERVACAO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'C') then					
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791569,
							'DS_OBSERVACAO_OLD='||OLD.DS_OBSERVACAO ||
							';DS_OBSERVACAO_NEW='||NEW.DS_OBSERVACAO ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);										
					
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AC',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;	
	
	if (coalesce(OLD.ie_tipo_informacao,'X') = 'M') then
	
		if	 coalesce(OLD.DS_OBSERVACAO,'XPTO') <> coalesce(NEW.DS_OBSERVACAO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'M') then
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791569,
								'DS_OBSERVACAO_OLD='||OLD.DS_OBSERVACAO ||
								';DS_OBSERVACAO_NEW='||NEW.DS_OBSERVACAO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);										
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ACM',ds_alteracao_w,NEW.nm_usuario);
			end if;	
		end if;
	
		if	 coalesce(OLD.IE_DISPENSADO,'XPTO') <> coalesce(NEW.IE_DISPENSADO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'M') then						
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791570,
								'IE_DISPENSADO_OLD='||OLD.IE_DISPENSADO ||
								';IE_DISPENSADO_NEW='||NEW.IE_DISPENSADO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);												
						
		if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ACM',ds_alteracao_w,NEW.nm_usuario);
			end if;				
	
		end if;	
		
		if	 coalesce(OLD.ds_cme_preparado,'XPTO') <> coalesce(NEW.ds_cme_preparado,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'M') then					
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791571,
								'DS_CME_PREPARADO_OLD='||OLD.ds_cme_preparado ||
								';DS_CME_PREPARADO_NEW='||NEW.ds_cme_preparado ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ACM',ds_alteracao_w,NEW.nm_usuario);
			end if;	
		end if;
		
	end if;
	
	
	if	 coalesce(OLD.DS_OBSERVACAO,'XPTO') <> coalesce(NEW.DS_OBSERVACAO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'A') then					
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791569,
								'DS_OBSERVACAO_OLD='||OLD.DS_OBSERVACAO ||
								';DS_OBSERVACAO_NEW='||NEW.DS_OBSERVACAO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AAG',ds_alteracao_w,NEW.nm_usuario);
			end if;	
	end if;
	
	
	if	 coalesce(OLD.DS_OBSERVACAO,'XPTO') <> coalesce(NEW.DS_OBSERVACAO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'E') then				
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791569,
								'DS_OBSERVACAO_OLD='||OLD.DS_OBSERVACAO ||
								';DS_OBSERVACAO_NEW='||NEW.DS_OBSERVACAO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AE',ds_alteracao_w,NEW.nm_usuario);
			end if;	
	end if;
	
	
	if (coalesce(OLD.ie_tipo_informacao,'X') = 'F') then
	
		if	 coalesce(OLD.DS_OBSERVACAO,'XPTO') <> coalesce(NEW.DS_OBSERVACAO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'F') then					
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791569,
								'DS_OBSERVACAO_OLD='||OLD.DS_OBSERVACAO ||
								';DS_OBSERVACAO_NEW='||NEW.DS_OBSERVACAO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AF',ds_alteracao_w,NEW.nm_usuario);
			end if;	
		end if;
		
		if	 coalesce(OLD.QT_MATERIAL,'-1') <> coalesce(NEW.QT_MATERIAL,'-1') and (coalesce(OLD.ie_tipo_informacao,'X') = 'F') then
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791572,
								'QT_MATERIAL_OLD='||OLD.QT_MATERIAL ||
								';QT_MATERIAL_NEW='||NEW.QT_MATERIAL ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AF',ds_alteracao_w,NEW.nm_usuario);
			end if;					
		end if;	
	
		if	 coalesce(OLD.IE_DISPENSADO,'XPTO') <> coalesce(NEW.IE_DISPENSADO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'F') then						
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791575,
								'IE_DISPENSADO_OLD='||OLD.IE_DISPENSADO ||
								';IE_DISPENSADO_OLD_NEW='||NEW.IE_DISPENSADO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);						
						
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AF',ds_alteracao_w,NEW.nm_usuario);
			end if;				
	
		end if;			
	end if;
	
	if (coalesce(OLD.ie_tipo_informacao,'X') = 'R') then
	
		if	 coalesce(OLD.DS_OBSERVACAO,'XPTO') <> coalesce(NEW.DS_OBSERVACAO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'R') then					
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791569,
								'DS_OBSERVACAO_OLD='||OLD.DS_OBSERVACAO ||
								';DS_OBSERVACAO_NEW='||NEW.DS_OBSERVACAO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AR',ds_alteracao_w,NEW.nm_usuario);
			end if;	
		end if;
		
		if	 coalesce(OLD.QT_MATERIAL,'-1') <> coalesce(NEW.QT_MATERIAL,'-1') and (coalesce(OLD.ie_tipo_informacao,'X') = 'R') then					
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791572,
								'QT_MATERIAL_OLD='||OLD.QT_MATERIAL ||
								';QT_MATERIAL_NEW='||NEW.QT_MATERIAL ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
					
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AR',ds_alteracao_w,NEW.nm_usuario);
			end if;					
		end if;	
	
		if	 coalesce(OLD.IE_DISPENSADO,'XPTO') <> coalesce(NEW.IE_DISPENSADO,'XPTO') and (coalesce(OLD.ie_tipo_informacao,'X') = 'R') then						
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791576,
								'IE_DISPENSADO_OLD='||OLD.IE_DISPENSADO ||
								';IE_DISPENSADO_NEW='||NEW.IE_DISPENSADO ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);						
						
			if (ds_alteracao_w is not null) then
				CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'AR',ds_alteracao_w,NEW.nm_usuario);
			end if;				
	
		end if;			
	end if;
	
	if	coalesce(OLD.QT_MATERIAL,'-1') <> coalesce(NEW.QT_MATERIAL,'-1') and (coalesce(OLD.ie_tipo_informacao,'X') = 'DE') then					
			ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791572,
								'QT_MATERIAL_OLD='||OLD.QT_MATERIAL ||
								';QT_MATERIAL_NEW='||NEW.QT_MATERIAL ||
								';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
				
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ADE',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'RE') then
		
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791577,
							'IE_RETIRADA_OLD='||OLD.ie_retirada ||
							';IE_RETIRADA_NEW='||NEW.ie_retirada ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ARE',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if	coalesce(OLD.QT_MATERIAL,'-1') <> coalesce(NEW.QT_MATERIAL,'-1') and (coalesce(OLD.ie_tipo_informacao,'X') = 'DI') then				
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791572,
							'QT_MATERIAL_OLD='||OLD.QT_MATERIAL ||
							';QT_MATERIAL_NEW='||NEW.QT_MATERIAL ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
				
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ADI',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if	coalesce(OLD.QT_MATERIAL,'-1') <> coalesce(NEW.QT_MATERIAL,'-1') and (coalesce(OLD.ie_tipo_informacao,'X') = 'CO') then					
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791572,
							'QT_MATERIAL_OLD='||OLD.QT_MATERIAL ||
							';QT_MATERIAL_NEW='||NEW.QT_MATERIAL ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);					
				
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ACO',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	
		
elsif (NEW.NR_SEQ_ANTERIOR is null) then
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'C') then
		ds_inclusao_w := substr(NEW.DS_OBSERVACAO,1,255);		
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791578,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IC',ds_alteracao_w,NEW.nm_usuario);
		end if;
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'M') then
	
		ds_inclusao_w := substr(NEW.DS_OBSERVACAO,1,255);
		cme_preparado_w := substr(NEW.ds_cme_preparado,1,255);
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791579,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_CME_PREPARADO='||cme_preparado_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ICM',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'A') then
	
		ds_inclusao_w := substr(NEW.DS_OBSERVACAO,1,255);
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791578,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IAG',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'E') then
	
		ds_inclusao_w := substr(NEW.DS_OBSERVACAO,1,255);		
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791578,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IE',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'F') then
	
		ds_inclusao_w := substr(NEW.DS_OBSERVACAO,1,255);
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791580,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IF',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'R') then
	
		ds_inclusao_w := substr(NEW.DS_OBSERVACAO,1,255);	
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791580,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IR',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'DE') then
	
		ds_inclusao_w := substr(NEW.qt_material,1,255);		
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791581,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IDE',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'DI') then
	
		ds_inclusao_w := substr(NEW.qt_material,1,255);		
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791581,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IDI',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'CO') then
	
		ds_inclusao_w := substr(NEW.qt_material,1,255);		
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791581,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'ICO',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
	
	if (coalesce(NEW.ie_tipo_informacao,'X') = 'RE') then
	
		ds_inclusao_w := substr(NEW.IE_RETIRADA,1,255);	
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(791582,
							'DS_INCLUSAO='||ds_inclusao_w ||
							';DS_SOLIC_MEDICA='||solicitacao_medica_w),1,4000);		
		
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(nr_seq_agenda_w,'IRE',ds_alteracao_w,NEW.nm_usuario);
		end if;	
	end if;
		
end if;	
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_pac_consig_inf_atual() FROM PUBLIC;

CREATE TRIGGER agenda_pac_consig_inf_atual
	BEFORE INSERT OR UPDATE ON agenda_pac_consig_inf FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_pac_consig_inf_atual();
