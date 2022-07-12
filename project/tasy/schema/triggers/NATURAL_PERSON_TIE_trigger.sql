-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS natural_person_tie ON pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_natural_person_tie() RETURNS trigger AS $BODY$
DECLARE
    JSON_W          PHILIPS_JSON;
    JSON_DATOS_BASICOS_W            PHILIPS_JSON;
    JSON_DATOS_ADICIONALES_W            PHILIPS_JSON;
    JSON_EDIT_FORM_GROUP_2_W            PHILIPS_JSON;
    JSON_DATOS_CONTACTO_W           PHILIPS_JSON;
    JSON_DATOS_CONTACTO_LIST_W          PHILIPS_JSON_LIST;
    JSON_DIREC_PERSONA_W            PHILIPS_JSON;
    JSON_DIREC_PERSONA_LIST_W           PHILIPS_JSON_LIST;
    JSON_DATA_W    text;
    CD_SEXO         smallint;
    DS_RETORNO_INTEGRACAO_W  varchar(4000);
BEGIN
    if    coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'es_AR' then

    JSON_W    := PHILIPS_JSON();
    JSON_DATOS_BASICOS_W := PHILIPS_JSON();
    JSON_DATOS_ADICIONALES_W := PHILIPS_JSON();
    JSON_EDIT_FORM_GROUP_2_W := PHILIPS_JSON();
    JSON_DATOS_CONTACTO_W := PHILIPS_JSON();
    JSON_DIREC_PERSONA_W := PHILIPS_JSON();
    JSON_DATOS_CONTACTO_LIST_W := PHILIPS_JSON_LIST();
    JSON_DIREC_PERSONA_LIST_W := PHILIPS_JSON_LIST();

    JSON_DATOS_BASICOS_W.PUT('id', NEW.CD_PESSOA_FISICA);
    JSON_DATOS_BASICOS_W.PUT('nombre', obter_parte_nome(NEW.NM_PESSOA_FISICA,'Nome'));
    JSON_DATOS_BASICOS_W.PUT('apellido', obter_parte_nome(NEW.NM_PESSOA_FISICA,'RestoNome'));
    JSON_DATOS_BASICOS_W.PUT('fechaNacimiento', coalesce(to_char(NEW.DT_NASCIMENTO, 'yyyy-mm-dd'), to_char(LOCALTIMESTAMP, 'yyyy-mm-dd')));

    if (NEW.IE_SEXO = 'M') then
        CD_SEXO := 1;
    elsif (NEW.IE_SEXO = 'F') then
        CD_SEXO := 2;
    else
        CD_SEXO := 3;
    end if;

    JSON_DATOS_BASICOS_W.PUT('sexo', CD_SEXO);
    JSON_DATOS_BASICOS_W.PUT('tipoDoc', 7);
    JSON_DATOS_BASICOS_W.PUT('documento', NEW.NR_IDENTIDADE);
    JSON_DATOS_BASICOS_W.PUT('emailPrincipal', '');
    JSON_DATOS_BASICOS_W.PUT('telefonoPrincipal', NEW.NR_TELEFONE_CELULAR);
    JSON_DATOS_BASICOS_W.PUT('terminos', true);

    JSON_DATOS_CONTACTO_W.PUT('tipo', 1);
    JSON_DATOS_CONTACTO_W.PUT('valor', 0);
    JSON_DATOS_CONTACTO_W.PUT('uso', 1);
    JSON_DATOS_CONTACTO_LIST_W.APPEND(JSON_DATOS_CONTACTO_W.to_json_value());

    JSON_DIREC_PERSONA_W.PUT('uso', 1);
    JSON_DIREC_PERSONA_W.PUT('direccion', '');
    JSON_DIREC_PERSONA_W.PUT('localidad', '');
    JSON_DIREC_PERSONA_W.PUT('provincia', '');
    JSON_DIREC_PERSONA_W.PUT('pais', '');
    JSON_DIREC_PERSONA_W.PUT('cp', '');
    JSON_DIREC_PERSONA_W.PUT('piso', '');
    JSON_DIREC_PERSONA_W.PUT('dpto', '');
    JSON_DIREC_PERSONA_W.PUT('tipo', 1);
    JSON_DIREC_PERSONA_W.PUT('lat', 0);
    JSON_DIREC_PERSONA_W.PUT('lng', 0);
    JSON_DIREC_PERSONA_LIST_W.APPEND(JSON_DIREC_PERSONA_W.to_json_value());

    JSON_EDIT_FORM_GROUP_2_W.PUT('datosContacto', JSON_DATOS_CONTACTO_LIST_W);
    JSON_EDIT_FORM_GROUP_2_W.PUT('direccionesPersona', JSON_DIREC_PERSONA_LIST_W);
    JSON_EDIT_FORM_GROUP_2_W.PUT('fotoHd', 'data:image/png;base64, iVg==');

    JSON_DATOS_ADICIONALES_W.PUT('editarFormGroup2', JSON_EDIT_FORM_GROUP_2_W);

    JSON_W.PUT('datosBasicos', JSON_DATOS_BASICOS_W);
    JSON_W.PUT('datosAdicionales', JSON_DATOS_ADICIONALES_W);

    DBMS_LOB.CREATETEMPORARY(JSON_DATA_W, TRUE);
    JSON_W.(JSON_DATA_W);

    SELECT  BIFROST.SEND_INTEGRATION_CONTENT('api.naturalperson.send',
                                               JSON_DATA_W,
                                               'WebServiceTIE')
    INTO STRICT  DS_RETORNO_INTEGRACAO_W
;
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_natural_person_tie() FROM PUBLIC;

CREATE TRIGGER natural_person_tie
	AFTER INSERT ON pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_natural_person_tie();
