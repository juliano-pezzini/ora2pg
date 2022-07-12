-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS autorizacao_conv_etapa_update ON autorizacao_conv_etapa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_autorizacao_conv_etapa_update() RETURNS trigger AS $BODY$
declare
ds_titulo_w			varchar(255) 	:= wheb_mensagem_pck.get_texto(313582);
ds_historico_w			varchar(4000)	:= '';
dt_parametro_w			timestamp		:= trunc(LOCALTIMESTAMP) + 89399/89400;
ds_txt_campo_w			varchar(30) 	:= wheb_mensagem_pck.get_texto(182370); --Campo:
ds_txt_antes_w			varchar(30) 	:= wheb_mensagem_pck.get_texto(182371); -- - Antes:
ds_txt_depois_w			varchar(30) 	:= wheb_mensagem_pck.get_texto(182372); -- Depois:
BEGIN
  BEGIN

BEGIN
if (coalesce(NEW.vl_autorizacao,0) <> coalesce(OLD.vl_autorizacao,0)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' VL_AUTORIZACAO '|| ds_txt_antes_w ||' '|| OLD.vl_autorizacao ||' '||ds_txt_depois_w ||' '|| NEW.vl_autorizacao ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.nm_usuario_recebimento,0) <> coalesce(OLD.nm_usuario_recebimento,0)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' NM_USUARIO_RECEBIMENTO '|| ds_txt_antes_w ||' '|| OLD.nm_usuario_recebimento ||' '||ds_txt_depois_w ||' '|| NEW.nm_usuario_recebimento ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.dt_recebimento,dt_parametro_w) <> coalesce(OLD.dt_recebimento,dt_parametro_w)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' DT_RECEBIMENTO '|| ds_txt_antes_w ||' '|| to_char(OLD.dt_recebimento,'dd/mm/yyyy hh24:mi:ss') ||' '||ds_txt_depois_w ||' '|| to_char(NEW.dt_recebimento,'dd/mm/yyyy hh24:mi:ss') ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.cd_pessoa_exec,0) <> coalesce(OLD.cd_pessoa_exec,0)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' CD_PESSOA_EXEC '|| ds_txt_antes_w ||' '|| OLD.cd_pessoa_exec ||' '|| ds_txt_depois_w ||' '|| NEW.cd_pessoa_exec ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.dt_fim_vigencia,dt_parametro_w) <> coalesce(OLD.dt_fim_vigencia,dt_parametro_w)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' DT_FIM_VIGENCIA '|| ds_txt_antes_w ||' '|| to_char(OLD.dt_fim_vigencia,'dd/mm/yyyy hh24:mi:ss') ||' '||ds_txt_depois_w ||' '|| to_char(NEW.dt_fim_vigencia,'dd/mm/yyyy hh24:mi:ss') ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.dt_inicio_vigencia,dt_parametro_w) <> coalesce(OLD.dt_inicio_vigencia,dt_parametro_w)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' DT_INICIO_VIGENCIA '|| ds_txt_antes_w ||' '|| to_char(OLD.dt_inicio_vigencia,'dd/mm/yyyy hh24:mi:ss') ||' '||ds_txt_depois_w ||' '|| to_char(NEW.dt_inicio_vigencia,'dd/mm/yyyy hh24:mi:ss') ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.dt_fim_etapa,dt_parametro_w) <> coalesce(OLD.dt_fim_etapa,dt_parametro_w)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' DT_FIM_ETAPA '|| ds_txt_antes_w ||' '|| to_char(OLD.dt_fim_etapa,'dd/mm/yyyy hh24:mi:ss') ||' '||ds_txt_depois_w ||' '|| to_char(NEW.dt_fim_etapa,'dd/mm/yyyy hh24:mi:ss') ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.ds_observacao,0) <> coalesce(OLD.ds_observacao,0)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' DS_OBSERVACAO '|| ds_txt_antes_w ||' '|| OLD.ds_observacao ||' '||ds_txt_depois_w ||' '|| NEW.ds_observacao ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.cd_setor_atendimento,0) <> coalesce(OLD.cd_setor_atendimento,0)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' CD_SETOR_ATENDIMENTO '|| ds_txt_antes_w ||' '|| OLD.cd_setor_atendimento ||' '||ds_txt_depois_w ||' '|| NEW.cd_setor_atendimento ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.nr_seq_etapa,0) <> coalesce(OLD.nr_seq_etapa,0)) then
	ds_historico_w := substr(ds_historico_w||ds_txt_campo_w || ' NR_SEQ_ETAPA '|| ds_txt_antes_w ||' '|| OLD.nr_seq_etapa ||' '||ds_txt_depois_w ||' '|| NEW.nr_seq_etapa ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.nr_seq_autor_cir,0) <> coalesce(OLD.nr_seq_autor_cir,0)) then
	ds_historico_w  := substr(ds_historico_w||ds_txt_campo_w || ' NR_SEQ_AUTOR_CIR '|| ds_txt_antes_w ||' '|| OLD.nr_seq_autor_cir ||' '||ds_txt_depois_w ||' '|| NEW.nr_seq_autor_cir ||chr(13)||chr(10),1,4000);
end if;
if (coalesce(NEW.dt_etapa,dt_parametro_w) <> coalesce(OLD.dt_etapa,dt_parametro_w)) then
	ds_historico_w  := substr(ds_historico_w||ds_txt_campo_w || ' DT_ETAPA '|| ds_txt_antes_w ||' '|| to_char(OLD.dt_etapa,'dd/mm/yyyy hh24:mi:ss') ||' '||ds_txt_depois_w ||' '|| to_char(NEW.dt_etapa,'dd/mm/yyyy hh24:mi:ss') ||chr(13)||chr(10),1,4000);
end if;
exception
when others then
	ds_historico_w := 'X';
end;

if (coalesce(ds_historico_w,'X') <> 'X') then
	CALL gravar_autor_conv_log_alter(NEW.nr_seq_autor_conv,ds_titulo_w,substr(ds_historico_w,1,2000),NEW.nm_usuario);
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_autorizacao_conv_etapa_update() FROM PUBLIC;

CREATE TRIGGER autorizacao_conv_etapa_update
	AFTER UPDATE ON autorizacao_conv_etapa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_autorizacao_conv_etapa_update();

