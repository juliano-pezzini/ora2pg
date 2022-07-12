-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tipo_baixa_prescr_integracao_v (cd_tipo_baixa, ds_tipo_baixa) AS select	cd_tipo_baixa, ds_tipo_baixa
FROM 	tipo_baixa_prescricao
where 	ie_prescricao_devolucao = 'P'
and 	ie_situacao = 'A'
order by	cd_tipo_baixa, ds_tipo_baixa;

