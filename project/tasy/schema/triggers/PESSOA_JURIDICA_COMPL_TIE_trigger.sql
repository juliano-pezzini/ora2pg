-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_juridica_compl_tie ON pessoa_juridica_compl CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_juridica_compl_tie() RETURNS trigger AS $BODY$
declare
  ds_retorno_integracao_w    text;
  json_w                     philips_json;
  json_data_w                text;
BEGIN
  if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') then
    if (wheb_usuario_pck.get_nm_usuario is not null) then
      json_w := philips_json();

      json_w.put('id', NEW.NR_SEQUENCIA);
      json_w.put('cboPositionCode', NEW.CD_CBO_RED);
      json_w.put('zipCode', NEW.CD_CEP);
      json_w.put('legalEntity', NEW.CD_CGC);
      json_w.put('municipalityCode', NEW.CD_MUNICIPIO_IBGE);
      json_w.put('channelPersonCode', NEW.CD_PESSOA_FISICA_CANAL);
      json_w.put('neighborhood', NEW.DS_BAIRRO);
      json_w.put('roleName', NEW.DS_CARGO);
      json_w.put('complement', NEW.DS_COMPLEMENTO);
      json_w.put('email', NEW.DS_EMAIL);
      json_w.put('addressIdentification', NEW.DS_IDENTIFIC_COMPLEMENTO);
      json_w.put('municipalityName', NEW.DS_MUNICIPIO);
      json_w.put('contactSectorName', NEW.DS_SETOR_CONTATO);
      json_w.put('isReferentialContact', NEW.IE_CONTATO_REF);
      json_w.put('isChannelManager', NEW.IE_GERENTE_CANAL);
      json_w.put('isEventParticipant', NEW.IE_PARTICIPA_EVENTOS);
      json_w.put('isCustomerSponsor', NEW.IE_PLC_CUSTOMER_SPONSOR);
      json_w.put('isPlataformManager', NEW.IE_PLC_PLATAFORM_MANAGER);
      json_w.put('isOps', NEW.IE_PLS);
      json_w.put('isReceivePropose', NEW.IE_RECEBE_PROP);
      json_w.put('complementType', NEW.IE_TIPO_COMPLEMENTO);
      json_w.put('contactPersonName', NEW.NM_PESSOA_CONTATO);
      json_w.put('phoneDdd', NEW.NR_DDD_TELEFONE);
      json_w.put('addressNumber', NEW.NR_ENDERECO);
      json_w.put('faxNumber', NEW.NR_FAX);
      json_w.put('contactBranch', NEW.NR_TELEFONE);
      json_w.put('cellPhone', NEW.NR_TELEFONE_CELULAR);
      json_w.put('stateName', NEW.SG_ESTADO);
      json_w.put('lastUpdate', NEW.DT_ATUALIZACAO);
      json_w.put('lastUpdatedBy', NEW.NM_USUARIO);

      dbms_lob.createtemporary(json_data_w, true);
      json_w.(json_data_w);

      ds_retorno_integracao_w := bifrost.send_integration_content('legalentitycompl.send', json_data_w, wheb_usuario_pck.get_nm_usuario);

    end if;
  end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_juridica_compl_tie() FROM PUBLIC;

CREATE TRIGGER pessoa_juridica_compl_tie
	AFTER INSERT ON pessoa_juridica_compl FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_juridica_compl_tie();

