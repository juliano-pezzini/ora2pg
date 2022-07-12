-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_juridica_estab_a400_up ON pessoa_juridica_estab CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_juridica_estab_a400_up() RETURNS trigger AS $BODY$
declare
nr_seq_prestador_w	pls_prestador.nr_sequencia%type;
ie_divulga_email_w	pls_prestador.ie_divulga_email%type;
qt_email_w		integer;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then
	if	((NEW.ds_email <> OLD.ds_email) or (NEW.ds_email is null and OLD.ds_email is not null))then

		select	max(ie_divulga_email),
			max(nr_sequencia)
		into STRICT	ie_divulga_email_w,
			nr_seq_prestador_w
		from	pls_prestador
		where	cd_cgc = NEW.cd_cgc
		and	ie_divulga_email	= 'S'
		and	ie_ptu_a400		= 'S';

		if (nr_seq_prestador_w is not null) and (coalesce(ie_divulga_email_w, 'N') = 'S') and (coalesce(obter_valor_param_usuario(1323, 6, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'S') = 'N') then

			select	count(1)
			into STRICT	qt_email_w
			from	ptu_prestador a,
				ptu_prestador_endereco b
			where	a.nr_sequencia = b.nr_seq_prestador
			and	a.nr_seq_prestador = nr_seq_prestador_w
			and	b.ds_email = OLD.ds_email
			and	b.ie_tipo_endereco_original = 'PJ';

			if (qt_email_w > 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(387909);
			end if;
		end if;
	end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_juridica_estab_a400_up() FROM PUBLIC;

CREATE TRIGGER pessoa_juridica_estab_a400_up
	BEFORE UPDATE ON pessoa_juridica_estab FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_juridica_estab_a400_up();

