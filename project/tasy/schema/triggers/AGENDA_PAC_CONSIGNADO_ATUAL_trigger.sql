-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_pac_consignado_atual ON agenda_pac_consignado CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_pac_consignado_atual() RETURNS trigger AS $BODY$
declare
ds_alteracao_w		varchar(4000);
ds_solic_medica_w	varchar(255);
qt_registro_w		bigint;

expressao1_w	varchar(255) := obter_desc_expressao_idioma(342700, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao2_w	varchar(255) := obter_desc_expressao_idioma(773913, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao3_w	varchar(255) := obter_desc_expressao_idioma(773915, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao4_w	varchar(255) := obter_desc_expressao_idioma(618484, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao5_w	varchar(255) := obter_desc_expressao_idioma(622382, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao6_w	varchar(255) := obter_desc_expressao_idioma(773916, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao7_w	varchar(255) := obter_desc_expressao_idioma(773917, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao8_w	varchar(255) := obter_desc_expressao_idioma(310214, null, wheb_usuario_pck.get_nr_seq_idioma);--de
expressao9_w	varchar(255) := obter_desc_expressao_idioma(773921, null, wheb_usuario_pck.get_nr_seq_idioma);--
expressao10_w	varchar(255) := obter_desc_expressao_idioma(773922, null, wheb_usuario_pck.get_nr_seq_idioma);--Foi alterada a observação do material
expressao11_w	varchar(255) := obter_desc_expressao_idioma(318357, null, wheb_usuario_pck.get_nr_seq_idioma);--nula
expressao12_w	varchar(255) := obter_desc_expressao_idioma(773923, null, wheb_usuario_pck.get_nr_seq_idioma);--para a observação
expressao13_w	varchar(255) := obter_desc_expressao_idioma(773924, null, wheb_usuario_pck.get_nr_seq_idioma);--Realizada a inclusão do material
BEGIN

if (TG_OP = 'UPDATE') then
	if (coalesce(OLD.DS_MATERIAL,'XPTO') <> coalesce(NEW.DS_MATERIAL,'XPTO')) then
		ds_alteracao_w	:=	substr(expressao1_w || ' ' ||OLD.DS_MATERIAL|| ' ' ||
					expressao2_w || ' ' ||NEW.DS_MATERIAL,1,4000);
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(NEW.nr_seq_agenda,'AS',ds_alteracao_w,NEW.nm_usuario);
		end if;
	end if;

	if (coalesce(OLD.IE_PERMANENTE,'N') <> coalesce(NEW.IE_PERMANENTE,'N')) then
		ds_alteracao_w	:=	substr(expressao3_w || ' ' ||NEW.DS_MATERIAL||' ' || expressao8_w|| ' ' ||coalesce(OLD.IE_PERMANENTE,'N')|| ' ' ||
					expressao4_w || ' ' ||coalesce(NEW.IE_PERMANENTE,'N'),1,4000);
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(NEW.nr_seq_agenda,'AS',ds_alteracao_w,NEW.nm_usuario);
		end if;
	end if;


	if (coalesce(OLD.QT_QUANTIDADE,'-1') <> coalesce(NEW.QT_QUANTIDADE,'-1')) then
		ds_alteracao_w	:=	substr(expressao5_w || ' ' ||NEW.DS_MATERIAL||' ' || expressao8_w|| ' ' ||OLD.QT_QUANTIDADE|| ' ' ||
					expressao6_w || ' ' ||NEW.QT_QUANTIDADE,1,4000);
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(NEW.nr_seq_agenda,'AS',ds_alteracao_w,NEW.nm_usuario);
		end if;
	end if;

	if (coalesce(OLD.DS_FORNECEDOR,'XPTO') <> coalesce(NEW.DS_FORNECEDOR,'XPTO')) then
		ds_alteracao_w	:=	substr(expressao7_w || ' ' ||NEW.DS_MATERIAL||' ' || expressao8_w|| ' ' ||OLD.DS_FORNECEDOR|| ' ' ||
					expressao9_w || ' ' ||NEW.DS_FORNECEDOR,1,4000);
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(NEW.nr_seq_agenda,'AS',ds_alteracao_w,NEW.nm_usuario);
		end if;
	end if;

	if (coalesce(OLD.ds_observacao,'X') <> coalesce(NEW.ds_observacao,'X')) then
		ds_alteracao_w	:=	substr(expressao10_w || ' ' ||NEW.DS_MATERIAL||' ' || expressao8_w|| ' ' ||coalesce(OLD.ds_observacao,expressao11_w)|| ' ' ||
					expressao12_w || ' ' ||coalesce(NEW.ds_observacao,expressao11_w),1,4000);
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(NEW.nr_seq_agenda,'AS',ds_alteracao_w,NEW.nm_usuario);
		end if;
	end if;

else
	if (NEW.NR_SEQ_ANTERIOR is null) then
		ds_solic_medica_w 	:= 	substr(NEW.DS_MATERIAL,1,255);
		ds_alteracao_w		:=	substr(expressao13_w || ' ' ||ds_solic_medica_w,1,4000);
		if (ds_alteracao_w is not null) then
			CALL gravar_hist_planeja_consig(NEW.nr_seq_agenda,'IS',ds_alteracao_w,NEW.nm_usuario);
		end if;
	end if;
end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_pac_consignado_atual() FROM PUBLIC;

CREATE TRIGGER agenda_pac_consignado_atual
	BEFORE INSERT OR UPDATE ON agenda_pac_consignado FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_pac_consignado_atual();
