-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_item_prescrito_onc (nr_sequencia_p can_ordem_item_prescr.nr_sequencia%type) AS $body$
DECLARE


ie_lanca_conta_w varchar(1);


BEGIN
    ie_lanca_conta_w := obter_param_usuario(3130, 172, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_lanca_conta_w);

    if (ie_lanca_conta_w = 'S') then
        CALL baixar_prescrito_conta_onc(nr_sequencia_p);
    end if;

    CALL baixar_prescrito_estoque_onc(nr_sequencia_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_item_prescrito_onc (nr_sequencia_p can_ordem_item_prescr.nr_sequencia%type) FROM PUBLIC;

