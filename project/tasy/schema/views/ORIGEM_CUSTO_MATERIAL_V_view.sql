-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW origem_custo_material_v (cd_origem_custo_material, ds_origem_custo_material) AS SELECT VL_DOMINIO CD_ORIGEM_CUSTO_MATERIAL,
       DS_VALOR_DOMINIO DS_ORIGEM_CUSTO_MATERIAL
FROM VALOR_DOMINIO
WHERE CD_DOMINIO = 310;

