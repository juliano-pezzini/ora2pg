-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tipo_gasto_v (cd_tipo_gasto, ds_tipo_gasto) AS SELECT VL_DOMINIO CD_TIPO_GASTO,
       DS_VALOR_DOMINIO DS_TIPO_GASTO
FROM VALOR_DOMINIO
WHERE CD_DOMINIO = 305;
