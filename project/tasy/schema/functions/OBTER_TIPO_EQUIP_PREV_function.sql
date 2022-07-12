-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_equip_prev ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_prev_w				bigint;
cd_estabelecimento_w			integer := Wheb_usuario_pck.get_cd_estabelecimento;

BEGIN

select count(*)
into STRICT qt_prev_w
from man_planej_prev
where nr_seq_tipo_equip = nr_sequencia_p
and   ((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''));

RETURN qt_prev_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_equip_prev ( nr_sequencia_p bigint) FROM PUBLIC;

