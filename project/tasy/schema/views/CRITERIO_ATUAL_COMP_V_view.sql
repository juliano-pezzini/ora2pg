-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW criterio_atual_comp_v (cd_criterio_atual_comp, ds_criterio_atual_comp) AS SELECT	VL_DOMINIO CD_CRITERIO_ATUAL_COMP,
	DS_VALOR_DOMINIO DS_CRITERIO_ATUAL_COMP
FROM	VALOR_DOMINIO
WHERE	CD_DOMINIO = 309;

