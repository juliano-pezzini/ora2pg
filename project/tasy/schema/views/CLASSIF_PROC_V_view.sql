-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW classif_proc_v (cd_classif_proc, ds_classif_proc) AS SELECT VL_DOMINIO CD_CLASSIF_PROC,
       DS_VALOR_DOMINIO DS_CLASSIF_PROC
FROM VALOR_DOMINIO
WHERE CD_DOMINIO = 19;
