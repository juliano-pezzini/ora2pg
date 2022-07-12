-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS man_ordem_ativ_prev_especif ON man_ordem_ativ_prev CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_man_ordem_ativ_prev_especif() RETURNS trigger AS $BODY$
declare
pragma autonomous_transaction;

ie_classificacao_w		varchar(1);
ie_origem_os_w			varchar(15);
ie_possui_ativ_prog_w		varchar(1);
ie_possui_especif_lib_w		varchar(1);
ie_consiste_w			varchar(1);
cd_cargo_w			bigint;
nr_seq_proj_cron_etapa_w	bigint;

BEGIN

	select	max(ie_classificacao),
		max(ie_origem_os),
		max(nr_seq_proj_cron_etapa)
	into STRICT	ie_classificacao_w,
		ie_origem_os_w,
		nr_seq_proj_cron_etapa_w
	from	man_ordem_servico
	where	nr_sequencia = NEW.nr_seq_ordem_serv;

	if (ie_origem_os_w = '1') and (ie_classificacao_w = 'S') and (nr_seq_proj_cron_etapa_w is null) then

		select	max(a.cd_cargo)
		into STRICT	cd_cargo_w
		from	pessoa_fisica a,
			usuario b
		where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
		and	b.nm_usuario = NEW.nm_usuario_prev;

		if (cd_cargo_w in (251, 425, 426, 427, 427, 73, 66, 69, 80)) then

			ie_consiste_w := obter_param_padrao_usuario(297, 94, obter_perfil_ativo, NEW.nm_usuario, obter_estabelecimento_ativo, ie_consiste_w);

			select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
			into STRICT	ie_possui_ativ_prog_w
			from	man_ordem_ativ_prev a,
				usuario b,
				pessoa_fisica c
			where	a.nr_seq_ordem_serv = NEW.nr_seq_ordem_serv
			and	a.nm_usuario_prev = b.nm_usuario
			and	b.cd_pessoa_fisica = c.cd_pessoa_fisica
			and	c.cd_cargo in (251, 425, 426, 427, 427, 73, 66, 69, 80);

			if (ie_possui_ativ_prog_w = 'N') and (substr(man_obter_se_os_vol_clien_test(NEW.nr_seq_ordem_serv), 1, 1) = 'N') and (ie_consiste_w = 'S') then

				select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
				into STRICT	ie_possui_especif_lib_w
				from	man_os_especificacao
				where	nr_seq_ordem_servico = NEW.nr_seq_ordem_serv
				and	dt_liberacao is not null;

				if (ie_possui_especif_lib_w = 'N') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(358670);
				end if;
			end if;
		end if;
	end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_man_ordem_ativ_prev_especif() FROM PUBLIC;

CREATE TRIGGER man_ordem_ativ_prev_especif
	BEFORE INSERT ON man_ordem_ativ_prev FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_man_ordem_ativ_prev_especif();
