-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS adep_processo_frac_atual ON adep_processo_frac CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_adep_processo_frac_atual() RETURNS trigger AS $BODY$
declare
ie_status_frac_w		varchar(15) := 'X';
ie_grava_log_gedipa_w	varchar(15);

BEGIN

select	coalesce(max(ie_grava_log_gedipa),'S')
into STRICT	ie_grava_log_gedipa_w
from	parametros_farmacia
where	cd_estabelecimento = coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

if (OLD.dt_processo is null) and (NEW.dt_processo is not null) then
	ie_status_frac_w	:= 'P';
elsif (OLD.dt_cancelamento is null) and (NEW.dt_cancelamento is not null) then
	ie_status_frac_w	:= 'C';
elsif (OLD.dt_fim_preparo is null) and (NEW.dt_fim_preparo is not null) then
	ie_status_frac_w	:= 'F';
elsif (OLD.dt_preparo is null) and (NEW.dt_preparo is not null) then
	ie_status_frac_w	:= 'I';
elsif (OLD.dt_geracao is null) and (NEW.dt_geracao is not null) then
	ie_status_frac_w	:= 'G';
end if;

if (ie_status_frac_w <> 'X') then
	NEW.ie_status_frac	:= ie_status_frac_w;
end if;

if (ie_grava_log_gedipa_w = 'S') then
	insert into log_gedipa(nr_sequencia, dt_log, nr_log, nm_objeto_execucao, nm_objeto_chamado, ds_parametros, ds_log)
	values (obter_nextval_sequence('log_gedipa'), LOCALTIMESTAMP, 17, 'ADEP_PROCESSO_FRAC_ATUAL', null,null,
	substr('NR_SEQ_PROCESSO= '||NEW.nr_seq_processo || ' - IE_STATUS_FRAC_W= ' || ie_status_frac_w ||
			' - NM_USUARIO= ' || wheb_usuario_pck.get_nm_usuario || ' - FUNCAO= ' || obter_funcao_ativa,1,200));
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_adep_processo_frac_atual() FROM PUBLIC;

CREATE TRIGGER adep_processo_frac_atual
	BEFORE INSERT OR UPDATE ON adep_processo_frac FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_adep_processo_frac_atual();
