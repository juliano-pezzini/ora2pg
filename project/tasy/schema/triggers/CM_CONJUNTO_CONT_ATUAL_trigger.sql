-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cm_conjunto_cont_atual ON cm_conjunto_cont CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cm_conjunto_cont_atual() RETURNS trigger AS $BODY$
declare
ds_status_ant_w		varchar(255);
ds_status_novo_w		varchar(255);
ds_local_estoque_w	varchar(255);
ds_equipamento_w		varchar(255);
nr_seq_equipamento_w	cm_equipamento.nr_sequencia%type;
ie_se_conjunto_equip_w	varchar(1);

BEGIN

if (coalesce(OLD.DT_ORIGEM,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_ORIGEM) and (NEW.DT_ORIGEM is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_ORIGEM, 'HV');	
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

if (NEW.ie_status_conjunto <> OLD.ie_status_conjunto) then
	BEGIN
	
	select	substr(obter_valor_dominio(403,OLD.ie_status_conjunto),1,255),
		substr(obter_valor_dominio(403,NEW.ie_status_conjunto),1,255)
	into STRICT	ds_status_ant_w,
		ds_status_novo_w
	;
	
	CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311255,'DS_STATUS_ANT='||ds_status_ant_w||';DS_STATUS_NOVO='||ds_status_novo_w),NEW.nm_usuario);
	
	update	cm_expurgo_retirada
	set	ie_status = NEW.ie_status_conjunto
	where	nr_conjunto_cont = NEW.nr_sequencia;

	update	cm_expurgo_receb
	set	ie_status = NEW.ie_status_conjunto
	where	nr_conjunto_cont = NEW.nr_sequencia;

	end;
end if;

if (NEW.cd_local_estoque <> OLD.cd_local_estoque) then
	BEGIN

	select	ds_local_estoque
	into STRICT	ds_local_estoque_w
	from	local_estoque
	where	cd_local_estoque = NEW.cd_local_estoque;

	if (ds_local_estoque_w is not null) then
		BEGIN
		
		CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311257,'DS_LOCAL_ESTOQUE='||ds_local_estoque_w),NEW.nm_usuario);

		NEW.nm_usuario_repasse	:= wheb_usuario_pck.get_nm_usuario;
		
		if (NEW.nr_seq_ciclo is not null) then
			CALL cm_gerar_hist_ciclo(wheb_mensagem_pck.get_texto(311258,'NR_SEQUENCIA='||NEW.nr_sequencia||';DS_LOCAL_ESTOQUE='||ds_local_estoque_w),'E',NEW.nr_seq_ciclo,null,NEW.nm_usuario);
		elsif (NEW.nr_seq_ciclo_lav is not null) then
			CALL cm_gerar_hist_ciclo(wheb_mensagem_pck.get_texto(311258,'NR_SEQUENCIA='||NEW.nr_sequencia||';DS_LOCAL_ESTOQUE='||ds_local_estoque_w),'E',null,NEW.nr_seq_ciclo,NEW.nm_usuario);
		end if;

		end;
	end if;

	end;
end if;

if (coalesce(NEW.nr_seq_ciclo,0) <> coalesce(OLD.nr_seq_ciclo,0)) then
	BEGIN

	if (OLD.nr_seq_ciclo is null) and (NEW.nr_seq_ciclo is not null) then
		BEGIN
		
		select	substr(cme_obter_desc_equip(nr_seq_equipamento),1,150),
			nr_seq_equipamento
		into STRICT	ds_equipamento_w,
			nr_seq_equipamento_w
		from	cm_ciclo
		where	nr_sequencia = NEW.nr_seq_ciclo;
		
		ie_se_conjunto_equip_w := obter_se_conjunto_equip(NEW.nr_seq_conjunto, nr_seq_equipamento_w);
		
		if (ie_se_conjunto_equip_w = 'N') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(767182);
		end if;
		
		CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311325) || ' ' || NEW.nr_seq_ciclo ||
							' - ' || wheb_mensagem_pck.get_texto(311259) || ': ' || ds_equipamento_w,NEW.nm_usuario);
		
		end;
	elsif (OLD.nr_seq_ciclo is not null) and (NEW.nr_seq_ciclo is null) then
		BEGIN
		
		select	substr(cme_obter_desc_equip(nr_seq_equipamento),1,150)
		into STRICT	ds_equipamento_w
		from	cm_ciclo
		where	nr_sequencia = OLD.nr_seq_ciclo;

		CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311330) || ' ' || OLD.nr_seq_ciclo ||
							' - ' || wheb_mensagem_pck.get_texto(311259) || ': ' || ds_equipamento_w,NEW.nm_usuario);

		end;
	elsif (OLD.nr_seq_ciclo_lav is null) and (NEW.nr_seq_ciclo_lav is not null) and (1=2) then
		BEGIN
		
		select	substr(cme_obter_desc_equip(nr_seq_equipamento),1,150)
		into STRICT	ds_equipamento_w
		from	cm_ciclo_lavacao
		where	nr_sequencia = NEW.nr_seq_ciclo_lav;

		CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311325) || ' ' || NEW.nr_seq_ciclo_lav ||
							' - ' || wheb_mensagem_pck.get_texto(311259) || ': ' || ds_equipamento_w,NEW.nm_usuario);
		
		end;
	elsif (OLD.nr_seq_ciclo_lav is not null) and (NEW.nr_seq_ciclo_lav is null) then
		BEGIN
		
		select	substr(cme_obter_desc_equip(nr_seq_equipamento),1,150)
		into STRICT	ds_equipamento_w
		from	cm_ciclo_lavacao
		where	nr_sequencia = OLD.nr_seq_ciclo_lav;

		CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311330) || ' ' || OLD.nr_seq_ciclo_lav ||
							' - ' || wheb_mensagem_pck.get_texto(311259) || ': ' || ds_equipamento_w,NEW.nm_usuario);
		
		end;
	end if;

	end;
end if;		

if (NEW.cd_pessoa_receb is not null) and (NEW.cd_pessoa_receb <> OLD.cd_pessoa_receb) then
	BEGIN

	CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311332,'NM_PESSOA='||substr(obter_nome_pf(NEW.cd_pessoa_receb),1,180)),NEW.nm_usuario);

	end;
end if;

if (NEW.nm_pessoa_receb is not null) and (NEW.nm_pessoa_receb <> OLD.nm_pessoa_receb) then
	BEGIN

	CALL cm_gerar_historico_conj(NEW.nr_sequencia,wheb_mensagem_pck.get_texto(311332,'NM_PESSOA='||substr(NEW.nm_pessoa_receb,1,180)),NEW.nm_usuario);

	end;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cm_conjunto_cont_atual() FROM PUBLIC;

CREATE TRIGGER cm_conjunto_cont_atual
	BEFORE UPDATE ON cm_conjunto_cont FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cm_conjunto_cont_atual();

