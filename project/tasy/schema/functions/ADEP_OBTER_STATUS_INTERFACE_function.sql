-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_status_interface ( ie_status_p bomba_infusao_interface.ie_status%TYPE default null, qt_velocidade_p bomba_infusao_interface.qt_velocidade%TYPE default null, ie_questionavel_p bomba_infusao_interface.ie_estado_questionavel%TYPE default null) RETURNS varchar AS $body$
DECLARE

    ie_status_w varchar(100);
    ie_questionavel_v varchar(100) := coalesce(ie_questionavel_p, 'N');

BEGIN
    IF ie_questionavel_p = 'S' THEN
        ie_status_w := expressao_pck.obter_desc_expressao(971534, coalesce(wheb_usuario_pck.get_nr_seq_idioma,0));
    ELSIF ie_status_p = 'IP' AND ie_questionavel_v = 'N' THEN
        ie_status_w := replace(expressao_pck.obter_desc_expressao(1009835, coalesce(wheb_usuario_pck.get_nr_seq_idioma, 0)), '{0}', qt_velocidade_p);
    ELSIF ie_status_p in ('DS', 'ST') AND ie_questionavel_v = 'N' THEN
      ie_status_w := expressao_pck.obter_desc_expressao(1013458, coalesce(wheb_usuario_pck.get_nr_seq_idioma,0));
    ELSIF ie_status_p in ('IS') AND ie_questionavel_v = 'N' THEN
      ie_status_w := expressao_pck.obter_desc_expressao(1009838, coalesce(wheb_usuario_pck.get_nr_seq_idioma,0));
    ELSIF ie_status_p in ('BL') AND ie_questionavel_v = 'N' THEN
      ie_status_w := expressao_pck.obter_desc_expressao(1009836, coalesce(wheb_usuario_pck.get_nr_seq_idioma,0));
    ELSIF ie_status_p in ('AL') AND ie_questionavel_v = 'N' THEN
      ie_status_w := expressao_pck.obter_desc_expressao(1009588, coalesce(wheb_usuario_pck.get_nr_seq_idioma,0));
    ELSIF ie_status_p in ('TC') AND ie_questionavel_v = 'N' THEN
      ie_status_w := replace(expressao_pck.obter_desc_expressao(1009835, coalesce(wheb_usuario_pck.get_nr_seq_idioma, 0)), '{0}', qt_velocidade_p);
    ELSIF ie_status_p in ('KV') AND ie_questionavel_v = 'N' THEN
      ie_status_w := replace(expressao_pck.obter_desc_expressao(1009835, coalesce(wheb_usuario_pck.get_nr_seq_idioma, 0)), '{0}', qt_velocidade_p);
    ELSIF ie_status_p in ('KT') AND ie_questionavel_v = 'N' THEN
      ie_status_w := replace(expressao_pck.obter_desc_expressao(1009835, coalesce(wheb_usuario_pck.get_nr_seq_idioma, 0)), '{0}', qt_velocidade_p);
    END IF;
    RETURN ie_status_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_status_interface ( ie_status_p bomba_infusao_interface.ie_status%TYPE default null, qt_velocidade_p bomba_infusao_interface.qt_velocidade%TYPE default null, ie_questionavel_p bomba_infusao_interface.ie_estado_questionavel%TYPE default null) FROM PUBLIC;
