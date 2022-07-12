-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_carencia_after_update ON pls_carencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_carencia_after_update() RETURNS trigger AS $BODY$
declare

ds_alteracao_w	varchar(4000) := ' ';
ds_anterior_w	varchar(255);
ds_novo_w	varchar(255);

BEGIN
if	((NEW.nr_seq_grupo_carencia  <> OLD.nr_seq_grupo_carencia ) or (NEW.nr_seq_grupo_carencia  is not null and OLD.nr_seq_grupo_carencia is null) or (NEW.nr_seq_grupo_carencia is null and OLD.nr_seq_grupo_carencia is not null))then

	select 	substr(pls_obter_dados_grupo_carencia(NEW.nr_seq_grupo_carencia,'N'),1,255),
		substr(pls_obter_dados_grupo_carencia(OLD.nr_seq_grupo_carencia,'N'),1,255)
	into STRICT	ds_novo_w,
		ds_anterior_w
	;

	--Alteração do grupo de carência
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352337 , 'NR_CARENCIA_OLD=' || OLD.nr_seq_grupo_carencia||';'||'DS_CARENCIA_OLD='||ds_anterior_w||';'|| 'NR_CARENCIA_NEW='||NEW.nr_seq_grupo_carencia||';'||'DS_CARENCIA_NEW='||ds_novo_w);
end if;

if	((trunc(NEW.dt_fim_vig_plano,'DAY') <> trunc(OLD.dt_fim_vig_plano,'DAY')) or (NEW.dt_fim_vig_plano is not null  and OLD.dt_fim_vig_plano is null) or (NEW.dt_fim_vig_plano is null and OLD.dt_fim_vig_plano is not null))then

	--Alteração da data de fim de vigência do plano.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352340 , 'DT_CARENCIA_OLD=' ||OLD.dt_fim_vig_plano||';'||'DT_CARENCIA_NEW='||NEW.dt_fim_vig_plano);
end if;

if	((trunc(NEW.dt_inicio_vig_plano,'DAY') <> trunc(OLD.dt_inicio_vig_plano,'DAY')) or (NEW.dt_inicio_vig_plano is not null  and OLD.dt_inicio_vig_plano is null) or (NEW.dt_inicio_vig_plano is null and OLD.dt_inicio_vig_plano is not null))then

	--Alteração da data de início de vigência do plano.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352341 , 'DT_CARENCIA_OLD=' ||OLD.dt_inicio_vig_plano||';'||'DT_CARENCIA_NEW='||NEW.dt_inicio_vig_plano);
end if;

if 	((NEW.nr_seq_plano_contrato <> OLD.nr_seq_plano_contrato) or (NEW.nr_seq_plano_contrato is not null and OLD.nr_seq_plano_contrato is null) or (NEW.nr_seq_plano_contrato is null and OLD.nr_seq_plano_contrato is not null))then

	select 	substr(pls_obter_dados_produto(NEW.nr_seq_plano_contrato,'N'),1,255),
		substr(pls_obter_dados_produto(OLD.nr_seq_plano_contrato,'N'),1,255)
	into STRICT	ds_novo_w,
		ds_anterior_w
	;
	--Alteração do produto do contrato que a carência é válida.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352345 , 'NR_CARENCIA_OLD=' || OLD.nr_seq_plano_contrato ||';'||'DS_CARENCIA_OLD='||ds_anterior_w||';'|| 'NR_CARENCIA_NEW='||NEW.nr_seq_plano_contrato||';'||'DS_CARENCIA_NEW='||ds_novo_w);
end if;

if	((NEW.nr_seq_tipo_carencia <> OLD.nr_seq_tipo_carencia) or (NEW.nr_seq_tipo_carencia is not null and OLD.nr_seq_tipo_carencia is null) or (NEW.nr_seq_tipo_carencia is null and OLD.nr_seq_tipo_carencia is not null))then

	select	coalesce(max(ds_carencia),'')
	into STRICT	ds_anterior_w
	from	pls_tipo_carencia
	where	nr_sequencia	= OLD.nr_seq_tipo_carencia;

	select	coalesce(max(ds_carencia),'')
	into STRICT	ds_novo_w
	from	pls_tipo_carencia
	where	nr_sequencia	= NEW.nr_seq_tipo_carencia;

	--Alteração do tipo de carência do contrato.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352346 , 'NR_CARENCIA_OLD=' || OLD.nr_seq_tipo_carencia ||';'||'DS_CARENCIA_OLD='||ds_anterior_w||';'|| 'NR_CARENCIA_NEW='||NEW.nr_seq_tipo_carencia||';'||'DS_CARENCIA_NEW='||ds_novo_w);
