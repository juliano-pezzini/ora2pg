-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_rooms_pano_bed ( nm_usuario_p text, nr_room_p bigint, nr_bed_p bigint ) AS $body$
BEGIN
    UPDATE UNIDADE_ATENDIMENTO
    SET NR_SEQ_ROOM_NUMBER = nr_room_p, NM_USUARIO = nm_usuario_p
    WHERE NR_SEQ_INTERNO = nr_bed_p;
    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_rooms_pano_bed ( nm_usuario_p text, nr_room_p bigint, nr_bed_p bigint ) FROM PUBLIC;
