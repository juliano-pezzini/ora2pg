-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_classif_atual ON titulo_pagar_classif CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_classif_atual() RETURNS trigger AS $BODY$
DECLARE
cd_estabelecimento_w			bigint;
ie_situacao_w				varchar(255);
ds_centro_custo_w				varchar(255);

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (NEW.cd_conta_contabil is not null) then
	--'Conta contabil'

	CALL CTB_Consistir_Conta_Titulo(NEW.cd_conta_contabil, wheb_mensagem_pck.get_texto(304002));

	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	titulo_pagar
	where	nr_titulo = NEW.nr_titulo;

		
	if (NEW.cd_conta_contabil <> OLD.cd_conta_contabil) then			
		CTB_Consistir_Conta_estab(cd_estabelecimento_w, NEW.cd_conta_contabil, wheb_mensagem_pck.get_texto(304002));
	end if;	
end if;

if (NEW.cd_centro_custo is not null) and (NEW.cd_centro_custo <> coalesce(OLD.cd_centro_custo,-1)) then
	select	ie_situacao,
		ds_centro_custo
	into STRICT	ie_situacao_w,
		ds_centro_custo_w
	from	centro_custo
	where	cd_centro_custo	= NEW.cd_centro_custo;

	if (coalesce(ie_situacao_w, 'A') = 'I') then
		--r.aise_application_error(-20011, 'O centro de custo "' || ds_centro_custo_w || '" esta inativo! Nao e possivel continuar.');

		CALL wheb_mensagem_pck.exibir_mensagem_abort(267376,'ds_centro_custo_w='||ds_centro_custo_w);
	end if;
end if;
end if;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_classif_atual() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_classif_atual
	BEFORE INSERT OR UPDATE ON titulo_pagar_classif FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_classif_atual();
