-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_status_fat_pos_estab ( ie_status_fat_p pls_conta_pos_estabelecido.ie_status_faturamento%type, qt_original_p pls_conta_pos_estabelecido.qt_original%type, qt_item_p pls_conta_pos_estabelecido.qt_item%type, vl_calculado_p pls_conta_pos_estabelecido.vl_calculado%type, vl_beneficiario_p pls_conta_pos_estabelecido.vl_beneficiario%type) RETURNS PLS_CONTA_POS_ESTABELECIDO.IE_STATUS_FATURAMENTO%TYPE AS $body$
DECLARE


ie_status_fat_w		pls_conta_pos_estabelecido.ie_status_faturamento%type;


BEGIN
-- se o status estiver como Permitido Faturamento então Libera para Faturamento
if (coalesce(ie_status_fat_p, 'P') = 'P') then

	ie_status_fat_w := 'L';

-- se não verifica o status de faturamento da análise de pós-estabelecido, se o mesmo for liberado ou permitido então libera para faturamento
elsif (pls_analise_obter_status_fat(null,qt_original_p,qt_item_p,vl_calculado_p,vl_beneficiario_p) in ('L', 'P')) then

	ie_status_fat_w := 'L';

elsif (pls_analise_obter_status_fat(null,qt_original_p,qt_item_p,vl_calculado_p,vl_beneficiario_p) = 'G') then
	ie_status_fat_w := 'N';
-- caso não se encaixe nas opções anteriores não é alterado
else
	ie_status_fat_w := ie_status_fat_p;
end if;

return ie_status_fat_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_status_fat_pos_estab ( ie_status_fat_p pls_conta_pos_estabelecido.ie_status_faturamento%type, qt_original_p pls_conta_pos_estabelecido.qt_original%type, qt_item_p pls_conta_pos_estabelecido.qt_item%type, vl_calculado_p pls_conta_pos_estabelecido.vl_calculado%type, vl_beneficiario_p pls_conta_pos_estabelecido.vl_beneficiario%type) FROM PUBLIC;

