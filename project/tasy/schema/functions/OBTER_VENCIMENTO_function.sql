-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vencimento ( cd_estabelecimento_p bigint, cd_condicao_pagamento_p bigint, dt_base_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_venc_w			varchar(255);
qt_venc_w			bigint;


BEGIN

SELECT * FROM calcular_vencimento(cd_estabelecimento_p, cd_condicao_pagamento_p, dt_base_p, qt_venc_w, ds_venc_w) INTO STRICT qt_venc_w, ds_venc_w;

Return ds_venc_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vencimento ( cd_estabelecimento_p bigint, cd_condicao_pagamento_p bigint, dt_base_p timestamp) FROM PUBLIC;
