-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cih_duracao_cirurgia_v (cd_duracao_cirurgia, ds_duracao_cirurgia) AS SELECT VL_DOMINIO CD_DURACAO_CIRURGIA,
       DS_VALOR_DOMINIO DS_DURACAO_CIRURGIA
FROM VALOR_DOMINIO
WHERE CD_DOMINIO = 601;
