-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hepic_estado_fisico_v (cd_tipo_anestesia, ds_tipo_anesteisa) AS select 	vl_dominio cd_tipo_anestesia,
			ds_valor_dominio ds_tipo_anesteisa
     FROM 	valor_dominio
    where 	cd_dominio = 1287
	order by ds_tipo_anesteisa;

