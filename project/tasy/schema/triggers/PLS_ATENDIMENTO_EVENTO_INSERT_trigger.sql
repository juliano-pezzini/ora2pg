-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_atendimento_evento_insert ON pls_atendimento_evento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_atendimento_evento_insert() RETURNS trigger AS $BODY$
declare

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_perfil_w			perfil.cd_perfil%type;
dt_conclusao_w			pls_atendimento.dt_conclusao%type;
ie_status_w			pls_atendimento.ie_status%type;
ie_param_21_w			varchar(2);
ds_historico_w			varchar(255);
nr_seq_tipo_historico_w		pls_tipo_historico_atend.nr_sequencia%type;
BEGIN
  BEGIN

BEGIN
	select	dt_conclusao,
		ie_status
	into STRICT	dt_conclusao_w,
		ie_status_w
	from	pls_atendimento
	where	nr_sequencia = NEW.nr_seq_atendimento;
exception
when others then
	dt_conclusao_w	:= null;
	ie_status_w	:= null;
end;

cd_perfil_w		:= somente_numero(wheb_usuario_pck.get_cd_perfil);
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
ie_param_21_w := obter_param_usuario(1263, 21, cd_perfil_w, NEW.nm_usuario, cd_estabelecimento_w, ie_param_21_w);

if	((dt_conclusao_w is not null) or (ie_status_w = 'C')) and -- "C" = Atendimento concluído
	(ie_param_21_w = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort('Não é possível inserir evento em um atendimento concluído!');
end if;

if	((dt_conclusao_w is not null) or (ie_status_w = 'C')) and -- "C" = Atendimento concluído
	(ie_param_21_w = 'S') then
	BEGIN
		select	ds_valor_dominio
		into STRICT	ds_historico_w
		from	valor_dominio_v
		where	cd_dominio	= 3394
		and	vl_dominio	= 10
		and	ie_situacao	= 'A';
	exception
	when others then
		ds_historico_w	:= 'Inseriu ocorrência no atendimento finalizado.';
	end;

	ds_historico_w	:= ds_historico_w || chr(13) || 'Usuário: ' || NEW.nm_usuario || chr(13) || 'Data\hora: ' || to_char(LOCALTIMESTAMP,'dd/mm/yyyy hh24:mi:ss');

	if (pls_obter_se_controle_estab('GA') = 'S') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_tipo_historico_w
		from	pls_tipo_historico_atend
		where	ie_gerado_sistema	= 'S'
		and	ie_situacao		= 'A'
		and (cd_estabelecimento = cd_estabelecimento_w );
	else
		select	max(nr_sequencia)
		into STRICT	nr_seq_tipo_historico_w
		from	pls_tipo_historico_atend
		where	ie_gerado_sistema	= 'S'
		and	ie_situacao		= 'A';
	end if;

	insert	into pls_atendimento_historico(nr_sequencia, nr_seq_atendimento, ds_historico_long,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, nr_seq_tipo_historico, dt_historico,
		ie_origem_historico, ie_gerado_sistema)
	values (nextval('pls_atendimento_historico_seq'), NEW.nr_seq_atendimento, ds_historico_w,
		LOCALTIMESTAMP, NEW.nm_usuario, LOCALTIMESTAMP,
		NEW.nm_usuario, nr_seq_tipo_historico_w, LOCALTIMESTAMP,
		10, 'S');
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_atendimento_evento_insert() FROM PUBLIC;

CREATE TRIGGER pls_atendimento_evento_insert
	BEFORE INSERT ON pls_atendimento_evento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_atendimento_evento_insert();
