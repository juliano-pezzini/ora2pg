-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS protocolo_convenio_befupdate ON protocolo_convenio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_protocolo_convenio_befupdate() RETURNS trigger AS $BODY$
DECLARE

qt_nota_fiscal_w	bigint;
qt_titulo_w		bigint;

BEGIN

if (OLD.ie_status_protocolo = 2) and (NEW.ie_status_protocolo = 1) then

	select	count(*)
	into STRICT	qt_nota_fiscal_w
	from	nota_fiscal
	where	ie_situacao = '1'
	and	nr_seq_protocolo 	= NEW.nr_seq_protocolo;

	if (qt_nota_fiscal_w <> 0) then
		--R.aise_application_error(-20011,'O status do protocolo não pode ser alterado, pois o mesmo já possui notas vinculadas!');

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263424);
	end if;

	select	count(*)
	into STRICT	qt_titulo_w
	from	titulo_receber
	where	nr_seq_protocolo = NEW.nr_seq_protocolo;
	
	if (NEW.nr_seq_lote_protocolo is not null) and (qt_titulo_w = 0) then
		
		select	count(*)
		into STRICT	qt_titulo_w
		from	titulo_receber
		where	NR_SEQ_LOTE_PROT = NEW.nr_seq_lote_protocolo;
		
	end if;

	if (qt_titulo_w <> 0) then
		--R.aise_application_error(-20011,'O status do protocolo não pode ser alterado, pois o mesmo já possui títulos vinculados!');

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263425);
	end if;

end if;

if (NEW.ie_status_protocolo = 2) then
	NEW.nm_usuario_definitivo	:= wheb_usuario_pck.get_nm_usuario;
elsif (NEW.ie_status_protocolo = 1) then
	NEW.nm_usuario_definitivo	:= null;
end if;

if (OLD.nr_seq_doc_convenio <> NEW.nr_seq_doc_convenio) then
	NEW.dt_alter_doc_convenio := LOCALTIMESTAMP;
	NEW.nm_usuario_alt_doc_conv := NEW.nm_usuario;
end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_protocolo_convenio_befupdate() FROM PUBLIC;

CREATE TRIGGER protocolo_convenio_befupdate
	BEFORE UPDATE ON protocolo_convenio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_protocolo_convenio_befupdate();
