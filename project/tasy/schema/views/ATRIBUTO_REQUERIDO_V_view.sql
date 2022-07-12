-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atributo_requerido_v (nm_tabela, nm_atributo) AS select table_name nm_tabela,
       column_name nm_atributo
FROM user_tab_columns
where nullable = 'N'
and column_name not in ('DT_ATUALIZACAO' , 'NM_USUARIO');

