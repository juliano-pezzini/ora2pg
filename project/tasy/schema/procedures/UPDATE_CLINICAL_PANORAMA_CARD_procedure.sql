-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_clinical_panorama_card (nr_card_sequence_p bigint) AS $body$
BEGIN
	
CALL panorama_leito_pck.ATUALIZAR_W_PAN_LEITO(wheb_usuario_pck.get_cd_estabelecimento, nr_card_sequence_p, wheb_usuario_pck.get_nm_usuario);
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_clinical_panorama_card (nr_card_sequence_p bigint) FROM PUBLIC;