end if;

if	((NEW.ds_observacao <> OLD.ds_observacao) or (NEW.ds_observacao is not null and OLD.ds_observacao is null) or (NEW.ds_observacao is null and OLD.ds_observacao is not null))then

	--Alteração da observação.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352348 , 'DS_OBSERVACAO_OLD=' ||OLD.ds_observacao||';'||'DS_OBSERVACAO_NEW='||NEW.ds_observacao);
end if;

if 	((NEW.qt_dias_fora_abrang_ant <> OLD.qt_dias_fora_abrang_ant) or (NEW.qt_dias_fora_abrang_ant is not null and OLD.qt_dias_fora_abrang_ant is null) or (NEW.qt_dias_fora_abrang_ant is null and OLD.qt_dias_fora_abrang_ant is not null))then

	--Alteração na contagem de dias fora abrangência anterior.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352350 , 'QT_DIAS_OLD=' ||OLD.qt_dias_fora_abrang_ant||';'||'QT_DIAS_NEW='||NEW.qt_dias_fora_abrang_ant);
end if;

if	((trunc(NEW.dt_fim_vigencia, 'DAY') <> trunc(OLD.dt_fim_vigencia,'DAY'))or (NEW.dt_fim_vigencia is not null and OLD.dt_fim_vigencia is null) or (NEW.dt_fim_vigencia is null and OLD.dt_fim_vigencia is not null))then

	--Alteração da data de fim de vigência para a carência.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352342 , 'DT_CARENCIA_OLD=' ||OLD.dt_fim_vigencia||';'||'DT_CARENCIA_NEW='||NEW.dt_fim_vigencia);
end if;

if 	((trunc(NEW.dt_inicio_vigencia,'DAY') <> trunc(OLD.dt_inicio_vigencia,'DAY')) or (NEW.dt_inicio_vigencia is not null and OLD.dt_inicio_vigencia is null) or (NEW.dt_inicio_vigencia is null and OLD.dt_inicio_vigencia is not null))then

	--Alteração da data de início de vigência para a carência.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352343 , 'DT_CARENCIA_OLD=' ||OLD.dt_inicio_vigencia||';'||'DT_CARENCIA_NEW='||NEW.dt_inicio_vigencia);
end if;

if (NEW.qt_dias <> OLD.qt_dias) then

	--Alteração da quantidade de dias para a regra de carência.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352351 , 'QT_DIAS_OLD=' ||OLD.qt_dias||';'||'QT_DIAS_NEW='||NEW.qt_dias);
end if;

if (NEW.ie_mes_posterior <> OLD.ie_mes_posterior) then

	select 	CASE WHEN NEW.ie_mes_posterior='S' THEN 'Sim' WHEN NEW.ie_mes_posterior='N' THEN 'Não'  ELSE ' ' END ,
		CASE WHEN OLD.ie_mes_posterior='S' THEN 'Sim' WHEN OLD.ie_mes_posterior='N' THEN 'Não'  ELSE ' ' END
	into STRICT	ds_novo_w,
		ds_anterior_w
	;

	--Alteração da vigência a partir do 1º dia do mês subsequente.
	ds_alteracao_w := ds_alteracao_w || wheb_mensagem_pck.get_texto(352353 , 'DS_OLD=' ||ds_anterior_w||';'||'DS_NEW='||ds_novo_w);
end if;

if (ds_alteracao_w	<> ' ') then
	insert into pls_carencia_log(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec, ds_alteracao, nr_seq_carencia)
	values (nextval('pls_carencia_log_seq'), LOCALTIMESTAMP, null,NEW.nm_usuario, null, ds_alteracao_w, OLD.nr_sequencia);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_carencia_after_update() FROM PUBLIC;

CREATE TRIGGER pls_carencia_after_update
	AFTER UPDATE ON pls_carencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_carencia_after_update();

