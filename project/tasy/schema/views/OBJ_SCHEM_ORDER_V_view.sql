-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW obj_schem_order_v (nr_seq_regra, nm_usuario_regra, cd_perfil, cd_estabelecimento, origin) AS Select  NR_SEQ_REGRA,
        null nm_usuario_regra,
        null cd_perfil,
        cd_estabelecimento,
        'E' origin
FROM OBJ_SCHEM_ORDER_ESTAB

union all

Select  NR_SEQ_REGRA,
        null nm_usuario_regra,
        cd_perfil,
        null cd_estabelecimento,
        'P' origin
from OBJ_SCHEM_ORDER_PERFIL

union all

Select  NR_SEQ_REGRA,
        nm_usuario_regra,
        null cd_perfil,
        null cd_estabelecimento,
        'U' origin
from OBJ_SCHEM_ORDER_USUARIO;
