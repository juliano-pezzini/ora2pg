-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_roteiro_item_seq (nr_seq_roteiro_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_prox_w	bigint;


BEGIN

SELECT	MAX(nr_seq_apres)
INTO STRICT	nr_seq_prox_w
FROM	proj_tp_rot_item
WHERE	nr_seq_roteiro = nr_seq_roteiro_p;

RETURN coalesce(nr_seq_prox_w,0) + 1;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_roteiro_item_seq (nr_seq_roteiro_p bigint) FROM PUBLIC;
