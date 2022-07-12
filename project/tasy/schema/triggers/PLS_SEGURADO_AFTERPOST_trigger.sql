-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_segurado_afterpost ON pls_segurado CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_segurado_afterpost() RETURNS trigger AS $BODY$
declare

nr_seq_participante_w	mprev_participante.nr_sequencia%type;
ie_situacao_partic_w	mprev_participante.ie_situacao%type	:= null;
ds_comunicado_w		varchar(4000);
ds_lista_usuario_w	varchar(4000);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_captacao_w	mprev_captacao.nr_sequencia%type;
nr_seq_seg_capt_w	pls_segurado.nr_sequencia%type;
nr_seq_busca_emp_w	mprev_busca_empresarial.nr_sequencia%type;
nr_seq_demanda_espont_w mprev_demanda_espont.nr_sequencia%type;
nr_seq_indicacao_w	mprev_indicacao_paciente.nr_sequencia%type;
nm_usuario_w		usuario.nm_usuario%type;
dt_ocorrencia_w		timestamp;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	nm_usuario_w	:= coalesce(wheb_usuario_pck.get_nm_usuario,NEW.nm_usuario);
	
	if (OLD.ie_tipo_segurado = 'I' or OLD.ie_tipo_segurado is null) and (NEW.dt_comp_risco is not null) then --Se era eventual e agora foi assumido como repasse
		dt_ocorrencia_w	:= trunc(NEW.dt_comp_risco,'dd');
	else
		dt_ocorrencia_w	:= trunc(LOCALTIMESTAMP,'dd');
	end if;
	
	--Alteração do tipo de beneficiário

	if (TG_OP = 'UPDATE') and (NEW.ie_tipo_segurado <> OLD.ie_tipo_segurado) then
		insert into pls_segurado_historico(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_segurado,
			dt_historico, ds_historico, ds_observacao,
			ie_tipo_historico, dt_ocorrencia_sib, ie_historico_situacao,
			dt_liberacao_hist, ie_envio_sib, ie_tipo_segurado,
			ie_tipo_segurado_ant, ie_situacao_compartilhamento)
		values (	nextval('pls_segurado_historico_seq'), LOCALTIMESTAMP, nm_usuario_w,
			LOCALTIMESTAMP, nm_usuario_w, NEW.nr_sequencia,
			LOCALTIMESTAMP, 'Tipo de beneficiário alterado de "'||obter_valor_dominio(2406,OLD.ie_tipo_segurado)||'" para "'||obter_valor_dominio(2406,NEW.ie_tipo_segurado)||'"', '',
			'102', dt_ocorrencia_w, 'S',
			LOCALTIMESTAMP, 'N', NEW.ie_tipo_segurado,
			OLD.ie_tipo_segurado, 'A');
			
		CALL pls_inativar_historico_compart(NEW.nr_sequencia, dt_ocorrencia_w, nm_usuario_w, 'N');
	elsif	(TG_OP = 'INSERT' AND NEW.ie_tipo_segurado = 'H') then
		insert into pls_segurado_historico(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_segurado,
			dt_historico, ds_historico, ds_observacao,
			ie_tipo_historico, dt_ocorrencia_sib, ie_historico_situacao,
			dt_liberacao_hist, ie_envio_sib, ie_tipo_segurado,
			ie_tipo_segurado_ant, ie_situacao_compartilhamento)
		values (	nextval('pls_segurado_historico_seq'), LOCALTIMESTAMP, nm_usuario_w,
			LOCALTIMESTAMP, nm_usuario_w, NEW.nr_sequencia,
			LOCALTIMESTAMP, 'Tipo de beneficiário alterado de "'||obter_valor_dominio(2406,'I')||'" para "'||obter_valor_dominio(2406,NEW.ie_tipo_segurado)||'"', '',
			'102', dt_ocorrencia_w, 'S',
			LOCALTIMESTAMP, 'N', NEW.ie_tipo_segurado,
			'I', 'A');	
		
		CALL pls_inativar_historico_compart(NEW.nr_sequencia, dt_ocorrencia_w, nm_usuario_w, 'N');
	end if;

	--Quando a situação de atendimento do beneficiário ficou Inativo

	if (NEW.ie_situacao_atend = 'I') and (coalesce(OLD.ie_situacao_atend,'X') <> 'I') then
		ie_situacao_partic_w	:= 'I';
	--Quando a situação de atendimento do beneficiário ficou Suspenso

	elsif (NEW.ie_situacao_atend = 'S') and (coalesce(OLD.ie_situacao_atend,'X') <> 'S') then
		ie_situacao_partic_w	:= 'S';
	end if;
	
	if (TG_OP = 'UPDATE') and (OLD.nr_seq_segurado_ant is not null) and (OLD.dt_migracao is not null) and (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
		
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_captacao_w
		from	mprev_captacao a
		where	a.cd_pessoa_fisica = NEW.cd_pessoa_fisica
		and	a.ie_status = 'A' -- Aceito

		and	exists (	SELECT	1
				from	mprev_participante x
				where	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
		
		if (nr_seq_captacao_w is null) then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_captacao_w
			from	mprev_captacao a
			where	a.cd_pessoa_fisica = NEW.cd_pessoa_fisica
			and	a.ie_status = 'T' -- Triagem

			and	exists (	SELECT	1
					from	mprev_participante x
					where	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
		end if;
		
		if (nr_seq_captacao_w is null) then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_captacao_w
			from	mprev_captacao a
			where	a.cd_pessoa_fisica = NEW.cd_pessoa_fisica
			and	a.ie_status = 'P' -- Pendente

			and	exists (	SELECT	1
					from	mprev_participante x
					where	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
		end if;
		
		if (nr_seq_captacao_w is null) then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_captacao_w
			from	mprev_captacao a
			where	a.cd_pessoa_fisica = NEW.cd_pessoa_fisica
			and	a.ie_status = 'N' -- Negada

			and	exists (	SELECT	1
					from	mprev_participante x
					where	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
		end if;
		
		if (nr_seq_captacao_w is null) then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_captacao_w
			from	mprev_captacao a
			where	a.cd_pessoa_fisica = NEW.cd_pessoa_fisica
			and	a.ie_status = 'R' -- Regeitada

			and	exists (	SELECT	1
					from	mprev_participante x
					where	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
		end if;
		
		if (nr_seq_captacao_w is null) then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_captacao_w
			from	mprev_captacao a
			where	a.cd_pessoa_fisica = NEW.cd_pessoa_fisica
			and	a.ie_status = 'C' -- Cancelada

			and	exists (	SELECT	1
					from	mprev_participante x
					where	x.cd_pessoa_fisica = a.cd_pessoa_fisica);
		end if;
		
		if (nr_seq_captacao_w is not null) then
			select	max(nr_seq_busca_emp),
				max(nr_seq_demanda_espont),
				max(nr_seq_indicacao)
			into STRICT	nr_seq_busca_emp_w,
				nr_seq_demanda_espont_w,
				nr_seq_indicacao_w
			from	mprev_captacao
			where	nr_sequencia = nr_seq_captacao_w;
			
			if (nr_seq_busca_emp_w is not null) then
				update	mprev_busca_empresarial
				set	nr_seq_segurado = NEW.nr_sequencia,
					nr_seq_segurado_ant = NEW.nr_seq_segurado_ant,
					dt_atualizacao = LOCALTIMESTAMP,
					nm_usuario = NEW.nm_usuario
				where	nr_sequencia = nr_seq_busca_emp_w
				and	nr_seq_segurado = NEW.nr_seq_segurado_ant;
			elsif (nr_seq_demanda_espont_w is not null) then
				update	mprev_demanda_espont
				set	nr_seq_segurado = NEW.nr_sequencia,
					nr_seq_segurado_ant = NEW.nr_seq_segurado_ant,
					dt_atualizacao = LOCALTIMESTAMP,
					nm_usuario = NEW.nm_usuario
				where	nr_sequencia = nr_seq_demanda_espont_w
				and	nr_seq_segurado = NEW.nr_seq_segurado_ant;
			elsif (nr_seq_indicacao_w is not null) then
				update	mprev_indicacao_paciente
				set	nr_seq_segurado = NEW.nr_sequencia,
					nr_seq_segurado_ant = NEW.nr_seq_segurado_ant,
					dt_atualizacao = LOCALTIMESTAMP,
					nm_usuario = NEW.nm_usuario
				where	nr_sequencia = nr_seq_indicacao_w
				and	nr_seq_segurado = NEW.nr_seq_segurado_ant;
			end if;
		end if;
	else
		/* Se mudou a situação, procurar qual o participante e alterar no mesmo */


		if (ie_situacao_partic_w is not null) and (NEW.nr_seq_segurado_mig is null) then
			if (pkg_date_utils.start_of(NEW.dt_rescisao,'DAY') <= LOCALTIMESTAMP) then
				cd_estabelecimento_w	:= obter_estabelecimento_ativo;
				
				CALL mprev_tratar_exclusao_part(	NEW.nr_sequencia,
								NEW.cd_pessoa_fisica,
								null,
								'R',
								NEW.dt_rescisao,
								null,
								ie_situacao_partic_w,
								cd_estabelecimento_w,
								NEW.nm_usuario);
			end if;
		end if;
	end if;
end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_segurado_afterpost() FROM PUBLIC;

CREATE TRIGGER pls_segurado_afterpost
	AFTER INSERT OR UPDATE ON pls_segurado FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_segurado_afterpost();

