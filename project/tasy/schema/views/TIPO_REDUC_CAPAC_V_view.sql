-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tipo_reduc_capac_v (cd_tipo_reduc_capac, ds_tipo_reduc_capac) AS SELECT VL_DOMINIO CD_TIPO_REDUC_CAPAC,
       DS_VALOR_DOMINIO DS_TIPO_REDUC_CAPAC
FROM VALOR_DOMINIO
WHERE CD_DOMINIO = 306;

