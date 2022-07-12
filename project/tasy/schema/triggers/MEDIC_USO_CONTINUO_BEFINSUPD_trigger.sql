-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS medic_uso_continuo_befinsupd ON medic_uso_continuo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_medic_uso_continuo_befinsupd() RETURNS trigger AS $BODY$
declare
qt_reg_w	smallint;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

if (coalesce(OLD.DT_ATUALIZACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_ATUALIZACAO) and (NEW.DT_ATUALIZACAO is not null) then
	NEW.ds_utc		:= obter_data_utc(NEW.DT_ATUALIZACAO, 'HV');
end if;

/* Consiste CID Principal */

if (NEW.ie_laudo_lme = 'S') and (obter_se_cid_mat_especial(NEW.cd_material, NEW.cd_cid_principal, 'P') = 'N') then
	/*Este CID principal não pode ser utilizado para este medicamento, pois não está liberado no cadastro do SUS. '||
		'Este cadastro pode ser verificado na função Gestão de SUS Unificado.#@#@');*/
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261528);
end if;

/* Consiste CID Secundário */

if (NEW.ie_laudo_lme = 'S') and (obter_se_cid_mat_especial(NEW.cd_material, NEW.cd_cid_secundario, 'S') = 'N') then
	/*Este CID secundário não pode ser utilizado para este medicamento, pois não está liberado no cadastro do SUS. '||
		'Este cadastro pode ser verificado na função Gestão de SUS Unificado.#@#@');*/
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261529);
end if;

if	((OLD.IE_USO_CONTINUO = 'S' AND NEW.IE_USO_CONTINUO = 'N') or
	(NEW.IE_USO_CONTINUO = 'N' AND OLD.IE_USO_CONTINUO is null)) and (NEW.DT_INICIO +  NEW.NR_DIAS_USO < LOCALTIMESTAMP) then
	/*Não é possível desmarcar a opção Uso contínuo.' || chr(10) ||'Pois a data de início juntamente com os dias de utilização são menores que a data de hoje.#@#@');*/

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261530);
end if;
<<Final>>
qt_reg_w	:= 0;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_medic_uso_continuo_befinsupd() FROM PUBLIC;

CREATE TRIGGER medic_uso_continuo_befinsupd
	BEFORE INSERT OR UPDATE ON medic_uso_continuo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_medic_uso_continuo_befinsupd();
