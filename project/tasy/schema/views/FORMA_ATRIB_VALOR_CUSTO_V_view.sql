-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW forma_atrib_valor_custo_v (cd_forma_atrib_valor, ds_forma_atrib_valor) AS SELECT VL_DOMINIO CD_FORMA_ATRIB_VALOR,
       DS_VALOR_DOMINIO DS_FORMA_ATRIB_VALOR
FROM VALOR_DOMINIO
WHERE CD_DOMINIO = 308;

