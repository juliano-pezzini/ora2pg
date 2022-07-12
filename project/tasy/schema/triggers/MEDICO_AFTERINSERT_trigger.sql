-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS medico_afterinsert ON medico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_medico_afterinsert() RETURNS trigger AS $BODY$
DECLARE

ie_inserir_medico_estab_w	varchar(1) := 'N';
qt_existe_w			bigint;
reg_integracao_p	gerar_int_padrao.reg_integracao;
ds_param_integ_hl7_w			varchar(4000);
ds_sep_bv_w				varchar(100);
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	ds_sep_bv_w := obter_separador_bv;
	ie_inserir_medico_estab_w := Obter_Param_Usuario(4, 90, obter_perfil_ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_inserir_medico_estab_w);

	if (ie_inserir_medico_estab_w = 'S') then

		select count(*)
		into STRICT	qt_existe_w
		from 	medico_estabelecimento
		where 	cd_pessoa_fisica = NEW.cd_pessoa_fisica
		and 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

		if (qt_existe_w = 0) then

			insert 	into	medico_estabelecimento(
					nr_sequencia,
					cd_pessoa_fisica,
					cd_estabelecimento,
					ie_socio,
					dt_atualizacao,
					nm_usuario)
			values (
					nextval('medico_estabelecimento_seq'),
					NEW.cd_pessoa_fisica,
					wheb_usuario_pck.get_cd_estabelecimento,
					'N',
					LOCALTIMESTAMP,
					NEW.nm_usuario);

		end if;
	end if;
	CALL send_physician_intpd(NEW.cd_pessoa_fisica, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, 'I');
	ds_param_integ_hl7_w := 'cd_pessoa_fisica=' || NEW.cd_pessoa_fisica || ds_sep_bv_w||
							'ie_acao='||'MAD'||ds_sep_bv_w;
	CALL gravar_agend_integracao(853, ds_param_integ_hl7_w); /* Tasy -> SCC (MFN_M02) - Doctor registration */
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_medico_afterinsert() FROM PUBLIC;

CREATE TRIGGER medico_afterinsert
	AFTER INSERT ON medico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_medico_afterinsert();

