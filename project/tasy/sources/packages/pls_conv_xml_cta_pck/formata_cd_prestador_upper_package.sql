-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Utilizada para formatar o campo cd_prest_upper_conv da tabela pls_protocolo_conta_imp



CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.formata_cd_prestador_upper ( cd_prestador_p pls_protocolo_conta_imp.cd_prestador%type) RETURNS varchar AS $body$
DECLARE


cd_prest_upper_conv_w	pls_protocolo_conta_imp.cd_prest_upper_conv%type;


BEGIN

cd_prest_upper_conv_w := upper(cd_prestador_p);

return	cd_prest_upper_conv_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.formata_cd_prestador_upper ( cd_prestador_p pls_protocolo_conta_imp.cd_prestador%type) FROM PUBLIC;
